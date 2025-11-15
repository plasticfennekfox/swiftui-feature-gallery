//
//  FeatureTextRichScreen.swift
//  Features
//
//  Created by Fuchs on 11/11/25.
//

import SwiftUI
import AppCore
import DesignSystem

public struct FeatureTextRichScreen: View {
    let container: AppContainer

    public init(container: AppContainer) {
        self.container = container
    }

    public var body: some View {
        FeatureScreen(
            title: NSLocalizedString(
                "route.textRich.title",
                comment: "Text and rich content screen title"
            )
        ) {
            typographyCard
            markdownCard
            attributedCard
            selectableCard
        }
    }

    // MARK: - Cards

    /// Базовая типографика: разные размеры и веса шрифта
    private var typographyCard: some View {
        Card {
            Text("textRich.typography.title")
                .font(.headline)

            Text("textRich.typography.largeTitle")
                .font(.largeTitle.bold())

            Text("textRich.typography.titleText")
                .font(.title2)

            Text("textRich.typography.body")
                .font(.body)

            Text("textRich.typography.caption")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    /// Markdown-текст в одном Text
    private var markdownCard: some View {
        Card {
            Text("textRich.markdown.title")
                .font(.headline)

            Text("textRich.markdown.inline")
                .font(.body)

            Text("textRich.markdown.list")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.top, DS.Spacing.s)
        }
    }

    /// Пример AttributedString с разными стилями в одной строке
    private var attributedCard: some View {
        Card {
            Text("textRich.attributed.title")
                .font(.headline)

            Text(makeAttributedText())
                .font(.body)
        }
    }

    /// Выделяемый текст, моноширинный шрифт и SF Symbol
    private var selectableCard: some View {
        Card {
            Text("textRich.selectable.title")
                .font(.headline)

            Text("textRich.selectable.paragraph")
                .textSelection(.enabled)

            Text("textRich.selectable.monoDigits")
                .font(.system(.body, design: .monospaced))
                .padding(.top, DS.Spacing.s)

            Label("textRich.selectable.label", systemImage: "textformat.alt")
                .padding(.top, DS.Spacing.s)
        }
    }

    // MARK: - AttributedString builder

    private func makeAttributedText() -> AttributedString {
        var base: AttributedString = AttributedString(
            NSLocalizedString(
                "textRich.attributed.prefix",
                comment: "Prefix for attributed text example"
            )
        )

        var highlighted: AttributedString = AttributedString(
            NSLocalizedString(
                "textRich.attributed.highlight",
                comment: "Highlighted part for attributed text example"
            )
        )
        highlighted.foregroundColor = .blue
        highlighted.font = .body.bold()

        var trailing: AttributedString = AttributedString(
            NSLocalizedString(
                "textRich.attributed.suffix",
                comment: "Suffix for attributed text example"
            )
        )
        trailing.font = .footnote
        trailing.foregroundColor = .secondary

        base.append(highlighted)
        base.append(trailing)

        return base
    }
}
