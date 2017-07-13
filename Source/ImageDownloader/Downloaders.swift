//
//  Downloaders.swift
//  CachedImageDownloader
//
//  Created by Kacper Harasim on 08.03.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

public struct Downloaders {

    public func synchronousimageDownloader(with capacity: Int) -> SynchronousDataDownloader<URL, UIImage> {
        let cache = LRUCache<URL, UIImage>(capacity: capacity)
        
        return SynchronousDataDownloader(
            cache: CacheableBoxHelper(cache),
            transform: { url in
                let data = try? Data(contentsOf: url)
                return data.flatMap(UIImage.init(data:))
            }
        )
    }

    public func urlSessionImageDownloader(with capacity: Int) -> AsynchronousDataDownloader<URL, UIImage> {
        let cache = LRUCache<URL, UIImage>(capacity: capacity)

        return AsynchronousDataDownloader(
            cache: CacheableBoxHelper(cache),
            operation: { url, completion in
                let session = URLSession(configuration: URLSessionConfiguration.default)
                session.dataTask(with: url) { (data, _, _) in
                    completion(data.flatMap(UIImage.init(data:)))
                }
            }
        )
    }
}
