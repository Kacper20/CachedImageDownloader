//
//  AsynchronousDataDownloader.swift
//  CachedImageDownloader
//
//  Created by Kacper Harasim on 08.03.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

public final class AsynchronousDataDownloader<Key: Hashable, Value> {

    private let cache: CacheableBox<Key, Value>
    private let operation: (Key, @escaping (Value?) -> Void) -> Void

    public init(cache: CacheableBox<Key, Value>, operation: @escaping (Key, @escaping (Value?) -> Void) -> Void) {
        self.cache = cache
        self.operation = operation
    }

    public func getData(for key: Key, completion: @escaping (Value?) -> Void) {
        if let cachedValue = cache[key] {
            completion(cachedValue)
        } else {
            operation(key) { value in
                self.cache[key] = value
                completion(value)
            }
        }
    }
}
