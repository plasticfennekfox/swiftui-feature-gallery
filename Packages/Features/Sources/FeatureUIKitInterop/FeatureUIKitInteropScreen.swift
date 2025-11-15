//
//  FeatureUIKitInteropScreen.swift
//  Features
//
//  Created by Fuchs on 13/11/25.
//

import SwiftUI
import UIKit
import AppCore
import DesignSystem

public struct FeatureUIKitInteropScreen: View {
    let container: AppContainer

    @State private var showShare: Bool = false
    @State private var noteText: String = NSLocalizedString(
        "uikitInterop.textView.placeholder",
        comment: "Default text for embedded UITextView"
    )
    @State private var sliderValue: Double = 0.4

    public init(container: AppContainer) {
        self.container = container
    }

    public var body: some View {
        FeatureScreen(
            title: NSLocalizedString(
                "uikitInterop.title",
                comment: "UIKit interop screen title"
            )
        ) {
            shareCard
            textViewCard
            sliderCard
        }
        .sheet(isPresented: $showShare) {
            ActivityVC(
                items: [
                    NSLocalizedString(
                        "uikitInterop.share.message",
                        comment: "Base share message"
                    ),
                    String(
                        format: NSLocalizedString(
                            "uikitInterop.share.item.currentText",
                            comment: "Share item: current text"
                        ),
                        noteText
                    ),
                    String(
                        format: NSLocalizedString(
                            "uikitInterop.share.item.sliderValue",
                            comment: "Share item: slider value"
                        ),
                        String(format: "%.2f", sliderValue)
                    )
                ]
            )
        }
    }

    // MARK: - Cards

    private var shareCard: some View {
        Card {
            Text("uikitInterop.share.title")
                .font(.headline)

            Text("uikitInterop.share.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            AppButton("uikitInterop.share.button") {
                showShare = true
                container.analytics.track("uikit.share_tap", params: nil)
            }
        }
    }

    private var textViewCard: some View {
        Card {
            Text("uikitInterop.textView.title")
                .font(.headline)

            Text("uikitInterop.textView.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            UIKitTextView(text: $noteText)
                .frame(height: 120.0)

            Text("uikitInterop.textView.currentLabel")
                .font(.caption)
                .foregroundColor(.secondary)

            Text(noteText)
                .font(.footnote)
                .foregroundColor(.primary)
                .lineLimit(3)
        }
    }

    private var sliderCard: some View {
        Card {
            Text("uikitInterop.slider.title")
                .font(.headline)

            Text("uikitInterop.slider.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            UIKitSlider(value: $sliderValue)
                .frame(height: 32.0)

            Text(sliderValueLabel)
                .font(.footnote.monospacedDigit())
                .foregroundColor(.secondary)
        }
    }

    // MARK: - Helpers

    private var sliderValueLabel: String {
        String(
            format: NSLocalizedString(
                "uikitInterop.slider.valueLabel",
                comment: "Slider value label with formatted value"
            ),
            sliderValue
        )
    }
}
