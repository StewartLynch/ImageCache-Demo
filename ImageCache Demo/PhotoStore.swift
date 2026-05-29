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

import Foundation

@Observable
final class PhotoStore {
    var photos: [RemotePhoto] = []
    var selectedPage = 1
    var isLoading = false
    var errorMessage: String?

    var canLoadPreviousPage: Bool {
        selectedPage > 1
    }

    var canLoadNextPage: Bool {
        selectedPage < 10
    }

    func selectPreviousPage() {
        guard canLoadPreviousPage else { return }
        selectedPage -= 1
    }

    func selectNextPage() {
        guard canLoadNextPage else { return }
        selectedPage += 1
    }

    func loadSelectedPage() async {
        let page = selectedPage
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            photos = try await fetchPage(page)
        } catch {
            errorMessage = "Could not load photos. Please try again."
        }
    }

    private func fetchPage(_ page: Int) async throws -> [RemotePhoto] {
        let url = URL(string: "https://picsum.photos/v2/list?page=\(page)&limit=80")!
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
            throw URLError(.badServerResponse)
        }
        let photos = try JSONDecoder().decode([RemotePhoto].self, from: data)
        guard !photos.isEmpty else {
            throw URLError(.zeroByteResource)
        }
        return photos
    }
}
