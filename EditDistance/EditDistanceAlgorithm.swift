//
//  EditDistanceProtocol.swift
//  EditDistance
//
//  Created by Kazuhiro Hayashi on 2/18/17.
//  Copyright © 2017 Kazuhiro Hayashi. All rights reserved.
//

import Foundation

public protocol EditDistanceAlgorithm {
    associatedtype Element: Comparable
    
    func calculate(from: [[Element]], to: [[Element]]) -> EditDistanceContainer<Element>
}

public struct AnyEditDistanceAlgorithm<T>: EditDistanceAlgorithm where T: Comparable {

    public func calculate(from: [[T]], to: [[T]]) -> EditDistanceContainer<T> {
        return _calc(from, to)
    }

    public typealias Element = T
    public var _calc: ([[T]], [[T]]) -> EditDistanceContainer<T>
    
    public init(_ calc: @escaping ([[T]], [[T]]) -> EditDistanceContainer<T>) {
        _calc = calc
    }
}
