
//
//  FeatureChartsScreen.swift
//  Features
//
//  Created by Fuchs on 4/11/25.
//

import SwiftUI
import Charts
import AppCore
import DesignSystem

public struct FeatureChartsScreen: View {
    let container: AppContainer

    @State private var selectedCategory: TaskCategory? = nil

    public init(container: AppContainer) {
        self.container = container
    }

    private var weekData: [DaySteps] { DaySteps.sampleWeek }
    private var categoryData: [TaskStat] { TaskStat.sample }

    private var maxSteps: Int {
        weekData.map(\.value).max() ?? 0
    }

    public var body: some View {
        FeatureScreen(
            title: NSLocalizedString("route.charts.title", comment: "Charts feature title")
        ) {
            lineChartCard
            barChartCard
            mixedChartCard
        }
    }

    // MARK: - 1. Line chart

    private var lineChartCard: some View {
        Card {
            Text("charts.line.title")
                .font(.headline)

            Text("charts.line.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Chart(weekData) { day in
                LineMark(
                    x: .value(
                        NSLocalizedString("charts.axis.day", comment: "X axis label: Day"),
                        day.weekday
                    ),
                    y: .value(
                        NSLocalizedString("charts.axis.value", comment: "Y axis label: Value"),
                        day.value
                    )
                )
                PointMark(
                    x: .value(
                        NSLocalizedString("charts.axis.day", comment: "X axis label: Day"),
                        day.weekday
                    ),
                    y: .value(
                        NSLocalizedString("charts.axis.value", comment: "Y axis label: Value"),
                        day.value
                    )
                )
            }
            .chartYScale(domain: 0...Double(maxSteps + 500))
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .frame(height: 200)
        }
    }

    // MARK: - 2. Bar chart

    private var barChartCard: some View {
        Card {
            Text("charts.bar.title")
                .font(.headline)

            Text("charts.bar.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Chart(categoryData) { item in
                BarMark(
                    x: .value(
                        NSLocalizedString("charts.axis.minutes", comment: "X axis label: Minutes"),
                        item.minutes
                    ),
                    y: .value(
                        NSLocalizedString("charts.axis.category", comment: "Y axis label: Category"),
                        item.category.title
                    )
                )
                .foregroundStyle(item.category.color)
            }
            .frame(height: 220)

            if let selectedCategory {
                let selectedTemplate = NSLocalizedString(
                    "charts.bar.selected",
                    comment: "Selected category prefix"
                )
                Text(
                    String(
                        format: selectedTemplate,
                        selectedCategory.title
                    )
                )
                .font(.footnote)
                .foregroundColor(.secondary)
            } else {
                Text("charts.bar.legend.hint")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }

            HStack {
                ForEach(TaskCategory.allCases) { category in
                    Button {
                        selectedCategory = category
                        container.analytics.track(
                            "charts.category.select",
                            params: ["category": category.rawValue]
                        )
                    } label: {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(category.color)
                                .frame(width: 8, height: 8)
                            Text(category.title)
                                .font(.caption)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(
                                    selectedCategory == category
                                    ? category.color.opacity(0.15)
                                    : Color.dsCard
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, DS.Spacing.s)
        }
    }

    // MARK: - 3. Mixed chart (area + rule)

    private var mixedChartCard: some View {
        Card {
            Text("charts.mixed.title")
                .font(.headline)

            Text("charts.mixed.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            let average = Double(weekData.map(\.value).reduce(0, +)) / Double(weekData.count)

            Chart {
                ForEach(weekData) { day in
                    AreaMark(
                        x: .value(
                            NSLocalizedString("charts.axis.day", comment: "X axis label: Day"),
                            day.weekday
                        ),
                        y: .value(
                            NSLocalizedString("charts.axis.value", comment: "Y axis label: Value"),
                            day.value
                        )
                    )
                }

                RuleMark(
                    y: .value(
                        NSLocalizedString("charts.axis.average", comment: "Y axis label: Average"),
                        average
                    )
                )
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))
                .foregroundStyle(.red)
            }
            .chartYScale(domain: 0...Double(maxSteps + 500))
            .frame(height: 220)

            let averageTemplate = NSLocalizedString(
                "charts.mixed.averageValue",
                comment: "Text with average value"
            )

            Text(
                String(
                    format: averageTemplate,
                    Int(average)
                )
            )
            .font(.footnote)
            .foregroundColor(.secondary)
        }
    }
}

// MARK: - Models for charts

public struct DaySteps: Identifiable, Hashable {
    public let id = UUID()
    public let weekday: String
    public let value: Int

    public init(weekday: String, value: Int) {
        self.weekday = weekday
        self.value = value
    }
}

public extension DaySteps {
    static var sampleWeek: [DaySteps] {
        [
            DaySteps(
                weekday: NSLocalizedString("charts.weekday.mon", comment: "Monday short title"),
                value: 3400
            ),
            DaySteps(
                weekday: NSLocalizedString("charts.weekday.tue", comment: "Tuesday short title"),
                value: 5200
            ),
            DaySteps(
                weekday: NSLocalizedString("charts.weekday.wed", comment: "Wednesday short title"),
                value: 6100
            ),
            DaySteps(
                weekday: NSLocalizedString("charts.weekday.thu", comment: "Thursday short title"),
                value: 4300
            ),
            DaySteps(
                weekday: NSLocalizedString("charts.weekday.fri", comment: "Friday short title"),
                value: 7300
            ),
            DaySteps(
                weekday: NSLocalizedString("charts.weekday.sat", comment: "Saturday short title"),
                value: 8800
            ),
            DaySteps(
                weekday: NSLocalizedString("charts.weekday.sun", comment: "Sunday short title"),
                value: 4600
            )
        ]
    }
}

public enum TaskCategory: String, CaseIterable, Identifiable {
    case focus
    case meetings
    case coding
    case review

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .focus:
            return NSLocalizedString(
                "charts.category.focus",
                comment: "Focus category title"
            )
        case .meetings:
            return NSLocalizedString(
                "charts.category.meetings",
                comment: "Meetings category title"
            )
        case .coding:
            return NSLocalizedString(
                "charts.category.coding",
                comment: "Coding category title"
            )
        case .review:
            return NSLocalizedString(
                "charts.category.review",
                comment: "Review category title"
            )
        }
    }

    public var color: Color {
        switch self {
        case .focus:
            return .blue
        case .meetings:
            return .orange
        case .coding:
            return .green
        case .review:
            return .purple
        }
    }
}

public struct TaskStat: Identifiable, Hashable {
    public let id = UUID()
    public let category: TaskCategory
    public let minutes: Int

    public init(category: TaskCategory, minutes: Int) {
        self.category = category
        self.minutes = minutes
    }
}

public extension TaskStat {
    static var sample: [TaskStat] {
        [
            TaskStat(category: .focus,    minutes: 120),
            TaskStat(category: .meetings, minutes: 90),
            TaskStat(category: .coding,   minutes: 240),
            TaskStat(category: .review,   minutes: 60)
        ]
    }
}
