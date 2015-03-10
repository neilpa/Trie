//  Copyright (c) 2015 Neil Pankey. All rights reserved.

/// Generic tree protocol

public protocol TreeType {
    typealias Value
    var value: Value? { get }

    // TODO Is there a way to make this `SequenceType where Element = Self`
    var nodes: SequenceOf<Self>? { get }
}

public func breadthFirst<T: TreeType>(tree: T) -> SequenceOf<T> {
    return SequenceOf<T> { () -> GeneratorOf<T> in
        var nodes = [tree]

        return GeneratorOf {
            if let node = nodes.first {
                if let children = node.nodes {
                    nodes.extend(children)
                }
                return nodes.removeAtIndex(0)
            }
            return nil
        }
    }
}

public func combineWithParent<T: TreeType, U>(tree: T, initial: U, combine: (U, T) -> U) -> SequenceOf<U> {
    return SequenceOf<U> { () -> GeneratorOf<U> in
        var queue = [(combine(initial, tree), tree)]

        return GeneratorOf {
            if let (current, node) = queue.first {
                queue.removeAtIndex(0)

                if let children = node.nodes {
                    queue.extend(map(children) { child in
                        return (combine(current, child), child)
                    })
                }
                return current
            }

            return nil
        }
    }
}
