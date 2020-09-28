//
//  FeedFetcher.swift
//  Feed
//
//  Created by Fahad Almehawas  on 9/28/20.
//  Copyright © 2020 Fahad Al. All rights reserved.
//

import Foundation

enum FetchFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedFetcher {
    func fetch(completion: @escaping (FetchFeedResult) -> Void)
}
