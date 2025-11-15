//
//  FeatureWidgetsScreen.swift
//  Features
//
//  Created by Fuchs on 13/11/25.
//

import SwiftUI
import AppCore
import DesignSystem

public struct FeatureWidgetsScreen: View {
    let container: AppContainer

    public init(container: AppContainer) {
        self.container = container
    }

    public var body: some View {
        FeatureScreen(
            title: NSLocalizedString(
                "route.widgets.title",
                comment: "Widgets and Live Activities screen title"
            )
        ) {
            overviewCard
            widgetsPreviewCard
            liveActivityPreviewCard
            implementationStepsCard
        }
    }

    // MARK: - Cards

    /// Widgets / Live Activities
    private var overviewCard: some View {
        Card {
            Text("widgets.overview.title")
                .font(.headline)

            Text("widgets.overview.body")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    private var widgetsPreviewCard: some View {
        Card {
            Text("widgets.preview.widgets.title")
                .font(.headline)

            Text("widgets.preview.widgets.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack(spacing: DS.Spacing.m) {
                WidgetPreviewSmall()
                WidgetPreviewMedium()
            }
            .padding(.top, DS.Spacing.m)
        }
    }

    private var liveActivityPreviewCard: some View {
        Card {
            Text("widgets.preview.liveActivity.title")
                .font(.headline)

            Text("widgets.preview.liveActivity.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            LiveActivityPreview()
                .padding(.top, DS.Spacing.m)
        }
    }

    private var implementationStepsCard: some View {
        Card {
            Text("widgets.steps.title")
                .font(.headline)

            VStack(alignment: .leading, spacing: DS.Spacing.s) {
                bullet(
                    "widgets.steps.1.title",
                    detail: "widgets.steps.1.detail"
                )
                bullet(
                    "widgets.steps.2.title",
                    detail: "widgets.steps.2.detail"
                )
                bullet(
                    "widgets.steps.3.title",
                    detail: "widgets.steps.3.detail"
                )
                bullet(
                    "widgets.steps.4.title",
                    detail: "widgets.steps.4.detail"
                )
                bullet(
                    "widgets.steps.5.title",
                    detail: "widgets.steps.5.detail"
                )
            }
            .font(.footnote)
            .foregroundColor(.secondary)
        }
    }

    private func bullet(
        _ titleKey: LocalizedStringKey,
        detail detailKey: LocalizedStringKey
    ) -> some View {
        HStack(alignment: .top, spacing: DS.Spacing.s) {
            Text("•")
            VStack(alignment: .leading, spacing: 2.0) {
                Text(titleKey)
                    .font(.subheadline)
                Text(detailKey)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Small widget preview

private struct WidgetPreviewSmall: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.blue.opacity(0.9),
                            Color.purple.opacity(0.8)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 110.0, height: 110.0)

            VStack(alignment: .leading, spacing: 4.0) {
                Text("widgets.small.header")
                    .font(.caption2.bold())
                    .foregroundColor(.white.opacity(0.9))
                Text("widgets.small.tasks")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("widgets.small.dueSoon")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(10.0)
        }
    }
}

// MARK: - Medium widget preview

private struct WidgetPreviewMedium: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(Color.dsCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 16.0)
                        .strokeBorder(
                            Color.secondary.opacity(0.25),
                            lineWidth: 1.0
                        )
                )
                .frame(width: 210.0, height: 110.0)

            HStack(spacing: 12.0) {
                VStack(alignment: .leading, spacing: 6.0) {
                    Text("widgets.medium.title")
                        .font(.subheadline.bold())
                    Text("widgets.medium.subtitle")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    ProgressView(value: 0.6)
                        .tint(.blue)
                }

                Spacer()

                VStack(spacing: 8.0) {
                    Image(systemName: "timer")
                        .font(.title2)
                        .foregroundColor(.blue)
                    Text("widgets.medium.time")
                        .font(.headline.monospacedDigit())
                    Text("widgets.medium.ofTotal")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(12.0)
        }
    }
}

// MARK: - Live Activity preview

private struct LiveActivityPreview: View {
    var body: some View {
        VStack(spacing: DS.Spacing.s) {
            HStack(spacing: 12.0) {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.15))
                        .frame(width: 32.0, height: 32.0)
                    Image(systemName: "bicycle")
                        .foregroundColor(.green)
                }

                VStack(alignment: .leading, spacing: 2.0) {
                    Text("widgets.live.title")
                        .font(.subheadline.bold())
                    Text("widgets.live.subtitle")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2.0) {
                    Text("widgets.live.eta")
                        .font(.caption2.monospacedDigit())
                    Text("widgets.live.badge")
                        .font(.caption2.bold())
                        .padding(.horizontal, 6.0)
                        .padding(.vertical, 2.0)
                        .background(
                            Capsule()
                                .fill(Color.red.opacity(0.15))
                        )
                        .foregroundColor(.red)
                }
            }
            .padding(10.0)
            .background(
                Capsule()
                    .fill(Color.dsCard)
                    .shadow(radius: 4.0)
            )

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.secondary.opacity(0.2))
                    .frame(height: 6.0)

                Capsule()
                    .fill(Color.green)
                    .frame(width: 160.0, height: 6.0)
            }
        }
    }
}
