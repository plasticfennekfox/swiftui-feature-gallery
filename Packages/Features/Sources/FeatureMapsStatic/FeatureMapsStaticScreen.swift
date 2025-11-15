
//
//  FeatureMapsStaticScreen.swift
//  Features
//
//  Created by Fuchs on 6/11/25.
//

import SwiftUI
import MapKit
import AppCore
import DesignSystem

public struct FeatureMapsStaticScreen: View {
    let container: AppContainer

    @State private var selectedPreset: MapPreset = .applePark
    @State private var cameraPosition: MapCameraPosition = MapPreset.applePark.cameraPosition

    public init(container: AppContainer) {
        self.container = container
    }

    public var body: some View {
        FeatureScreen(
            title: NSLocalizedString(
                "route.mapsStatic.title",
                comment: "Static map feature title"
            )
        ) {
            overviewCard
            simpleStaticCard
            presetsCard
            pinsCard
        }
    }

    // MARK: - Cards

    private var overviewCard: some View {
        Card {
            Text("maps.overview.title")
                .font(.headline)

            Text("maps.overview.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    private var simpleStaticCard: some View {
        Card {
            Text("maps.simple.title")
                .font(.headline)

            Text("maps.simple.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Map(initialPosition: MapPreset.applePark.cameraPosition)
                .frame(height: 200.0)
                .clipShape(RoundedRectangle(cornerRadius: DS.Radius.m))
                .allowsHitTesting(false)
                .mapStyle(.standard)
        }
    }

    private var presetsCard: some View {
        Card {
            Text("maps.presets.title")
                .font(.headline)

            Text("maps.presets.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Picker(
                "maps.presets.picker.label",
                selection: $selectedPreset
            ) {
                ForEach(MapPreset.allCases) { preset in
                    Text(preset.title)
                        .tag(preset)
                }
            }
            .pickerStyle(.segmented)

            Map(position: $cameraPosition)
                .frame(height: 200.0)
                .clipShape(RoundedRectangle(cornerRadius: DS.Radius.m))
                .allowsHitTesting(false)
                .mapStyle(.standard)

            Text(showingPresetText)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .onChange(of: selectedPreset) { newValue in
            withAnimation(.easeInOut(duration: 0.3)) {
                cameraPosition = newValue.cameraPosition
            }
            container.analytics.track(
                "maps.preset_select",
                params: ["preset": newValue.rawValue]
            )
        }
    }

    private var pinsCard: some View {
        Card {
            Text("maps.annotations.title")
                .font(.headline)

            Text("maps.annotations.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Map(initialPosition: .region(Self.worldRegion)) {
                ForEach(MapLocation.sampleLocations) { location in
                    Annotation(location.title, coordinate: location.coordinate) {
                        VStack(spacing: 4.0) {
                            ZStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 22.0, height: 22.0)
                                Text(location.emoji)
                                    .font(.caption)
                            }
                            Text(location.shortTitle)
                                .font(.caption2)
                                .padding(.horizontal, 6.0)
                                .padding(.vertical, 2.0)
                                .background(
                                    RoundedRectangle(cornerRadius: 6.0)
                                        .fill(Color.dsCard)
                                )
                        }
                    }
                }
            }
            .frame(height: 220.0)
            .clipShape(RoundedRectangle(cornerRadius: DS.Radius.m))
            .allowsHitTesting(false)
            .mapStyle(.standard)
        }
    }

    private var showingPresetText: String {
        let template: String = NSLocalizedString(
            "maps.presets.showing",
            comment: "Label that shows which map preset is active"
        )
        return String(format: template, selectedPreset.title)
    }

    private static var worldRegion: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 35.0, longitude: 0.0),
            span: MKCoordinateSpan(latitudeDelta: 100.0, longitudeDelta: 220.0)
        )
    }
}

// MARK: - Presets

private enum MapPreset: String, CaseIterable, Identifiable {
    case applePark
    case sanFrancisco
    case london

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .applePark:
            return NSLocalizedString(
                "maps.preset.applePark",
                comment: "Map preset name: Apple Park"
            )
        case .sanFrancisco:
            return NSLocalizedString(
                "maps.preset.sanFrancisco",
                comment: "Map preset name: San Francisco"
            )
        case .london:
            return NSLocalizedString(
                "maps.preset.london",
                comment: "Map preset name: London"
            )
        }
    }

    var region: MKCoordinateRegion {
        switch self {
        case .applePark:
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: 37.3349,
                    longitude: -122.0090
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.03,
                    longitudeDelta: 0.03
                )
            )
        case .sanFrancisco:
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: 37.7749,
                    longitude: -122.4194
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.2,
                    longitudeDelta: 0.2
                )
            )
        case .london:
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: 51.5072,
                    longitude: -0.1276
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.25,
                    longitudeDelta: 0.25
                )
            )
        }
    }

    var cameraPosition: MapCameraPosition {
        .region(region)
    }
}

// MARK: - Sample locations

private struct MapLocation: Identifiable {
    let id: UUID = UUID()
    let title: String
    let shortTitle: String
    let coordinate: CLLocationCoordinate2D
    let emoji: String

    static var sampleLocations: [MapLocation] {
        [
            MapLocation(
                title: NSLocalizedString(
                    "maps.location.applePark.title",
                    comment: "Full title for Apple Park location"
                ),
                shortTitle: NSLocalizedString(
                    "maps.location.applePark.short",
                    comment: "Short title for Apple Park location"
                ),
                coordinate: CLLocationCoordinate2D(
                    latitude: 37.3349,
                    longitude: -122.0090
                ),
                emoji: "🏢"
            ),
            MapLocation(
                title: NSLocalizedString(
                    "maps.location.sanFrancisco.title",
                    comment: "Full title for San Francisco location"
                ),
                shortTitle: NSLocalizedString(
                    "maps.location.sanFrancisco.short",
                    comment: "Short title for San Francisco location"
                ),
                coordinate: CLLocationCoordinate2D(
                    latitude: 37.7749,
                    longitude: -122.4194
                ),
                emoji: "🌉"
            ),
            MapLocation(
                title: NSLocalizedString(
                    "maps.location.london.title",
                    comment: "Full title for London location"
                ),
                shortTitle: NSLocalizedString(
                    "maps.location.london.short",
                    comment: "Short title for London location"
                ),
                coordinate: CLLocationCoordinate2D(
                    latitude: 51.5072,
                    longitude: -0.1276
                ),
                emoji: "🇬🇧"
            )
        ]
    }
}
