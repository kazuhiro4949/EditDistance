//
//  Wu.swift
//  EditDistance
//
//  Created by Kazuhiro Hayashi on 2/18/17.
//  Copyright © 2017 Kazuhiro Hayashi. All rights reserved.
//

import Foundation

public struct Wu<T: Comparable>: EditDistanceProtocol {
    public typealias Element = T
    
    public init() {}

    public func calculate<Col: Collection>(from: Col, to: Col) -> [EditScript<Element>] where Col.Iterator.Element: Collection, Col.Iterator.Element.Iterator.Element == Element {
        let xAxis: [EditDistanceContainer<T>]
        let yAxis: [EditDistanceContainer<T>]
        var ctl: Ctl
        if from.count >= to.count {
            xAxis = to.enumerated().flatMap { (firstOffset, collection) in
                return collection.enumerated().flatMap { (secondOffset, element) in
                    return EditDistanceContainer(indexPath: IndexPath(row: secondOffset, section: firstOffset), element: element)
                }
            }
            yAxis = from.enumerated().flatMap { (firstOffset, collection) in
                return collection.enumerated().flatMap { (secondOffset, element) in
                    return EditDistanceContainer(indexPath: IndexPath(row: secondOffset, section: firstOffset), element: element)
                }
            }
            ctl = Ctl(reverse: true, path: [], pathPosition: [:])
        } else {
            xAxis = from.enumerated().flatMap { (firstOffset, collection) in
                return collection.enumerated().flatMap { (secondOffset, element) in
                    return EditDistanceContainer(indexPath: IndexPath(row: secondOffset, section: firstOffset), element: element)
                }
            }
            yAxis = to.enumerated().flatMap { (firstOffset, collection) in
                return collection.enumerated().flatMap { (secondOffset, element) in
                    return EditDistanceContainer(indexPath: IndexPath(row: secondOffset, section: firstOffset), element: element)
                }
            }
            ctl = Ctl(reverse: false, path: [], pathPosition: [:])
        }
        let offset = xAxis.count + 1
        let delta = yAxis.count - xAxis.count
        let size = xAxis.count + yAxis.count + 3
        var fp = Array(repeating: -1, count: size)
        ctl.path = Array(repeating: -1, count: size)
        ctl.pathPosition = [:]
        
        var p = 0
        while(true) {
            if -p <= delta {
                for k in -p..<delta {
                    ctl.path[k + offset] = ctl.pathPosition.count
                    let kRes = calcFootPrint(ctl: ctl, fp: fp, index: k + offset)
                    
                    (fp[k + offset], ctl.pathPosition[ctl.pathPosition.count]) = snake(xAxis: xAxis, yAxis: yAxis, k: k, y: kRes.y, r: kRes.r)
                }
            }
            
            if delta <= delta + p {
                for k in stride(from: delta + p, to: delta, by: -1) {
                    ctl.path[k + offset] = ctl.pathPosition.count
                    let kRes = calcFootPrint(ctl: ctl, fp: fp, index: k + offset)
                    
                    (fp[k + offset], ctl.pathPosition[ctl.pathPosition.count]) = snake(xAxis: xAxis, yAxis: yAxis, k: k, y: kRes.y, r: kRes.r)
                }
            }
            
            ctl.path[delta + offset] = ctl.pathPosition.count
            let deltaResult = calcFootPrint(ctl: ctl, fp: fp, index: delta + offset)
            
            (fp[delta + offset], ctl.pathPosition[ctl.pathPosition.count]) = snake(xAxis: xAxis, yAxis: yAxis, k: delta, y: deltaResult.y, r: deltaResult.r)
            
            if fp[delta + offset] >= yAxis.count {
                break
            }
            
            p += 1
        }
        
        var r = ctl.path[delta + offset]
        var epc = [Int: Point]()
        while (r != -1) {
            epc[epc.count] = Point(x: ctl.pathPosition[r]!.x, y: ctl.pathPosition[r]!.y, k: -1)
            r = ctl.pathPosition[r]!.k
        }
        
        return traceBack(epc: epc, ctl: ctl, xAxis: xAxis, yAxis: yAxis)
    }
    
    private func traceBack<T: Comparable>(epc: [Int: Point], ctl: Ctl, xAxis: [EditDistanceContainer<T>], yAxis: [EditDistanceContainer<T>]) -> [EditScript<T>] {
        var editScript = [EditScript<T>]()
        
        var pxIdx = 0, pyIdx = 0
        for i in stride(from: epc.count - 1, to: -1, by: -1) {
            while (pxIdx < epc[i]!.x) || (pyIdx < epc[i]!.y) {
                if (epc[i]!.y - epc[i]!.x) > (pyIdx - pxIdx) {
                    let elem = yAxis[pyIdx]
                    if ctl.reverse {
                        editScript.append(.delete(element: elem.element, indexPath: elem.indexPath))
                    } else {
                        editScript.append(.add(element: elem.element, indexPath: elem.indexPath))
                    }
                    pyIdx += 1
                } else if (epc[i]!.y - epc[i]!.x) < (pyIdx - pxIdx) {
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
    
    private func calcFootPrint(ctl: Ctl, fp: [Int], index: Int) -> (r: Int, y: Int) {
        let lsP = fp[index - 1] + 1
        let rsP = fp[index + 1]
        let r = lsP > rsP ? ctl.path[index - 1] : ctl.path[index + 1]
        return (r, max(lsP, rsP))
    }
    
    private func snake<T: Comparable>(xAxis: [EditDistanceContainer<T>], yAxis: [EditDistanceContainer<T>], k: Int, y: Int, r: Int) -> (y: Int, point: Point?) {
        var y = y
        var x = y - k
        
        while(x < xAxis.count && y < yAxis.count && xAxis[x] == yAxis[y]) {
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
    var path : [Int]
    var pathPosition: [Int: Point]
}
