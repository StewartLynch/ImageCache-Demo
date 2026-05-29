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
final class ImageLoadMetrics {
    var networkLoads = 0
    var cacheHits = 0
    
    func recordNetworkLoads() {
        networkLoads += 1
    }
    
    func recordCacheHit() {
        cacheHits += 1
    }
    
    func reset() {
        networkLoads = 0
        cacheHits = 0
    }
}
