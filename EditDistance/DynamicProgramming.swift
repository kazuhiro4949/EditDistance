//
//  DynamicProgramming.swift
//  EditDistance
//
//  Created by Kazuhiro Hayashi on 2/20/17.
//  Copyright © 2017 Kazuhiro Hayashi. All rights reserved.
//

import Foundation

public class DynamicProgramming<T: Comparable>: EditDistanceProtocol {
    public typealias Element = T
    
    public init() {}
    
    public func calculate(from: [T], to: [T]) -> [EditScript<T>] {
        var table = [[Int]](repeating: Array(repeating: 0, count: to.count + 1), count: from.count + 1)
        
        for i in stride(from: table.count - 2, to: -1, by: -1) {
            for j in stride(from: table[i].count - 2, to: -1, by: -1) {
                if from[i] == to[j] {
                    table[i][j] = table[i + 1][j + 1] + 1
                } else {
                    table[i][j] = max(table[i + 1][j], table[i][j + 1])
                }
            }
        }
        
        print(table)
        
        var editScripts = [EditScript<T>]()
        
        do {
            var i = 0, j = 0
            while(i < from.count && j < to.count) {
                if from[i] == to[j] {
                    editScripts.append(.common(element: to[j], index: j))
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
            from.enumerated().forEach { (offset, element) in
                print((offset, element))
                if !commonElements.contains(element) {
                    editScripts.append(.delete(element: from[offset], index: offset))
                }
            }
        }
        
        do {
            var i = 0, j = 0
            while(i < commonElements.count || j < to.count) {
                if i < commonElements.count && j < to.count && commonElements[i] == to[j] {
                    i += 1
                    j += 1
                } else {
                    editScripts.append(.add(element: to[j], index: j))
                    j += 1
                }
            }
        }
        
        return editScripts
    }
}
