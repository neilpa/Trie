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
        return nil
    }

    public mutating func insert(key: String, _ value: T) {

    }

    public mutating func remove(key: String) {

    }
}
