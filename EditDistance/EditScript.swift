//
//  EditScript.swift
//  EditDistance
//
//  Created by Kazuhiro Hayashi on 2/18/17.
//  Copyright © 2017 Kazuhiro Hayashi. All rights reserved.
//

import Foundation

public enum EditScript<Element> {
    case add(element: Element, index: Int)
    case common(element: Element, index: Int)
    case delete(element: Element, index: Int)
    
    var index: Int {
        switch self {
        case .add(element: _, index: let index):
            return index
        case .common(element: _, index: let index):
            return index
        case .delete(element: _, index: let index):
            return index
        }
    }
    
    var element: Element {
        switch self {
        case .add(element: let element, index: _):
            return element
        case .common(element: let elelemtn, index: _):
            return elelemtn
        case .delete(element: let element, index: _):
            return element
        }
    }
}
