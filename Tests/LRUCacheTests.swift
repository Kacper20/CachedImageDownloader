//
//  LRUCacheTests.swift
//  CachedImageDownloader
//
//  Created by Kacper Harasim on 08.03.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import XCTest

@testable import CachedImageDownloader

class LRUCacheTests: XCTestCase {
    func testPurgingAfterReachingCapacity() {
        let cache = LRUCache<String, Int>(capacity: 3)
        cache["1"] = 1
        cache["2"] = 2
        cache["3"] = 3
        XCTAssertNotNil(cache["1"], "Every item should be present at start")
        XCTAssertNotNil(cache["2"], "Every item should be present at start")
        XCTAssertNotNil(cache["3"], "Every item should be present at start")
        cache["4"] = 4
        XCTAssertNotNil(cache["2"], "Item should not be purged")
        XCTAssertNotNil(cache["3"], "Item should not be purged")
        XCTAssertNotNil(cache["4"], "Item should not be purged")
        XCTAssertNil(cache["1"], "Item should be purged because it exceeds capacity of cache")
    }

    func testPriorityChangesWhenTouchingElements() {
        let cache = LRUCache<String, Int>(capacity: 3)
        cache["1"] = 1
        cache["2"] = 2
        cache["3"] = 3
        _ = cache["1"]
        cache["4"] = 4
        XCTAssertNotNil(cache["1"], "Item should not be purged")
        XCTAssertNotNil(cache["3"], "Item should not be purged")
        XCTAssertNotNil(cache["4"], "Item should not be purged")
        XCTAssertNil(cache["2"], "Item should be purged because it exceeds capacity of cache and 1 was touched recently")
    }
}
