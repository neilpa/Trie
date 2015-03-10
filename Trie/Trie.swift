//  Copyright (c) 2015 Neil Pankey. All rights reserved.

/// A tree for effieciently storing keys and optional values where many keys share a prefix.
public final class Trie<Key: ExtensibleCollectionType, Value where Key.Generator.Element: Hashable> {
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
    private var value: Value? = nil

    /// Children that share a common prefix.
    private var children: [Atom: Trie] = [:]
}

// MARK: DictionaryLiteralConvertible

extension Trie : DictionaryLiteralConvertible {
    public convenience init(dictionaryLiteral elements: (Key, Value)...) {
        self.init(sequence: elements)
    }
}

// MARK: SequenceType

public struct TrieGenerator<Key: ExtensibleCollectionType, Value where Key.Generator.Element: Hashable> : GeneratorType {
    private let node: Trie<Key, Value>
    private let stem: Key

    private var children: Dictionary<Key.Generator.Element, Trie<Key, Value>>.Generator

    public init(node: Trie<Key, Value>) {
        self.init(node, Key())
    }

    private init(_ node: Trie<Key, Value>, _ stem: Key) {
        self.node = node
        self.stem = stem

        children = node.children.generate()
    }

    public mutating func next() -> TrieGenerator? {
        if let (atom, child) = children.next() {
            var key = Key()
            key.extend(stem)
            key.append(atom)
            return TrieGenerator(child, key)
        }
        return nil
    }
}

extension Trie : SequenceType {
    private typealias Generator = GeneratorOf<(Key, Value)>

    public func generate() -> Generator {
        return Trie.generate(self, stem: Key())
    }

    private static func generate(trie: Trie, stem: Key) -> Generator {
        var generator: Dictionary<Atom, Trie>.Generator?
        var nestedGenerator: Generator?

        return Generator {
            if generator == nil {
                generator = trie.children.generate()
                if let value = trie.value {
                    return (stem, value)
                }
            }

            if let element = nestedGenerator?.next() {
                return element
            } else {
                nestedGenerator = nil
            }

            if let (atom, child) = generator!.next() {
                var key = Key()
                key.extend(stem)
                key.append(atom)

                nestedGenerator = Trie.generate(child, stem: key)
            }

            return nestedGenerator?.next()
        }
    }
}
