//
//  EditDistanceContainer.swift
//  EditDistance
//
//  Copyright (c) 2017 Kazuhiro Hayashi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

/// container object for edit distance calculation results
public struct EditDistanceContainer<Element: Equatable> {
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
public enum EditScript<Element: Equatable>: Equatable {
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: EditScript<Element>, rhs: EditScript<Element>) -> Bool {
        switch (lhs, rhs) {
        case (.add(let one, let oneidx), .add(let another, let anoidx)):
             return one == another && oneidx == anoidx
        case (.common(let one, let oneidx), .common(let another, let anoidx)):
            return one == another && oneidx == anoidx
        case (.delete(let one, let oneidx), .delete(let another, let anoidx)):
            return one == another && oneidx == anoidx
        default:
            return false
        }
    }

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
