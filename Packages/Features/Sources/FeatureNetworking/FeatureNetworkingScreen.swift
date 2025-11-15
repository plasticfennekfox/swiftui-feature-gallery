import SwiftUI
import AppCore
import DesignSystem
import DataLayer

public struct FeatureNetworkingScreen: View {
    let container: AppContainer

    @State private var state: LoadState = .idle

    public init(container: AppContainer) {
        self.container = container
    }

    public var body: some View {
        FeatureScreen(title: L10n.tr("networking.title")) {
            Card {
                header

                Divider()
                    .padding(.vertical, DS.Spacing.s)

                content

                HStack {
                    AppButton(L10n.tr("networking.button.fetch")) {
                        startFetch()
                    }

                    AppButton(L10n.tr("networking.button.reset"), kind: .secondary) {
                        state = .idle
                    }
                }
                .padding(.top, DS.Spacing.m)
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(L10n.tr("networking.request.title"))
                .font(.headline)

            Text(L10n.tr("networking.request.subtitle"))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        switch state {
        case .idle:
            Text(L10n.tr("networking.idle.hint"))
                .font(.footnote)
                .foregroundColor(.secondary)

        case .loading:
            HStack(spacing: DS.Spacing.s) {
                ProgressView()
                Text(L10n.tr("networking.loading"))
            }

        case .success(let response):
            VStack(alignment: .leading, spacing: DS.Spacing.s) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(L10n.tr("networking.label.url"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(response.url)
                        .font(.callout)
                        .textSelection(.enabled)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(L10n.tr("networking.label.origin"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(response.origin)
                        .font(.callout)
                }

                let sortedHeaders = response.headers.sorted { $0.key < $1.key }

                if !sortedHeaders.isEmpty {
                    Divider().padding(.vertical, DS.Spacing.s)

                    Text(L10n.tr("networking.label.headers"))
                        .font(.caption)
                        .foregroundColor(.secondary)

                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(sortedHeaders.prefix(4), id: \.key) { header in
                            HStack {
                                Text(header.key)
                                    .font(.caption)
                                Spacer()
                                Text(header.value)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }

        case .failure(let message):
            VStack(alignment: .leading, spacing: DS.Spacing.s) {
                Text(L10n.tr("networking.label.error"))
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(message)
                    .font(.footnote)
                    .foregroundColor(.red)
            }
        }
    }

    // MARK: - Actions / State

    private enum LoadState {
        case idle
        case loading
        case success(HttpBinGetResponse)
        case failure(String)
    }

    private func startFetch() {
        state = .loading
        container.logger.log("Networking: fetch started", category: "networking")
        container.analytics.track("networking.fetch_tap", params: nil)

        Task {
            do {
                let client = URLSessionNetworkingClient()
                let response = try await client.fetchSampleGet()
                await MainActor.run {
                    state = .success(response)
                    container.logger.log("Networking: success", category: "networking")
                }
            } catch {
                await MainActor.run {
                    state = .failure(error.localizedDescription)
                    container.logger.log("Networking: failed \(error.localizedDescription)", category: "networking")
                }
            }
        }
    }
}
