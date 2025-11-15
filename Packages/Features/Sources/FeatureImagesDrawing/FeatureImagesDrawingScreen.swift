//
//  FeatureImagesDrawingScreen.swift
//  Features
//
//  Created by Fuchs on 5/11/25.
//

import SwiftUI
import AppCore
import DesignSystem

public struct FeatureImagesDrawingScreen: View {
    let container: AppContainer

    @State private var lines: [[CGPoint]] = []
    @State private var activeLine: [CGPoint] = []

    public init(container: AppContainer) {
        self.container = container
    }

    public var body: some View {
        FeatureScreen(
            title: NSLocalizedString(
                "route.imagesDrawing.title",
                comment: "Images and drawing feature title"
            )
        ) {
            basicImagesCard
            masksAndOverlaysCard
            canvasCard
            drawingCard
        }
    }

    // MARK: - 1. Basic images

    private var basicImagesCard: some View {
        Card {
            Text("images.basic.title")
                .font(.headline)

            Text("images.basic.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack(spacing: DS.Spacing.m) {
                Image(systemName: "photo")
                    .font(.system(size: 40.0))
                    .foregroundColor(.blue)

                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 40.0))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.blue, .green)

                Image("example-photo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80.0, height: 50.0)
                    .clipped()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8.0)
                            .strokeBorder(
                                Color.white.opacity(0.7),
                                lineWidth: 1.0
                            )
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 8.0)
                            .fill(Color.black.opacity(0.1))
                    )
            }
        }
    }

    // MARK: - 2. Masks & overlays

    private var masksAndOverlaysCard: some View {
        Card {
            Text("images.masks.title")
                .font(.headline)

            Text("images.masks.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            ZStack {
                LinearGradient(
                    colors: [.blue, .purple, .pink],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 140.0)
                .overlay(
                    GeometryReader { proxy in
                        let width: CGFloat = proxy.size.width
                        let height: CGFloat = proxy.size.height

                        Path { path in
                            stride(from: 0.0, through: width, by: width / 10.0).forEach { x in
                                path.move(to: CGPoint(x: x, y: 0.0))
                                path.addLine(to: CGPoint(x: x, y: height))
                            }
                            stride(from: 0.0, through: height, by: height / 5.0).forEach { y in
                                path.move(to: CGPoint(x: 0.0, y: y))
                                path.addLine(to: CGPoint(x: width, y: y))
                            }
                        }
                        .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 24.0))
                .shadow(radius: 8.0)

                VStack(spacing: 4.0) {
                    Text("images.masks.headerTitle")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("images.masks.headerSubtitle")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
    }

    // MARK: - 3. Canvas demo

    private var canvasCard: some View {
        Card {
            Text("images.canvas.title")
                .font(.headline)

            Text("images.canvas.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Canvas { context, size in
                let rect: CGRect = CGRect(origin: .zero, size: size)
                context.fill(
                    Path(rect),
                    with: .linearGradient(
                        Gradient(
                            colors: [
                                Color.blue.opacity(0.1),
                                Color.purple.opacity(0.3)
                            ]
                        ),
                        startPoint: CGPoint(x: 0.0, y: 0.0),
                        endPoint: CGPoint(x: size.width, y: size.height)
                    )
                )

                let circleCount: Int = 8
                for index in 0..<circleCount {
                    let progress: Double = Double(index) / Double(circleCount - 1)
                    let radius: CGFloat = min(size.width, size.height) * 0.12 * CGFloat(1.0 + progress)
                    let center: CGPoint = CGPoint(
                        x: size.width * CGFloat(0.2 + 0.6 * progress),
                        y: size.height * CGFloat(0.3 + 0.4 * (1.0 - progress))
                    )

                    var circle: Path = Path()
                    circle.addEllipse(
                        in: CGRect(
                            x: center.x - radius,
                            y: center.y - radius,
                            width: radius * 2.0,
                            height: radius * 2.0
                        )
                    )

                    context.stroke(
                        circle,
                        with: .color(Color.white.opacity(0.4)),
                        lineWidth: 1.0
                    )
                }

                var diagonal: Path = Path()
                diagonal.move(to: CGPoint(x: 0.0, y: size.height))
                diagonal.addLine(to: CGPoint(x: size.width, y: 0.0))
                context.stroke(
                    diagonal,
                    with: .color(Color.white.opacity(0.5)),
                    lineWidth: 1.0
                )
            }
            .frame(height: 160.0)
            .clipShape(RoundedRectangle(cornerRadius: DS.Radius.m))
        }
    }

    // MARK: - 4. Free drawing area

    private var drawingCard: some View {
        Card {
            Text("images.freeDrawing.title")
                .font(.headline)

            Text("images.freeDrawing.subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)

            ZStack {
                RoundedRectangle(cornerRadius: DS.Radius.m)
                    .fill(Color.dsBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: DS.Radius.m)
                            .strokeBorder(
                                Color.secondary.opacity(0.3),
                                lineWidth: 1.0
                            )
                    )

                DrawingCanvas(lines: $lines, activeLine: $activeLine)
                    .clipShape(RoundedRectangle(cornerRadius: DS.Radius.m))
            }
            .frame(height: 180.0)

            HStack {
                AppButton("images.freeDrawing.clearButton") {
                    lines.removeAll()
                    activeLine.removeAll()
                }
            }
        }
    }
}

// MARK: - Drawing canvas subview

private struct DrawingCanvas: View {
    @Binding var lines: [[CGPoint]]
    @Binding var activeLine: [CGPoint]

    var body: some View {
        GeometryReader { _ in
            ZStack {
                ForEach(lines.indices, id: \.self) { index in
                    let line: [CGPoint] = lines[index]
                    Path { path in
                        guard let first: CGPoint = line.first else {
                            return
                        }
                        path.move(to: first)
                        for point in line.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                    .stroke(Color.blue, lineWidth: 2.0)
                }

                Path { path in
                    guard let first: CGPoint = activeLine.first else {
                        return
                    }
                    path.move(to: first)
                    for point in activeLine.dropFirst() {
                        path.addLine(to: point)
                    }
                }
                .stroke(Color.green, lineWidth: 2.0)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0.0)
                    .onChanged { value in
                        let point: CGPoint = value.location
                        activeLine.append(point)
                    }
                    .onEnded { _ in
                        if !activeLine.isEmpty {
                            lines.append(activeLine)
                            activeLine.removeAll()
                        }
                    }
            )
        }
    }
}
