//
//  SwiftNote.swift
//  Features
//
//  Created by Fuchs on 9/11/25.
//

import Foundation
import SwiftData

@Model
public final class SwiftNote {
    public var title: String
    public var text: String
    public var isPinned: Bool
    public var createdAt: Date
    public var priority: NotePriority

    public init(
        title: String,
        text: String,
        isPinned: Bool = false,
        createdAt: Date = .now,
        priority: NotePriority = .normal
    ) {
        self.title = title
        self.text = text
        self.isPinned = isPinned
        self.createdAt = createdAt
        self.priority = priority
    }
}

public enum NotePriority: String, Codable, CaseIterable, Identifiable {
    case low, normal, high

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .low: return "Low"
        case .normal: return "Normal"
        case .high: return "High"
        }
    }
}
