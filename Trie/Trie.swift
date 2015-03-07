//
//  Trie.swift
//  Trie
//
//  Created by Neil Pankey on 3/6/15.
//  Copyright (c) 2015 Neil Pankey. All rights reserved.
//

public final class Trie<Key: ExtensibleCollectionType, Value where Key.Generator.Element: Hashable> {
    private typealias Atom = Key.Generator.Element

    private var value: Value? = nil
    private var children: [Atom: Trie] = [:]

    public init() {
    }

    public subscript(key: Key) -> Value? {
        get {
            return lookup(key, key.startIndex)
        } set {
            update(key, key.startIndex, value)
        }
    }

    public func updateValue(value: Value, forKey key: Key) -> Value? {
        return update(key, key.startIndex, value)
    }

    public func removeValueForKey(key: Key) -> Value? {
        return remove(key, key.startIndex)
    }

    public func lookup(key: Key) -> Value? {
        return lookup(key, key.startIndex)
    }

    public func insert(key: Key, _ value: Value) {
        update(key, key.startIndex, value)
    }

    public func remove(key: Key) {
        remove(key, key.startIndex)
    }

    private func lookup(key: Key, _ index: Key.Index) -> Value? {
        if index == key.endIndex {
            return value
        } else {
            let child = children[key[index]]
            return child?.lookup(key, index.successor())
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
}

extension Trie : DictionaryLiteralConvertible {
    public convenience init(dictionaryLiteral elements: (Key, Value)...) {
        self.init()
        for (key, value) in elements {
            update(key, key.startIndex, value)
        }
    }
}

extension Trie : SequenceType {
    private typealias Generator = GeneratorOf<(Key, Value)>

    public func generate() -> Generator {
        return Trie.generate(self, prefix: Key())
    }

    private static func generate(trie: Trie<Key, Value>, prefix: Key) -> Generator {
        var generator: Dictionary<Atom, Trie<Key, Value>>.Generator?
        var nestedGenerator: Generator?

        return Generator {
            if generator == nil {
                generator = trie.children.generate()
                if let value = trie.value {
                    return (prefix, value)
                }
            }

            if let element = nestedGenerator?.next() {
                return element
            } else {
                nestedGenerator = nil
            }

            if let (atom, child) = generator!.next() {
                var key = Key()
                key.extend(prefix)
                key.append(atom)

                nestedGenerator = Trie.generate(child, prefix: key)
            }

            return nestedGenerator?.next()
        }
    }
}
