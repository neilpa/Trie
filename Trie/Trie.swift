//
//  Trie.swift
//  Trie
//
//  Created by Neil Pankey on 3/6/15.
//  Copyright (c) 2015 Neil Pankey. All rights reserved.
//

public struct Trie<T> {
    private var value: T? = nil
    private var children: [Character:Trie<T>] = [:]

    public func lookup(key: String) -> T? {
        if let c = first(key) {
            return lookup(key[key.startIndex.successor()..<key.endIndex])
        }
        return value
    }

    public mutating func insert(key: String, _ value: T) {
        if let c = first(key) {
            let subkey = key[key.startIndex.successor()..<key.endIndex]
            if var child = children[c] {
                child.insert(subkey, value)
            } else {
                var child = Trie()
                children[c] = child
                child.insert(subkey, value)
            }
        } else {
            self.value = value
        }
    }

    public mutating func remove(key: String) {
        if let c = first(key) {
            if var child = children[c] {
                child.remove(key[key.startIndex.successor()..<key.endIndex])
            }
            // TODO Error if the key doesn't exist?
        } else {
            value = nil
        }
    }
}
