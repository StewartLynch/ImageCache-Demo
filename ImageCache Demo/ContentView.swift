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

    var body: some View {
        NavigationStack {
            List(photoStore.photos) { photo in
                PhotoRow(photo: photo)
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
            }
            .safeAreaInset(edge: .bottom) {
                Text("Starter: \(photoStore.photos.count) JSON photos loaded. AsyncImage owns the image loading behavior.")
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
            AsyncImage(url: photo.thumbnailURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 96, height: 72)
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 96, height: 72)
                        .clipShape(.rect(cornerRadius: 8))
                case .failure:
                    Image(systemName: "photo.badge.exclamationmark")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                        .frame(width: 96, height: 72)
                @unknown default:
                    EmptyView()
                }
            }
            .background(.quaternary)
            .clipShape(.rect(cornerRadius: 8))

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
