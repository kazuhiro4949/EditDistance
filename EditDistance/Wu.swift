//
//  Wu.swift
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


/// Wu's algorithm O(NP)
///
/// inspired by (cubicdaiya/gonp)[https://github.com/cubicdaiya/gonp]
public struct Wu<T: Equatable>: EditDistanceAlgorithm {
    public typealias Element = T
    
    public init() {}

    public func calculate(from: [[T]], to: [[T]]) -> EditDistanceContainer<T> {
        var flattenTo = Array<EditDistanceAlgorithmContainer<T>>()
        var flattenFrom = Array<EditDistanceAlgorithmContainer<T>>()
        do {
            var i: Int = 0, j: Int = 0
            let toCnt   = to.count
            let fromCnt = from.count
            while true {
                guard i < toCnt || i < fromCnt else {
                    break
                }
                
                let toICnt = to[i].count
                let fromICnt = from[i].count
                while true {
                    let enableAccessToElem = j < toICnt
                    let enableAccessFromElem = j < fromICnt
                    guard enableAccessToElem || enableAccessFromElem else {
                        break
                    }
                    
                    if enableAccessToElem {
                        flattenTo.append(EditDistanceAlgorithmContainer(indexPath: IndexPath(row: j, section: i), element: to[i][j]))
                    }
                    
                    if enableAccessFromElem {
                        flattenFrom.append(EditDistanceAlgorithmContainer(indexPath: IndexPath(row: j, section: i), element: from[i][j]))
                    }
                    j += 1
                }
                i += 1
            }
        }

        let xAxisPointer: UnsafeMutablePointer<EditDistanceAlgorithmContainer<T>>
        let yAxisPointer: UnsafeMutablePointer<EditDistanceAlgorithmContainer<T>>
        let xAxisCount: Int
        let yAxisCount: Int
        var ctl: Ctl
        if flattenFrom.count >= flattenTo.count {
            xAxisPointer = UnsafeMutablePointer(mutating: flattenTo)
            yAxisPointer = UnsafeMutablePointer(mutating: flattenFrom)
            xAxisCount = flattenTo.count
            yAxisCount = flattenFrom.count
            ctl = Ctl(reverse: true, path: UnsafeMutablePointer<Int>.allocate(capacity: 0), pathPosition: [:])
        } else {
            xAxisPointer = UnsafeMutablePointer(mutating: flattenFrom)
            yAxisPointer = UnsafeMutablePointer(mutating: flattenTo)
            xAxisCount = flattenFrom.count
            yAxisCount = flattenTo.count
            ctl = Ctl(reverse: false, path: UnsafeMutablePointer<Int>.allocate(capacity: 0), pathPosition: [:])
        }
        let offset = xAxisCount + 1
        let delta = yAxisCount - xAxisCount
        let tailIdx = delta + offset
        let size = xAxisCount + yAxisCount + 3
        
        let fpBuffer = UnsafeMutablePointer<Int>.allocate(capacity: size)
        fpBuffer.initialize(to: -1, count: size)
        defer {
            fpBuffer.deallocate(capacity: size)
        }
        
        ctl.path.deallocate(capacity: size)
        ctl.path = UnsafeMutablePointer<Int>.allocate(capacity: size)
        defer {
            ctl.path.deallocate(capacity: size)
        }
        
        ctl.path.initialize(to: -1, count: size)
        ctl.pathPosition = [:]

        
        var p = 0
        while(true) {
            if -p <= delta {
                for k in -p..<delta {
                    ctl.path[k + offset] = ctl.pathPosition.count
                    let kRes = calcFootPrint(ctl: ctl, fp: fpBuffer, index: k + offset)
                    
                    (fpBuffer[k + offset], ctl.pathPosition[ctl.pathPosition.count]) = snake(xAxis: xAxisPointer, yAxis: yAxisPointer, xAxisCount: xAxisCount, yAxisCount: yAxisCount, k: k, y: kRes.y, r: kRes.r)
                }
            }
            
            if delta <= delta + p {
                for k in stride(from: delta + p, to: delta, by: -1) {
                    ctl.path[k + offset] = ctl.pathPosition.count
                    let kRes = calcFootPrint(ctl: ctl, fp: fpBuffer, index: k + offset)
                    
                    (fpBuffer[k + offset], ctl.pathPosition[ctl.pathPosition.count]) = snake(xAxis: xAxisPointer, yAxis: yAxisPointer, xAxisCount: xAxisCount, yAxisCount: yAxisCount, k: k, y: kRes.y, r: kRes.r)
                }
            }
            
            ctl.path[tailIdx] = ctl.pathPosition.count
            let deltaResult = calcFootPrint(ctl: ctl, fp: fpBuffer, index: tailIdx)
            
            (fpBuffer[tailIdx], ctl.pathPosition[ctl.pathPosition.count]) = snake(xAxis: xAxisPointer, yAxis: yAxisPointer, xAxisCount: xAxisCount, yAxisCount: yAxisCount, k: delta, y: deltaResult.y, r: deltaResult.r)
            
            if fpBuffer[tailIdx] >= yAxisCount {
                break
            }
            
            p += 1
        }
        
        var r = ctl.path[tailIdx]
        var epc = [Int: Point]()
        while (r != -1) {
            epc[epc.count] = Point(x: ctl.pathPosition[r]!.x, y: ctl.pathPosition[r]!.y, k: -1)
            r = ctl.pathPosition[r]!.k
        }
        
        return EditDistanceContainer(editScripts: traceBack(epc: epc, ctl: ctl, xAxis: xAxisPointer, yAxis: yAxisPointer))
    }
    
