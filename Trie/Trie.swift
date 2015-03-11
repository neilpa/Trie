//  Copyright (c) 2015 Neil Pankey. All rights reserved.

/// A tree for effieciently storing keys and optional values where many keys share a prefix.
public final class Trie<Key: TrieKey, Value where Key.Generator.Element: Hashable> {
    // MARK: Constructors

    /// Constructs an empty `Trie`.
    public init() {
    }

    /// Constructs a `Trie` with a `sequence` of key/value pairs.
    public init<S: SequenceType where S.Generator.Element == (Key, Value)>(sequence: S) {
        for (key, value) in sequence {
            self.insert(key, value)
        }
    }

    // MARK: Dictionary primitives

    public subscript(key: Key) -> Value? {
        get {
            return value(key, key.startIndex)
        } set(newValue) {
            update(key, key.startIndex, newValue)
        }
    }

    /// Updates `key` with `value` on the receiver. Returns the previous value of `key` or
    /// `nil` if unset.
    public func updateValue(value: Value, forKey key: Key) -> Value? {
        return update(key, key.startIndex, value)
    }

    /// Removes the value at `key` from the receiver. Returns the removed value or `nil` if
    /// `key` was unset.
    public func removeValueForKey(key: Key) -> Value? {
        return remove(key, key.startIndex)
    }

    /// Returns the value for `key` if contained in the receiver, `nil` otherwise.
    public func value(key: Key) -> Value? {
        return value(key, key.startIndex)
    }

    /// Inserts `value` into the receiver for the given `key`.
    public func insert(key: Key, _ value: Value) {
        update(key, key.startIndex, value)
    }

    /// Removes value at `key` from the receiver.
    public func remove(key: Key) {
        remove(key, key.startIndex)
    }

    /// MARK: Private

    private func value(key: Key, _ index: Key.Index) -> Value? {
        if index == key.endIndex {
            return value
        } else {
            let child = children[key[index]]
            return child?.value(key, index.successor())
        }
    }

    private func update(key: Key, _ index: Key.Index, _ value: Value?) -> Value? {
        if index == key.endIndex {
            return replaceValue(value)
        }

        var child = children[key[index]]
        if child == nil {
            child = Trie()
            children[key[index]] = child
        }
        return child!.update(key, index.successor(), value)
    }

    private func remove(key: Key, _ index: Key.Index) -> Value? {
        if index == key.endIndex {
            return replaceValue(nil)
        }

        let child = children[key[index]]
        return child?.remove(key, index.successor())
    }

    private func replaceValue(value: Value?) -> Value? {
        let previous = self.value
        self.value = value
        return previous
    }

    /// Individual element in the key sequence for mapping to child `Trie`s.
    private typealias Atom = Key.Generator.Element

    /// Value of the node in the `Trie`.
    private(set) public var value: Value? = nil

    /// Children that share a common prefix.
    private var children: [Atom: Trie] = [:]
}

// MARK: DictionaryLiteralConvertible

extension Trie : DictionaryLiteralConvertible {
    public convenience init(dictionaryLiteral elements: (Key, Value)...) {
        self.init(sequence: elements)
    }
}

// MARK: Traversal

extension Trie {
    public func breadthFirst() -> [(Key, Value)] {
        let seq = reduceWithParent(self, (Key(), nil)) { (current, parent) -> [((Key, Value?), Trie)] in
            return map(parent.children) { atom, child in
                let key: Key = concat(current.0, atom)
                return ((key, child.value), child)
            }
        }
        return filter(seq) { $1 != nil }.map { ($0, $1!) }
    }
}

// MARK: TreeType

extension Trie : TreeType {
    public var nodes: SequenceOf<Trie<Key, Value>> {
        return SequenceOf(children.values)
    }
}

// MARK: TrieKey

public typealias TrieKey = protocol<Sliceable, ExtensibleCollectionType, Comparable>
