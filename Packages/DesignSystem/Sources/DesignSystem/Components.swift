//
//  Components.swift
//  DesignSystem
//
//  Created by Fuchs on 2/11/25.
//

import SwiftUI

public struct FeatureScreen<Content: View>: View {
    private let title: String
    private let content: () -> Content
    public init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.Spacing.l) {
                content()
            }
            .padding(DS.Spacing.l)
        }
        .background(Color.dsBackground)
        .navigationTitle(title)
    }
}

public struct Card<Content: View>: View {
    private let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.m) {
            content()
        }
        .padding(DS.Spacing.l)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: DS.Radius.m)
                .fill(Color.dsCard)
        )
    }
}


public struct AppButton: View {
    public enum Kind { case primary, secondary }
    private let title: String
    private let kind: Kind
    private let action: () -> Void
    public init(_ title: String, kind: Kind = .primary, action: @escaping () -> Void) {
        self.title = title; self.kind = kind; self.action = action
    }
    public var body: some View {
        Button(action: action) {
            Text(LocalizedStringKey(title))
        }
        .buttonStyle(.borderedProminent)
    }
}
