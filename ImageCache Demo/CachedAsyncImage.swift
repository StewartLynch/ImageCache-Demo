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

private enum LoadingPhase {
    case empty
    case success(UIImage)
    case failure
}
struct CachedAsyncImage: View {
    @Environment(ImageCache.self) private var imageCache
    @Environment(ImageLoadMetrics.self) private var metrics
    
    let cacheKey: String
    let url: URL
    @State private var phase = LoadingPhase.empty
    
    var body: some View {
        Group {
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: 96, height: 72)
            case let .success(image):
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 96, height: 72)
                    .clipShape(.rect(cornerRadius: 8))
            case .failure:
                Image(systemName: "photo.badge.exclamationmark")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                    .frame(width: 96, height: 72)
            }
        }
        .background(.quaternary)
        .clipShape(.rect(cornerRadius: 8))
        .task {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        phase = .empty
        if let cachedImage = imageCache.image(forKey: cacheKey) {
            metrics.recordCacheHit()
            phase = .success(cachedImage)
            return
        }
        
        do {
            metrics.recordNetworkLoads()
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse, 200...300 ~= response.statusCode else {
                phase = .failure
                return
            }
            guard let image = UIImage(data: data) else {
                phase = .failure
                return
            }
            imageCache.insert(image, forKey: cacheKey)
            phase = .success(image)
        } catch {
            phase = .failure
        }
    }
}
