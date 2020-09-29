//
//  RemoteFeedFetcherTests.swift
//  FeedTests
//
//  Created by Fahad Almehawas  on 9/28/20.
//  Copyright © 2020 Fahad Al. All rights reserved.
//

import XCTest
import Feed

class RemoteFeedFetcherTests: XCTestCase {
    
    func test_init_NotRequestedFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_fetch_reuqestedDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.fetch()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    
    func test_fetchTwice_reuqestedDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.fetch()
        sut.fetch()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_fetch_DeliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        client.error = NSError(domain: "Test", code: 0)
        
        var capturedErrors = [RemoteFeedFetcher.Error]()
        
        sut.fetch { capturedErrors.append($0)}
        
        XCTAssertEqual(capturedErrors, [.connectivity])
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
        var requestedURLs = [URL]()
        var error: Error?
        
        func get(from url: URL, completion: @escaping (Error) -> Void) {
            if let error = error {
                completion(error)
            }
            requestedURLs.append(url)
        }
        
    }
}

