//
//  EditDistanceContainer.swift
//  EditDistance
//
//  Created by Kazuhiro Hayashi on 2/25/17.
//  Copyright © 2017 Kazuhiro Hayashi. All rights reserved.
//

import Foundation

/// container object for edit distance calculation results
public struct EditDistanceContainer<Element: Comparable> {
    public let editScripts: [EditScript<Element>]
    
    public init(editScripts: [EditScript<Element>]) {
        self.editScripts = editScripts
    }
}

/// Edit script definition. It composes the difference between two arrays as common, add or delete.
///
/// - add: an element on the desitination array is added
/// - common: element on two arrays is common
/// - delete: an element on the starting array is deleted
public enum EditScript<Element> {
    case common(element: Element, indexPath: IndexPath)
    case add(element: Element, indexPath: IndexPath)
    case delete(element: Element, indexPath: IndexPath)
    
    var indexPath: IndexPath {
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
