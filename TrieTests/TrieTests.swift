//  Copyright (c) 2015 Neil Pankey. All rights reserved.

import Trie

import Assertions
import XCTest

final class TrieTests: XCTestCase {

    func testvalue() {
        let trie = Trie<String, Bool>()
        assertEqual(trie.value("foo"), nil)

        trie.insert("", true)
        assertEqual(trie.value(""), true)
        assertEqual(trie.value("bar"), nil)

        trie.insert("asdf", false)
        assertEqual(trie.value("asdf"), false)
    }

    func testInsert() {
        let trie = Trie<String, Int>()

        trie.insert("a",    1)
        trie.insert("asdf", 2)
        trie.insert("aaa",  3)
        trie.insert("abc",  4)
        trie.insert("abra", 5)
        trie.insert("able", 6)
        trie.insert("bar",  7)
        trie.insert("baz",  8)

        assertEqual(trie.value(""),     nil)
        assertEqual(trie.value("a"),    1)
        assertEqual(trie.value("asdf"), 2)
        assertEqual(trie.value("aaa"),  3)
        assertEqual(trie.value("abc"),  4)
        assertEqual(trie.value("abra"), 5)
        assertEqual(trie.value("able"), 6)
        assertEqual(trie.value("bar"),  7)
        assertEqual(trie.value("baz"),  8)
    }

    func testRemove() {
        let trie = Trie<String, Int>()

        trie.insert("a",    1)
        trie.insert("asdf", 2)
        trie.insert("aaa",  3)
        trie.insert("abc",  4)
        trie.insert("abra", 5)

        trie.remove("a")
        assertEqual(trie.value("a"),   nil)
        assertEqual(trie.value("aaa"), 3)

        trie.remove("abc")
        assertEqual(trie.value("abc"),  nil)
        assertEqual(trie.value("abra"), 5)
        assertEqual(trie.value("asdf"), 2)
    }

    func testDictionaryLiteral() {
        let trie: Trie<String, Int> = [ "a": 1, "b": 2, "c": 3 ]

        assertEqual(trie.value("a"), 1)
        assertEqual(trie.value("b"), 2)
        assertEqual(trie.value("c"), 3)
        assertEqual(trie.value("d"), nil)
    }

    func testSubscript() {
        let trie = Trie<String, Int>()

        trie["abc"] = 123
        assertEqual(trie["abc"], 123)

        trie["abc"] = nil
        assertEqual(trie["abc"], nil)
    }
}
