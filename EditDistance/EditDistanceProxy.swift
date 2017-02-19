//
//  EditDistanceProxy.swift
//  EditDistance
//
//  Created by Kazuhiro Hayashi on 2/19/17.
//  Copyright © 2017 Kazuhiro Hayashi. All rights reserved.
//

import Foundation

public class EditDistanceProxy<Element: Comparable> {
    let _array: Array<Element>
    
    public init(_ array: Array<Element>) {
        _array = array
    }
    
    public func compare<EditDistance: EditDistanceProtocol>(with array: [Element], by algorithm: EditDistance) -> [EditScript<Element>] where EditDistance.Element == Element {
        return algorithm.calculate(from: _array, to: array)
    }
    
    public func compare(with array: [Element]) -> [EditScript<Element>] {
        return compare(with: array, by: Wu())
    }
}
