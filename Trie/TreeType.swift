//  Copyright (c) 2015 Neil Pankey. All rights reserved.

/// Generic tree protocol

public protocol TreeType {
    typealias Value
    var value: Value? { get }

    // TODO Is there a way to make this `SequenceType where Element = Self`
    var nodes: SequenceOf<Self>? { get }
}

public struct BreadthFirstGenerator<T: TreeType> : GeneratorType {
    private var nodes: [T]

    public init(root: T) {
        nodes = [root]
    }

    public mutating func next() -> T? {
        if let node = nodes.first {
            if let children = node.nodes {
                nodes.extend(children)
            }
            return nodes.removeAtIndex(0)
        }
        return nil
    }
}

public func breadthFirst<T: TreeType>(tree: T) -> SequenceOf<T> {
    return SequenceOf {
        return BreadthFirstGenerator(root: tree)
    }
}
