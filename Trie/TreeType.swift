//  Copyright (c) 2015 Neil Pankey. All rights reserved.

/// Generic tree protocol

public protocol TreeType {
    typealias Value
    var value: Value? { get }

    // TODO Is there a way to make this `SequenceType where Element = Self`
    var nodes: SequenceOf<Self> { get }
}

public func breadthFirst<T: TreeType>(tree: T) -> SequenceOf<T> {
    return SequenceOf<T> { () -> GeneratorOf<T> in
        var nodes = [tree]

        return GeneratorOf {
            if let node = nodes.first {
                nodes.extend(node.nodes)
                return nodes.removeAtIndex(0)
            }
            return nil
        }
    }
}

public func zipReduceWithParent<T: TreeType, U, S: SequenceType where S.Generator.Element == (U, T)> (tree: T, initial: U, combine: (U, T) -> S) -> SequenceOf<(U, T)> {
    return SequenceOf { () -> GeneratorOf<(U, T)> in
        var nodes = [(initial, tree)]

        return GeneratorOf {
            if let (current, node) = nodes.first {
                nodes.removeAtIndex(0)
                nodes.extend(combine(current, node))

                return (current, node)
            }
            return nil
        }
    }
}
