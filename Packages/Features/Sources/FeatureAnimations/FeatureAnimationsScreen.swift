//
//  FeatureAnimationsScreen.swift
//  Features
//
//  Created by Fuchs on 4/11/25.
//

import SwiftUI
import AppCore
import DesignSystem

public struct FeatureAnimationsScreen: View {
    let container: AppContainer

    // MARK: State

    @State private var isOn = false                // implicit
    @State private var showBars = false            // explicit
    @State private var badgeOnLeft = true          // matchedGeometry
    @Namespace private var badgeNamespace

    public init(container: AppContainer) {
        self.container = container
    }

    public var body: some View {
        FeatureScreen(title: String(localized: "animations.title")) {
            implicitCard
            explicitCard
            matchedGeometryCard
            phaseAnimatorCard
        }
    }

    // MARK: - Cards

    /// Неявная анимация по изменению state
    private var implicitCard: some View {
        Card {
            Text("animations.implicit.title")
                .font(.headline)

            Text("animations.implicit.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            RoundedRectangle(cornerRadius: 20)
                .fill(isOn ? Color.blue.opacity(0.8) : Color.gray.opacity(0.3))
                .frame(width: isOn ? 220 : 120, height: 60)
                .scaleEffect(isOn ? 1.05 : 1.0)
                .rotationEffect(.degrees(isOn ? 3 : 0))
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isOn)

            AppButton(
                isOn
                ? String(localized: "animations.implicit.button.off")
                : String(localized: "animations.implicit.button.on")
            ) {
                isOn.toggle()
                container.logger.log("Implicit toggle: \(isOn)", category: "animations")
            }
        }
    }

    /// Явная анимация через withAnimation
    private var explicitCard: some View {
        Card {
            Text("animations.explicit.title")
                .font(.headline)

            Text("animations.explicit.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack(alignment: .bottom, spacing: DS.Spacing.m) {
                bar(height: showBars ? 40 : 10, delay: 0.0)
                bar(height: showBars ? 80 : 15, delay: 0.05)
                bar(height: showBars ? 55 : 20, delay: 0.1)
                bar(height: showBars ? 95 : 25, delay: 0.15)
            }
            .frame(height: 110)

            AppButton(
                showBars
                ? String(localized: "animations.explicit.button.reset")
                : String(localized: "animations.explicit.button.animate")
            ) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    showBars.toggle()
                }
            }
        }
    }

    private func bar(height: CGFloat, delay: Double) -> some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(Color.blue)
            .frame(width: 10, height: height)
            .animation(.easeInOut(duration: 0.4).delay(delay), value: showBars)
    }

    /// matchedGeometryEffect перелёт бейджа между контейнерами
    private var matchedGeometryCard: some View {
        Card {
            Text("animations.matched.title")
                .font(.headline)

            Text("animations.matched.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack(spacing: DS.Spacing.l) {
                matchedBox(titleKey: "animations.matched.left", isActive: badgeOnLeft)
                matchedBox(titleKey: "animations.matched.right", isActive: !badgeOnLeft)
            }

            AppButton(String(localized: "animations.matched.button.toggleBadge")) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    badgeOnLeft.toggle()
                }
            }
        }
    }

    private func matchedBox(titleKey: LocalizedStringKey, isActive: Bool) -> some View {
        VStack(spacing: DS.Spacing.m) {
            Text(titleKey)
                .font(.subheadline)

            RoundedRectangle(cornerRadius: 16)
                .fill(Color.dsCard)
                .overlay(alignment: .topTrailing) {
                    if isActive {
                        Text("animations.matched.badge")
                            .font(.caption2.bold())
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(Color.blue)
                            )
                            .foregroundColor(.white)
                            .matchedGeometryEffect(id: "badge", in: badgeNamespace)
                            .padding(6)
                    }
                }
                .frame(width: 120, height: 80)
        }
    }

    /// PhaseAnimator — пульсирующая иконка (iOS 17+)
    private var phaseAnimatorCard: some View {
        Card {
            Text("animations.phase.title")
                .font(.headline)

            Text("animations.phase.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            PhaseAnimator([false, true]) { phase in
                Image(systemName: "heart.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.pink)
                    .scaleEffect(phase ? 1.25 : 0.9)
                    .opacity(phase ? 1.0 : 0.6)
            } animation: { _ in
                .easeInOut(duration: 0.6)
                    .repeatForever(autoreverses: true)
            }
            .frame(height: 80)
        }
    }
}
