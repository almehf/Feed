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
    let url: URL
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    func fetch() {
        client.get(from: url)
    }
}

protocol HTTPClient {
    func get(from url:URL)
    
}

class RemoteFeedFetcherTests: XCTestCase {
    
    func test_init_NotRequestedFromURL() {
        let url = URL(string: "https://a-url.com")!
        let (_, client) = makeSUT()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_fetch_reuqestedDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.fetch()
        
        XCTAssertEqual(client.requestedURL, url)
    }
    
    // MARK: Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-given-url.com")!) -> (sut: RemoteFeedFetcher, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut =  RemoteFeedFetcher(url: url, client: client)
        
        return (sut, client )
    }
    
    //Swap the HTTPClient shared instance with spy subclass durning tests.


    //It's implementation of the protcol instead of sub type of abstract class
    class HTTPClientSpy: HTTPClient {
         var requestedURL: URL?
        
         func get(from url:URL) {
            requestedURL = url
        }
    }
}

