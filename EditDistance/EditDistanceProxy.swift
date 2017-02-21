//
//  EditDistanceProxy.swift
//  EditDistance
//
//  Created by Kazuhiro Hayashi on 2/19/17.
//  Copyright © 2017 Kazuhiro Hayashi. All rights reserved.
//

import Foundation

public class TwoDimentionalEditDistanceProxy<T: Collection> where T.Iterator.Element: Collection, T.Iterator.Element.Iterator.Element: Comparable {
    let _collection: T
    
    public init(_ collection: T) {
        _collection = collection
    }
    
    public func compare<EditDistance: EditDistanceProtocol>(with collection: T, by algorithm: EditDistance) -> [EditScript<T.Iterator.Element.Iterator.Element>] where EditDistance.Element == T.Iterator.Element.Iterator.Element {
        return algorithm.calculate(from: _collection, to: collection)
    }
    
    public func compare<EditDistance: EditDistanceProtocol>(with collection: T) -> [EditScript<T.Iterator.Element.Iterator.Element>] where EditDistance.Element == T.Iterator.Element.Iterator.Element {
        return compare(with: collection, by: Wu())
    }
}

public class OneDimentionalEditDistanceProxy<T: Collection> where T.Iterator.Element: Comparable {
    let _collection: T
    
    public init(_ collection: T) {
        _collection = collection
    }
    
    public func compare<EditDistance: EditDistanceProtocol>(with collection: T, by algorithm: EditDistance) -> [EditScript<T.Iterator.Element>] where EditDistance.Element == T.Iterator.Element {
        return algorithm.calculate(from: [_collection], to: [collection])
    }
    
    public func compare<EditDistance: EditDistanceProtocol>(with collection: T) -> [EditScript<T.Iterator.Element>] where EditDistance.Element == T.Iterator.Element {
        return compare(with: collection, by: Wu())
    }
}
