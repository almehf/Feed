//
//  RemoteFeedFetcherTests.swift
//  FeedTests
//
//  Created by Fahad Almehawas  on 9/28/20.
//  Copyright © 2020 Fahad Al. All rights reserved.
//

import XCTest

class RemoteFeedFetcher {
    let client: HTTPClient
    init(client: HTTPClient) {
        self.client = client
    }
    func fetch() {
        client.get(from: URL(string: "https://a-url.com")!)
    }
}

protocol HTTPClient {
    func get(from url:URL?)
    
}

//Swap the HTTPClient shared instance with spy subclass durning tests.


//It's implementation of the protcol instead of sub type of abstract class 
class HTTPClientSpy: HTTPClient {
     func get(from url:URL?) {
        requestedURL = url
    }
    
    var requestedURL: URL?
}

class RemoteFeedFetcherTests: XCTestCase {
    
    func test_init_NotRequestedFromURL() {
        let client = HTTPClientSpy()
        _ = RemoteFeedFetcher(client:client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_fetch_reuqestedDataFromURL() {
        let client = HTTPClientSpy()
        let sut = RemoteFeedFetcher(client: client)
        
        sut.fetch()
        XCTAssertNotNil(client.requestedURL)
    }
    
}
