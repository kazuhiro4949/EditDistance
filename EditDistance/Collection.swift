//
//  Collection.swift
//  EditDistance
//
//  Created by Kazuhiro Hayashi on 2/18/17.
//  Copyright © 2017 Kazuhiro Hayashi. All rights reserved.
//

import Foundation

public extension Collection where Iterator.Element: Collection, Iterator.Element.Iterator.Element: Comparable {
    public var diff: TwoDimentionalEditDistanceProxy<Self> {
        return TwoDimentionalEditDistanceProxy(self)
    }
}

public extension Collection where Iterator.Element: Comparable {
    public var diff: OneDimentionalEditDistanceProxy<Self> {
        return OneDimentionalEditDistanceProxy(self)
    }
}
