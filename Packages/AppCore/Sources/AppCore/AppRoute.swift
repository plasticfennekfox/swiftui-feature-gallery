// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

public enum AppRoute: Codable, Hashable {
    case catalog
    case forms, lists, navigation, textRich
    case animations, gesturesDnD, charts, imagesDrawing
    case swiftData, networking, widgets, uikitInterop, mapsStatic
}

public extension AppRoute {
    static var showcaseCases: [AppRoute] {
        [.forms, .lists, .navigation, .textRich, .animations, .gesturesDnD, .charts, .imagesDrawing, .swiftData, .networking, .widgets, .uikitInterop, .mapsStatic]
    }

    var title: String {
        switch self {
        case .catalog:
            return L10n.tr("route.catalog.title")
        case .forms:
            return L10n.tr("route.forms.title")
        case .lists:
            return L10n.tr("route.lists.title")
        case .navigation:
            return L10n.tr("route.navigation.title")
        case .textRich:
            return L10n.tr("route.textRich.title")
        case .animations:
            return L10n.tr("route.animations.title")
        case .gesturesDnD:
            return L10n.tr("route.gesturesDnD.title")
        case .charts:
            return L10n.tr("route.charts.title")
        case .imagesDrawing:
            return L10n.tr("route.imagesDrawing.title")
        case .swiftData:
            return L10n.tr("route.swiftData.title")
        case .networking:
            return L10n.tr("route.networking.title")
        case .widgets:
            return L10n.tr("route.widgets.title")
        case .uikitInterop:
            return L10n.tr("route.uikitInterop.title")
        case .mapsStatic:
            return L10n.tr("route.mapsStatic.title")
        }
    }

    var systemImage: String {
        switch self {
        case .catalog: return "square.grid.2x2"
        case .forms: return "rectangle.and.pencil.and.ellipsis"
        case .lists: return "list.bullet"
        case .navigation: return "arrow.triangle.turn.up.right.diamond"
        case .textRich: return "textformat"
        case .animations: return "sparkles"
        case .gesturesDnD: return "hand.draw"
        case .charts: return "chart.bar.xaxis"
        case .imagesDrawing: return "paintpalette"
        case .swiftData: return "tray.full"
        case .networking: return "arrow.down.circle"
        case .widgets: return "app.badge"
        case .uikitInterop: return "square.stack.3d.up"
        case .mapsStatic: return "map"
        }
    }
}
