//
//  LRUCache.swift
//  CachedImageDownloader
//
//  Created by Kacper Harasim on 08.03.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

public final class LRUCache<K: Hashable, V>: Cacheable {

    public typealias Key = K
    public typealias Value = V

    private let capacity: Int
    private let priorityList: LinkedList<(K, V)>
    private var dictionary: [K : LinkedListNode<(K, V)>]
    private let lock = NSLock()

    init(capacity: Int) {
        self.capacity = capacity
        self.priorityList = LinkedList()
        self.dictionary = Dictionary(minimumCapacity: capacity)
    }

    public subscript(key: K) -> V? {
        get {
            lock.lock(); defer { lock.unlock() }

            if let node = dictionary[key] {
                //Reprioritize element when someone ask about it and it's in cache
                priorityList.remove(node)
                priorityList.insertAtBeginning(node)
                return node.data.1
            } else {
                return nil
            }
        }

        set(newValue) {
            lock.lock(); defer { lock.unlock() }

            if let node = dictionary[key]{
                if let newValue = newValue {
                    node.data = (key, newValue)
                    priorityList.remove(node)
                    priorityList.insertAtBeginning(node)
                } else {
                    //If there is nil value set for key currently in hash we should purge it
                    dictionary.removeValue(forKey: key)
                    priorityList.remove(node)
                }
            } else {
                //There is no point in removing data that is not available in hash-table, so return
                guard let newValue = newValue else { return }
                
                let newNode = LinkedListNode<(K, V)>(data: (key, newValue))

                if dictionary.count < capacity {
                    priorityList.insertAtBeginning(newNode)
                    dictionary[key] = newNode
                } else {
                    //There is not enough space so we need to remove the last element
                    guard let lastNode = priorityList.last else { return }

                    let lastNodeKey = lastNode.data.0
                    dictionary.removeValue(forKey: lastNodeKey)
                    priorityList.removeLast()
                    priorityList.insertAtBeginning(newNode)
                    dictionary[key] = newNode
                }
            }
        }
    }
}
