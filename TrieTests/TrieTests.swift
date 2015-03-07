//  Copyright (c) 2015 Neil Pankey. All rights reserved.

import Trie

import Assertions
import XCTest

final class TrieTests: XCTestCase {

    func testLookup() {
        let trie = Trie<Bool>()
        assertEqual(trie.lookup("foo"), nil)

        trie.insert("", true)
        assertEqual(trie.lookup(""), true)
        assertEqual(trie.lookup("bar"), nil)

        trie.insert("asdf", false)
        assertEqual(trie.lookup("asdf"), false)
    }

    func testInsert() {
        let trie = Trie<Int>()

        trie.insert("a",    1)
        trie.insert("asdf", 2)
        trie.insert("aaa",  3)
        trie.insert("abc",  4)
        trie.insert("abra", 5)
        trie.insert("able", 6)
        trie.insert("bar",  7)
        trie.insert("baz",  8)

        assertEqual(trie.lookup(""),     nil)
        assertEqual(trie.lookup("a"),    1)
        assertEqual(trie.lookup("asdf"), 2)
        assertEqual(trie.lookup("aaa"),  3)
        assertEqual(trie.lookup("abc"),  4)
        assertEqual(trie.lookup("abra"), 5)
        assertEqual(trie.lookup("able"), 6)
        assertEqual(trie.lookup("bar"),  7)
        assertEqual(trie.lookup("baz"),  8)
    }
}