    private func traceBack<T>(epc: [Int: Point], ctl: Ctl, xAxis: UnsafeMutablePointer<EditDistanceAlgorithmContainer<T>>, yAxis: UnsafeMutablePointer<EditDistanceAlgorithmContainer<T>>) -> [EditScript<T>] {
        var editScript = [EditScript<T>]()
        
        var pxIdx = 0, pyIdx = 0
        for i in stride(from: epc.count - 1, to: -1, by: -1) {
            let epcPx = epc[i]!.x
            let epcPy = epc[i]!.y
            while (pxIdx < epcPx) || (pyIdx < epcPy) {
                if (epcPy - epcPx) > (pyIdx - pxIdx) {
                    let elem = yAxis[pyIdx]
                    if ctl.reverse {
                        editScript.append(.delete(element: elem.element, indexPath: elem.indexPath))
                    } else {
                        editScript.append(.add(element: elem.element, indexPath: elem.indexPath))
                    }
                    pyIdx += 1
                } else if (epcPy - epcPx) < (pyIdx - pxIdx) {
                    let elem = xAxis[pxIdx]
                    if ctl.reverse {
                        editScript.append(.add(element: elem.element, indexPath: elem.indexPath))
                    } else {
                        editScript.append(.delete(element: elem.element, indexPath: elem.indexPath))
                    }
                    pxIdx += 1
                } else {
                    let elem = xAxis[pxIdx]
                    if ctl.reverse {
                        editScript.append(.common(element: elem.element, indexPath: elem.indexPath))
                    } else {
                        editScript.append(.common(element: elem.element, indexPath: elem.indexPath))
                    }
                    pxIdx += 1
                    pyIdx += 1
                }
            }
        }
        
        return editScript
    }
    
    private func calcFootPrint(ctl: Ctl, fp: UnsafeMutablePointer<Int>, index: Int) -> (r: Int, y: Int) {
        let lsP = fp[index - 1] + 1
        let rsP = fp[index + 1]
        let r = lsP > rsP ? ctl.path[index - 1] : ctl.path[index + 1]
        return (r, max(lsP, rsP))
    }
    
    private func snake<T>(xAxis: UnsafeMutablePointer<EditDistanceAlgorithmContainer<T>>, yAxis: UnsafeMutablePointer<EditDistanceAlgorithmContainer<T>>, xAxisCount: Int, yAxisCount: Int, k: Int, y: Int, r: Int) -> (y: Int, point: Point?) {
        var y = y
        var x = y - k
        
        while(x < xAxisCount && y < yAxisCount && xAxis[x] == yAxis[y]) {
            x += 1
            y += 1
        }
        
        return (y, Point(x: x, y: y, k: r))
    }
}

private struct Point {
    let x: Int
    let y: Int
    let k: Int
}

private struct Ctl {
    let reverse: Bool
    var path : UnsafeMutablePointer<Int>
    var pathPosition: [Int: Point]
}
