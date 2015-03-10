//  Copyright (c) 2015 Neil Pankey. All rights reserved.

/// Generic tree protocol

protocol TreeType {
    typealias Nodes: SequenceType
    typealias SubTree: TreeType = Nodes.Generator.Element
    typealias Value

    var value: Value? { get }
    func children() -> Nodes?
}
