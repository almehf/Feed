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
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    public func fetch(completion: @escaping (Result) -> Void ) {
        client.get(from: url) { result in
            
            switch result {
            case let .success(data, response):
                do {
                   let items = try
                    FeedItemsMapper.map(data, response)
                    completion(.success(items))
                } catch {
                    completion(.failure(.invalidData))
                }
                
            case .faliure:
                completion(.failure(.connectivity))
            }
            
        }
    }
}

private class FeedItemsMapper {

    private struct Root: Decodable {
        let items: [Item]
    }

    private struct Item: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL
        
        var item: FeedItem {
            return FeedItem(id: id, description: description, location: location, imageURL: image)
        }
        
    }

    static var OK_200: Int { return 200}

    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == OK_200 else {
            throw RemoteFeedFetcher.Error.invalidData
        }
        
        let root = try JSONDecoder().decode(Root.self, from: data)
        
        return root.items.map {$0.item}
    }
}

