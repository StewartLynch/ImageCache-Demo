//
//----------------------------------------------
// Original project: ImageCache Demo
//
// Follow me on Mastodon: https://iosdev.space/@StewartLynch
// Follow me on Threads: https://www.threads.net/@stewartlynch
// Follow me on Bluesky: https://bsky.app/profile/stewartlynch.bsky.social
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Email: slynch@createchsol.com
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch
//----------------------------------------------
// Copyright © 2026 CreaTECH Solutions (Stewart Lynch). All rights reserved.


import SwiftUI

struct ContentView: View {
    @State private var photoStore = PhotoStore()
    @State private var imageCache = ImageCache()
    @State private var metrics = ImageLoadMetrics()

    var body: some View {
        NavigationStack {
            List(photoStore.photos) { photo in
                PhotoRow(photo: photo)
                    .environment(imageCache)
                    .environment(metrics)
            }
            .listStyle(.plain)
            .navigationTitle("Image Cache Demo")
            .overlay {
                if photoStore.isLoading && photoStore.photos.isEmpty {
                    ProgressView("Loading photos...")
                } else if let errorMessage = photoStore.errorMessage {
                    ContentUnavailableView("Loading Failed", systemImage: "wifi.exclamationmark", description: Text(errorMessage))
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button {
                        previousPageButtonTapped()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(!photoStore.canLoadPreviousPage)

                    Text("Page \(photoStore.selectedPage)")
                        .font(.subheadline)
                        .fixedSize()

                    Button {
                        nextPageButtonTapped()
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(!photoStore.canLoadNextPage)
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Clear Cache") {
                        imageCache.removeAll()
                        metrics.reset()
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Label("\(photoStore.photos.count)", systemImage: "photo.stack")
                    Label("\(metrics.networkLoads)", systemImage: "network")
                    Label("\(metrics.cacheHits)", systemImage: "externaldrive.fill.badge.checkmark")
                }
                .padding(.top)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .background(.bar)
            }
            .task {
                await photoStore.loadSelectedPage()
            }
        }
    }

    private func previousPageButtonTapped() {
        photoStore.selectPreviousPage()
        Task {
            await photoStore.loadSelectedPage()
        }
    }

    private func nextPageButtonTapped() {
        photoStore.selectNextPage()
        Task {
            await photoStore.loadSelectedPage()
        }
    }
}

private struct PhotoRow: View {
    let photo: RemotePhoto

    var body: some View {
        HStack {
            CachedAsyncImage(
                cacheKey: photo.id,
                url: photo.thumbnailURL
            )
            VStack(alignment: .leading) {
                Text(photo.title)
                    .font(.headline)
                Text(photo.caption)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    ContentView()
}
