//
//  DataDownloader.swift
//  CachedImageDownloader
//
//  Created by Kacper Harasim on 08.03.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

public final class SynchronousDataDownloader<Key: Hashable, Value> {

    private let cache: CacheableBox<Key, Value>
    private let transform: (Key) -> Value?

    public init(cache: CacheableBox<Key, Value>, transform: @escaping (Key) -> Value?) {
        self.cache = cache
        self.transform = transform
    }

    public func getData(for key: Key) -> Value? {
        if let cachedValue = cache[key] {
            return cachedValue
        } else {
            let transformed = transform(key)
            self.cache[key] = transformed
            return transformed
        }
    }
}
