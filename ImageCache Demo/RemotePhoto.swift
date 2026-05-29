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

struct RemotePhoto: Decodable, Identifiable {
    let id: String
    let author: String

    var title: String {
        "Photo #\(id)"
    }

    var caption: String {
        "By \(author)"
    }

    var thumbnailURL: URL {
        URL(string: "https://picsum.photos/id/\(id)/320/240")!
    }
}
