//
//  RemoteFeedFetcher.swift
//  Feed
//
//  Created by Fahad Almehawas  on 9/29/20.
//  Copyright © 2020 Fahad Al. All rights reserved.
//

import Foundation
//This to prevent the pram for having 4 states

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case faliure(Error)
}

public protocol HTTPClient {
    func get(from url:URL, completion: @escaping (HTTPClientResult) -> Void)
    
}

public final class RemoteFeedFetcher {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    public func fetch(completion: @escaping (Error) -> Void ) {
        client.get(from: url) { result in
            
            switch result {
            case .success:
                completion(.invalidData)
            case .faliure:
                completion(.connectivity)
            }
            
        }
    }
}
