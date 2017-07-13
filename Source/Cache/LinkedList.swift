//
//  LinkedList.swift
//  CachedImageDownloader
//
//  Created by Kacper Harasim on 08.03.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

final class LinkedListNode<T> {
    var next: LinkedListNode?
    weak var previous: LinkedListNode?
    var data: T

    init(data: T) {
        self.data = data
    }
}

final class LinkedList<T> {

    private var head: LinkedListNode<T>?
    private var tail: LinkedListNode<T>?

    var last: LinkedListNode<T>? {
        return tail
    }

    func insertAtBeginning(_ newNode: LinkedListNode<T>) {
        if head == nil {
            head = newNode
            tail = newNode
        } else {
            let oldHead = head
            head?.previous = newNode
            newNode.next = oldHead
            head = newNode
        }
    }

    func remove(_ node: LinkedListNode<T>) {
        if node === head {
            if head?.next != nil {
                head?.next?.previous = nil
                head = head?.next
            } else {
                //Last element was removed
                head = nil
                tail = nil
            }
        } else if node.next != nil {
            node.previous?.next = node.next
            node.next?.previous = node.previous
        } else {
            tail = node.previous
            node.previous?.next = nil
        }
    }

    func removeLast() {
        guard let last = tail else { return }
        last.previous?.next = nil
        tail = last.previous

        //If there was only one element we need to fix head too.
        if head === last {
            head = last.previous
        }
    }
}
