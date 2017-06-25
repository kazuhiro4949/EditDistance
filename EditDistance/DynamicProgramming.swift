//
//  DynamicProgramming.swift
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


/// Dynamic Programming O(NM)
public struct DynamicProgramming<T: Equatable>: EditDistanceAlgorithm {
    public typealias Element = T
    
    public init() {}
    
    public func calculate(from: [[T]], to: [[T]]) -> EditDistanceContainer<T> {
        let flattendTo = to.enumerated().flatMap { (firstOffset, collection) in
            return collection.enumerated().flatMap { (secondOffset, element) in
                return EditDistanceAlgorithmContainer(indexPath: IndexPath(row: secondOffset, section: firstOffset), element: element)
            }
        }
        
        let flattendFrom = from.enumerated().flatMap { (firstOffset, collection) in
            return collection.enumerated().flatMap { (secondOffset, element) in
                return EditDistanceAlgorithmContainer(indexPath: IndexPath(row: secondOffset, section: firstOffset), element: element)
            }
        }
        
        var table = [[Int]](repeating: Array(repeating: 0, count: flattendTo.count + 1), count: flattendFrom.count + 1)
        
        for i in stride(from: table.count - 2, to: -1, by: -1) {
            for j in stride(from: table[i].count - 2, to: -1, by: -1) {
                if flattendFrom[i] == flattendTo[j] {
                    table[i][j] = table[i + 1][j + 1] + 1
                } else {
                    table[i][j] = max(table[i + 1][j], table[i][j + 1])
                }
            }
        }
        
        var editScripts = [EditScript<T>]()
        
        do {
            var i = 0, j = 0
            while(i < flattendFrom.count && j < flattendTo.count) {
                if flattendFrom[i] == flattendTo[j] {
                    editScripts.append(.common(element: flattendTo[j].element, indexPath: flattendTo[j].indexPath))
                    i += 1
                    j += 1
                } else if table[i + 1][j] >= table[i][j + 1] {
                    i += 1
                } else {
                    j += 1
                }
            }
        }
        
        let commonElements = editScripts.flatMap { $0.element }
        
        do {
            flattendFrom.forEach { (container) in
                if !commonElements.contains(container.element) {
                    editScripts.append(.delete(element: container.element, indexPath: container.indexPath))
                }
            }
        }
        
        do {
            var i = 0, j = 0
            while(i < commonElements.count || j < flattendTo.count) {
                if i < commonElements.count && j < flattendTo.count && commonElements[i] == flattendTo[j].element {
                    i += 1
                    j += 1
                } else {
                    editScripts.append(.add(element: flattendTo[j].element, indexPath: flattendTo[j].indexPath))
                    j += 1
                }
            }
        }
        
        return EditDistanceContainer(editScripts: editScripts)
    }
}
