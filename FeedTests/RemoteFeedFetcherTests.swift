//
//  RemoteFeedFetcherTests.swift
//  FeedTests
//
//  Created by Fahad Almehawas  on 9/28/20.
//  Copyright © 2020 Fahad Al. All rights reserved.
//

import XCTest

class RemoteFeedFetcher {
    func fetch() {
        
    }
}

class HTTPClient {
    var requestedURL: URL?
}

class RemoteFeedFetcherTests: XCTestCase {
    
    func test_init_NotRequestedFromURL() {
        let client = HTTPClient()
        _ = RemoteFeedFetcher()
    
        XCTAssertNil(client.requestedURL)
    }
    
}
