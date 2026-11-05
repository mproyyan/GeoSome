import AVFoundation
import AVKit
import MediaAccessibility
import Observation
import SwiftUI
import UIKit

@MainActor
@Observable
final class AccessibilityCaptionCenter {
  static let shared = AccessibilityCaptionCenter()

  struct CaptionItem: Identifiable, Equatable, Sendable {
    let id: UUID
    let text: String
    let soundDescription: String?
    let timestamp: Date

    init(
      id: UUID = UUID(),
      text: String,
      soundDescription: String? = nil,
      timestamp: Date = .now
    ) {
      self.id = id
      self.text = text
      self.soundDescription = soundDescription
      self.timestamp = timestamp
    }
  }

  var currentCaption: CaptionItem?
  var isCaptionsEnabled: Bool
  private var clearTask: Task<Void, Never>?

  init(isCaptionsEnabled: Bool? = nil) {
    self.isCaptionsEnabled = isCaptionsEnabled ?? Self.systemCaptionsPreferred
  }

  static var systemCaptionsPreferred: Bool {
    MACaptionAppearanceGetDisplayType(.user) == .alwaysOn ||
      UIAccessibility.isClosedCaptioningEnabled
  }

  func syncWithSystemPreferences() {
    if Self.systemCaptionsPreferred {
      isCaptionsEnabled = true
    }
  }

  func toggleCaptions() {
    isCaptionsEnabled.toggle()
    if !isCaptionsEnabled {
      dismissCaption()
    }
  }

  func announce(
    _ message: String,
    soundDescription: String? = nil,
    duration: Duration = .seconds(3.5)
  ) {
    UIAccessibility.post(notification: .announcement, argument: message)

    guard isCaptionsEnabled || Self.systemCaptionsPreferred else { return }

    clearTask?.cancel()
    let item = CaptionItem(text: message, soundDescription: soundDescription)
    currentCaption = item

    clearTask = Task { @MainActor in
      try? await Task.sleep(for: duration)
      guard !Task.isCancelled, currentCaption?.id == item.id else { return }
      currentCaption = nil
    }
  }

  func dismissCaption() {
    clearTask?.cancel()
    currentCaption = nil
  }
}

struct AccessibilityCaptionBannerView: View {
  let caption: AccessibilityCaptionCenter.CaptionItem
  var onDismiss: (() -> Void)?

  @Environment(\.colorSchemeContrast) private var contrast
  @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
  @Environment(\.legibilityWeight) private var legibilityWeight

  var body: some View {
    HStack(alignment: .firstTextBaseline, spacing: 10) {
      Image(systemName: "captions.bubble.fill")
        .font(.subheadline.weight(.semibold))
        .foregroundStyle(.white)
        .accessibilityHidden(true)

      VStack(alignment: .leading, spacing: 2) {
        if let soundDescription = caption.soundDescription {
          Text("[\(soundDescription)]")
            .font(.caption.weight(.semibold))
            .foregroundStyle(contrast == .increased ? .white : .white.opacity(0.9))
        }

        Text(caption.text)
          .font(.subheadline.weight(legibilityWeight == .bold ? .bold : .medium))
          .foregroundStyle(.white)
          .fixedSize(horizontal: false, vertical: true)
      }

      Spacer(minLength: 4)

      if let onDismiss {
        Button(action: onDismiss) {
          Image(systemName: "xmark.circle.fill")
            .font(.subheadline)
            .foregroundStyle(.white.opacity(contrast == .increased ? 1.0 : 0.85))
            .frame(minWidth: 44, minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Dismiss caption")
      }
    }
    .padding(.horizontal, 14)
    .padding(.vertical, 10)
    .background(
      RoundedRectangle(cornerRadius: 14, style: .continuous)
        .fill(Color.black.opacity(reduceTransparency || contrast == .increased ? 0.96 : 0.86))
    )
    .overlay(
      RoundedRectangle(cornerRadius: 14, style: .continuous)
        .stroke(
          Color.white.opacity(contrast == .increased ? 0.85 : 0.25),
          lineWidth: contrast == .increased ? 2 : 1
        )
    )
    .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)
    .accessibilityElement(children: .combine)
    .accessibilityLabel(
      caption.soundDescription.map { "[\($0)] \(caption.text)" } ?? caption.text
    )
  }
}

struct AccessibleMediaPlayerView: View {
  let player: AVPlayer
  let title: String
  var transcript: String?
  @State private var captionsEnabled: Bool = AccessibilityCaptionCenter.systemCaptionsPreferred

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      VideoPlayer(player: player)
        .accessibilityLabel(title)
        .accessibilityHint("Double-tap to play or pause")
        .overlay(alignment: .topTrailing) {
          Button(action: toggleCaptions) {
            Image(systemName: captionsEnabled ? "captions.bubble.fill" : "captions.bubble")
              .font(.body.weight(.semibold))
              .foregroundStyle(.white)
              .frame(minWidth: 44, minHeight: 44)
              .background(Color.black.opacity(0.75), in: .circle)
          }
          .buttonStyle(.plain)
          .padding(12)
          .accessibilityLabel(captionsEnabled ? "Captions on" : "Captions off")
          .accessibilityHint("Toggles closed captions and sound descriptions")
          .accessibilityInputLabels(["Captions", "Subtitles", "Toggle Captions"])
        }

      if captionsEnabled, let transcript, !transcript.isEmpty {
        Text(transcript)
          .font(.footnote)
          .foregroundStyle(.primary)
          .padding(12)
          .frame(maxWidth: .infinity, alignment: .leading)
          .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
              .fill(Color(.secondarySystemBackground))
          )
          .accessibilityLabel("Transcript: \(transcript)")
      }
    }
    .task {
      await configureAccessibleMediaTracks(enableCaptions: captionsEnabled)
    }
  }

  private func toggleCaptions() {
    captionsEnabled.toggle()
    Task {
      await configureAccessibleMediaTracks(enableCaptions: captionsEnabled)
    }
  }

  private func configureAccessibleMediaTracks(enableCaptions: Bool) async {
    guard let currentItem = player.currentItem else { return }
    let asset = currentItem.asset

    if let legibleGroup = try? await asset.loadMediaSelectionGroup(for: .legible) {
      if enableCaptions {
        let dialogOptions = AVMediaSelectionGroup.mediaSelectionOptions(
          from: legibleGroup.options,
          withMediaCharacteristics: [.transcribesSpokenDialogForAccessibility]
        )
        let soundOptions = AVMediaSelectionGroup.mediaSelectionOptions(
          from: legibleGroup.options,
          withMediaCharacteristics: [.describesMusicAndSoundForAccessibility]
        )
        if let preferredOption = soundOptions.first ?? dialogOptions.first ?? legibleGroup.options.first {
          currentItem.select(preferredOption, in: legibleGroup)
        }
      } else if legibleGroup.allowsEmptySelection {
        currentItem.select(nil, in: legibleGroup)
      }
    }

    if UIAccessibility.isVoiceOverRunning,
       let audibleGroup = try? await asset.loadMediaSelectionGroup(for: .audible)
    {
      let descriptionOptions = AVMediaSelectionGroup.mediaSelectionOptions(
        from: audibleGroup.options,
        withMediaCharacteristics: [.describesVideoForAccessibility]
      )
      if let adOption = descriptionOptions.first {
        currentItem.select(adOption, in: audibleGroup)
      }
    }
  }
}
