//
//  RemoteFeedFetcher.swift
//  Feed
//
//  Created by Fahad Almehawas  on 9/29/20.
//  Copyright © 2020 Fahad Al. All rights reserved.
//

import Foundation

public protocol HTTPClient {
    func get(from url:URL, completion: @escaping (Error) -> Void)
    
}

public final class RemoteFeedFetcher {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
    
        case connectivity
    }
    
    
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    public func fetch(completion: @escaping (Error) -> Void ) {
        client.get(from: url) { error in
            completion(.connectivity)
        }
    }
}
