//
//  EditScript.swift
//  EditDistance
//
//  Created by Kazuhiro Hayashi on 2/18/17.
//  Copyright © 2017 Kazuhiro Hayashi. All rights reserved.
//

import Foundation

public enum EditScript<Element> {
    case add(element: Element, indexPath: IndexPath)
    case common(element: Element, indexPath: IndexPath)
    case delete(element: Element, indexPath: IndexPath)
    
    var index: IndexPath {
        switch self {
        case .add(element: _, indexPath: let indexPath):
            return indexPath
        case .common(element: _, indexPath: let indexPath):
            return indexPath
        case .delete(element: _, indexPath: let indexPath):
            return indexPath
        }
    }
    
    var element: Element {
        switch self {
        case .add(element: let element, indexPath: _):
            return element
        case .common(element: let elelemtn, indexPath: _):
            return elelemtn
        case .delete(element: let element, indexPath: _):
            return element
        }
    }
}
