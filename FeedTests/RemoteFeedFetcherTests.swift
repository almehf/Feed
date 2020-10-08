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
        
        sut.fetch { _ in}
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    
    func test_fetchTwice_reuqestedDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.fetch { _ in}
        sut.fetch { _ in}
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_fetch_DeliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        var capturedErrors = [RemoteFeedFetcher.Error]()
        
        sut.fetch { capturedErrors.append($0)}
        
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    func test_fetch_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        // check less than the value, one value more and couple more randomly
        let smaples = [199, 201, 300, 400, 500]
        smaples.enumerated().forEach { index, code in
            var capturedErrors = [RemoteFeedFetcher.Error]()
            sut.fetch {capturedErrors.append($0)}
            
            client.complete(withStatusCode: code, at: index)
            
            XCTAssertEqual(capturedErrors, [.invalidData])
            
        }
        
    }
    
    func test_fetch_deleiversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        var capturedErrors = [RemoteFeedFetcher.Error]()
        sut.fetch {capturedErrors.append($0)}
        
        let invlaidJSON = Data(bytes: "invalid json".utf8)
        client.complete(withStatusCode: 200, data: invlaidJSON)
        
        XCTAssertEqual(capturedErrors, [.invalidData])
        
        
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
        var completions = [(Error) -> Void]()
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        
        var requestedURLs: [URL] {
            return messages.map {$0.url}
        }
        
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            
            messages.append((url, completion))
            //            completions.append(completion)
        }
        
        func complete(with error: Error, at index:Int = 0) {
            messages[index].completion(.faliure(error))
            
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index],
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil
                )!
            messages[index].completion(.success(data,response))
        }
    }
}

