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
}
