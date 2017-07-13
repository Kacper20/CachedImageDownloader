//
//  Cache.swift
//  CachedImageDownloader
//
//  Created by Kacper Harasim on 08.03.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation


/// This protocol provides requirements for every type that implements it's own cache policies
public protocol Cacheable {
    associatedtype Key
    associatedtype Value

    subscript(key: Key) -> Value? { get set }
}

public class CacheableBox<K, V>: Cacheable {
    public subscript(key: K) -> V? {
        get {
            fatalError("Abstract method")
        }
        set {
            fatalError("Abstract method")
        }
    }
}

public class CacheableBoxHelper<C: Cacheable>: CacheableBox<C.Key, C.Value> {
    private var cacheable: C

    init(_ cacheable: C) {
        self.cacheable = cacheable
    }

    override public subscript(key: C.Key) -> C.Value? {
        get {
            return cacheable[key]
        }
        set(newValue) {
            cacheable[key] = newValue
        }
    }
}
