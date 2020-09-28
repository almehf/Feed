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
        HTTPClient.shared.get(from: URL(string: "https://a-url.com")!)
    }
}

class HTTPClient {
    static var shared = HTTPClient()
    func get(from url:URL?) {}
    
}

//Swap the HTTPClient shared instance with spy subclass durning tests.

class HTTPClientSpy: HTTPClient {
    override func get(from url:URL?) {
        requestedURL = url
    }
    
    var requestedURL: URL?
}

class RemoteFeedFetcherTests: XCTestCase {
    
    func test_init_NotRequestedFromURL() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        _ = RemoteFeedFetcher()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_fetch_reuqestedDataFromURL() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        let sut = RemoteFeedFetcher()
        
        sut.fetch()
        XCTAssertNotNil(client.requestedURL)
    }
    
}
