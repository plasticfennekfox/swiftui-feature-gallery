//
//  AppRouteTests.swift
//  ExampleApp
//
//  Created by Fuchs on 8/11/25.
//

import XCTest
@testable import AppCore

final class AppRouteTests: XCTestCase {

    func testShowcaseCasesContainsAllNonCatalogRoutes() {
        // Все кейсы кроме .catalog должны быть в showcaseCases
        let allRoutes: [AppRoute] = [
            .forms, .lists, .navigation, .textRich,
            .animations, .gesturesDnD, .charts, .imagesDrawing,
            .swiftData, .networking, .widgets, .uikitInterop, .mapsStatic
        ]

        XCTAssertEqual(
            Set(AppRoute.showcaseCases),
            Set(allRoutes),
            "showcaseCases должен содержать все фичи, кроме .catalog"
        )
    }

    func testTitleIsNotEmpty() {
        for route in AppRoute.showcaseCases + [.catalog] {
            XCTAssertFalse(route.title.trimmingCharacters(in: .whitespaces).isEmpty,
                           "title для \(route) не должен быть пустым")
        }
    }

    func testSystemImageIsNotEmpty() {
        for route in AppRoute.showcaseCases + [.catalog] {
            XCTAssertFalse(route.systemImage.isEmpty,
                           "systemImage для \(route) не должен быть пустым")
        }
    }
}
