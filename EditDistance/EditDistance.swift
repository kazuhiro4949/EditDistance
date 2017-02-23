//
//  EditDistance.swift
//  EditDistance
//
//  Created by Kazuhiro Hayashi on 2/19/17.
//  Copyright © 2017 Kazuhiro Hayashi. All rights reserved.
//

import Foundation

public class EditDistance<T: Comparable> {
    private let _from: [[T]]
    private let _to: [[T]]
    
    public init(from: [[T]], to: [[T]]) {
        _from = from
        _to = to
    }
    
    public init(from: [T], to: [T]) {
        _from = [from]
        _to = [to]
    }
    
    public func calculate<Algorithm: EditDistanceAlgorithm>(with algorithm: Algorithm) -> [EditScript<T>] where Algorithm.Element == T {
        return algorithm.calculate(from: _from, to: _to)
    }
    
    public func calculate() -> [EditScript<T>] {
        return Wu().calculate(from: _from, to: _to)
    }
}

public class EditDistanceProxy<T: Comparable> {
    private let _generator: ([T]) -> EditDistance<T>
    
    public init(_ from: [T]) {
        _generator = { (to: [T]) -> EditDistance<T> in
            return EditDistance(from: from, to: to)
        }
    }
    
    public func compare<Algorithm: EditDistanceAlgorithm>(to ary: [T], algorithm: Algorithm) -> [EditScript<T>] where Algorithm.Element == T {
        return _generator(ary).calculate(with: algorithm)
    }
    
    public func compare(to ary: [T]) -> [EditScript<T>] {
        return _generator(ary).calculate(with: Wu())
    }
}

public extension Array where Element: Comparable {
    public var diff: EditDistanceProxy<Element> {
        return EditDistanceProxy(self)
    }
}
