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
    
    public func calculate(from: [T], to: [T]) -> [EditScript<T>] {
        let xAxis: [T]
        let yAxis: [T]
        var ctl: Ctl
        if from.count >= to.count {
            xAxis = to
            yAxis = from
            ctl = Ctl(reverse: true, path: [], pathPosition: [:])
        } else {
            xAxis = from
            yAxis = to
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
    
    private func traceBack<T: Comparable>(epc: [Int: Point], ctl: Ctl, xAxis: [T], yAxis: [T]) -> [EditScript<T>] {
        var editScript = [EditScript<T>]()
        
        var pxIdx = 0, pyIdx = 0
        for i in stride(from: epc.count - 1, to: -1, by: -1) {
            while (pxIdx < epc[i]!.x) || (pyIdx < epc[i]!.y) {
                if (epc[i]!.y - epc[i]!.x) > (pyIdx - pxIdx) {
                    let elem = yAxis[pyIdx]
                    if ctl.reverse {
                        editScript.append(.delete(element: elem, index: pyIdx))
                    } else {
                        editScript.append(.add(element: elem, index: pyIdx))
                    }
                    pyIdx += 1
                } else if (epc[i]!.y - epc[i]!.x) < (pyIdx - pxIdx) {
                    let elem = xAxis[pxIdx]
                    if ctl.reverse {
                        editScript.append(.add(element: elem, index: pxIdx))
                    } else {
                        editScript.append(.delete(element: elem, index: pxIdx))
                    }
                    pxIdx += 1
                } else {
                    let elem = xAxis[pxIdx]
                    if ctl.reverse {
                        editScript.append(.common(element: elem, index: pxIdx))
                    } else {
                        editScript.append(.common(element: elem, index: pyIdx))
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
    
    private func snake<T: Comparable>(xAxis: [T], yAxis: [T], k: Int, y: Int, r: Int) -> (y: Int, point: Point?) {
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
