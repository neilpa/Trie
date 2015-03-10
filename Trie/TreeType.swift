//  Copyright (c) 2015 Neil Pankey. All rights reserved.

/// Generic tree protocol

public protocol TreeType {
    typealias Nodes: SequenceType
    typealias Node: TreeType = Nodes.Generator.Element
    typealias Value

    var value: Value? { get }
    var nodes: Nodes? { get }
}
