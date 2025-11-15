//
//  Tokens.swift
//  DesignSystem
//
//  Created by Fuchs on 2/11/25.
//

import SwiftUI

public enum DS {
    public enum Spacing {
        public static let xs: CGFloat = 6
        public static let s: CGFloat = 10
        public static let m: CGFloat = 16
        public static let l: CGFloat = 24
        public static let xl: CGFloat = 32
    }

    public enum Radius {
        public static let s: CGFloat = 10
        public static let m: CGFloat = 16
        public static let l: CGFloat = 20
    }
}

public extension Color {
    static let dsBackground = Color(UIColor.systemBackground)
    static let dsCard = Color(UIColor.secondarySystemBackground)
}
