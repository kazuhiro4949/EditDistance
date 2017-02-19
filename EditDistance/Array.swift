//
//  Array.swift
//  EditDistance
//
//  Created by Kazuhiro Hayashi on 2/18/17.
//  Copyright © 2017 Kazuhiro Hayashi. All rights reserved.
//

import Foundation

public extension Array where Element: Comparable {
    public var diff: EditDistanceProxy<Element> {
        return EditDistanceProxy(self)
    }
}
