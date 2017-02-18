//
//  Array.swift
//  EditDistance
//
//  Created by Kazuhiro Hayashi on 2/18/17.
//  Copyright © 2017 Kazuhiro Hayashi. All rights reserved.
//

import Foundation

public extension Array where Element: Comparable {
    public mutating func replace<EditDistance: EditDistanceProtocol>(to: [Element], by: EditDistance) -> [EditScript<Element>] where EditDistance.Element == Element {
        let scripts = diff(to: to, by: by)
        self = to
        return scripts
    }

    public func diff<EditDistance: EditDistanceProtocol>(to: [Element], by: EditDistance) -> [EditScript<Element>] where EditDistance.Element == Element {
        return by.diff(from: self, to: to)
    }
}

public extension Array where Element: Comparable {
    public mutating func replace(to: [Element]) -> [EditScript<Element>] {
        let scripts = diff(to: to, by: Wu())
        self = to
        return scripts
    }
    
    public func diff(to: [Element]) -> [EditScript<Element>] {
        return diff(to: to, by: Wu())
    }
}
