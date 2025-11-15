//
//  DestinationView.swift
//  ExampleApp
//
//  Created by Fuchs on 1/11/25.
//

import SwiftUI
import AppCore
import DesignSystem

import FeatureForms
import FeatureLists
import FeatureNavigation
import FeatureTextRich
import FeatureAnimations
import FeatureGesturesDnD
import FeatureCharts
import FeatureImagesDrawing
import FeatureSwiftData
import FeatureNetworking
import FeatureWidgets
import FeatureUIKitInterop
import FeatureMapsStatic

struct DestinationView: View {
    let route: AppRoute
    let container: AppContainer
    
    var body: some View {
        switch route {
        case .catalog:
            AnyView(FeatureScreen(title: "Catalog") { Text("Open items from the list.") })
        case .forms:
            AnyView(FeatureFormsScreen(container: container))
        case .lists:
            AnyView(FeatureListsScreen(container: container))
        case .navigation:
            AnyView(FeatureNavigationScreen(container: container))
        case .textRich:
            AnyView(FeatureTextRichScreen(container: container))
        case .animations:
            AnyView(FeatureAnimationsScreen(container: container))
        case .gesturesDnD:
            AnyView(FeatureGesturesDnDScreen(container: container))
        case .charts:
            AnyView(FeatureChartsScreen(container: container))
        case .imagesDrawing:
            AnyView(FeatureImagesDrawingScreen(container: container))
        case .swiftData:
            AnyView(FeatureSwiftDataScreen(container: container))
        case .networking:
            AnyView(FeatureNetworkingScreen(container: container))
        case .widgets:
            AnyView(FeatureWidgetsScreen(container: container))
        case .uikitInterop:
            AnyView(FeatureUIKitInteropScreen(container: container))
        case .mapsStatic:
            AnyView(FeatureMapsStaticScreen(container: container))
        }
    }
}
