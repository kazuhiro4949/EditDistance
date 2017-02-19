//
//  EditDistanceProtocol.swift
//  EditDistance
//
//  Created by Kazuhiro Hayashi on 2/18/17.
//  Copyright © 2017 Kazuhiro Hayashi. All rights reserved.
//

import Foundation

public protocol EditDistanceProtocol {
    associatedtype Element: Comparable
    
    func calculate(from: [Element], to: [Element]) -> [EditScript<Element>]
}

public struct AnyEditDistance<T: Comparable>: EditDistanceProtocol {
    public typealias Element = T
    private let _base: ([T], [T]) -> [EditScript<T>]
    
    public init(_ base: @escaping ([T], [T]) -> [EditScript<T>]) {
        _base = base
    }
    
    public func calculate(from: [T], to: [T]) -> [EditScript<T>] {
        return _base(from, to)
    }
}
