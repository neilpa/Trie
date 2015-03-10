//  Copyright (c) 2015 Neil Pankey. All rights reserved.

/// "Missing" sequence and related protocol functions

public func concat<C: ExtensibleCollectionType>(prefix: C, element: C.Generator.Element) -> C {
    var result = C()
    result.extend(prefix)
    result.append(element)
    return result
}

public func concat<C: ExtensibleCollectionType, S: SequenceType where C.Generator.Element == S.Generator.Element>(prefix: C, suffix: S) -> C {
    var result = C()
    result.extend(prefix)
    result.extend(suffix)
    return result
}

public func flatten<G: GeneratorType where G.Element: GeneratorType>(var generator: G) -> GeneratorOf<G.Element.Element> {
    var current = generator.next()
    return GeneratorOf {
        if let value = current?.next() {
            return value
        }
        current = generator.next()
        return current?.next()
    }
}
