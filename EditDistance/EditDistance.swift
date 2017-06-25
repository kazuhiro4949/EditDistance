//
//  EditDistance.swift
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


/// EditDistance calculates a difference between two arrays.
///
/// # Usage
///
/// ## 1. prepare two arrays.
/// ```
/// let a = [["Francis", "Woodruff"]]
/// let b = [["Francis", "Woodruff", "Stanton"]]
/// ```
///
/// ## 2. make EditDistance
/// ```
/// let editDistance = EditDistance(from: a, to: b)
/// ```
///
/// ## calculates edit distance
/// ```
/// editDistance.calculate() // [.common("Francis", [0, 0]), .common("Woodruff", [0, 1]), .add("Stanton", [0, 2])]
/// ```
public struct EditDistance<T: Equatable> {
    private let _from: [[T]]
    private let _to: [[T]]
    
    /// Create an instance to calculate edit distance with two dimentional arrays.
    ///
    /// - Parameters:
    ///   - from: starting two dimentional array
    ///   - to: distination two dimentional array
    public init(from: [[T]], to: [[T]]) {
        _from = from
        _to = to
    }

    /// Create an instance to calculate edit distance with one dimentional arrays.
    ///
    /// - Parameters:
    ///   - from: starting one dimentional array
    ///   - to: distination one dimentional array
    public init(from: [T], to: [T]) {
        _from = [from]
        _to = [to]
    }

    
    /// Calculate EditScript with an algorithm defined by EditDistanceAlgorithm protocol.
    /// In order to that, you can customize algoritm as you like.
    ///
    /// - Parameter algorithm: how to calculate Edit Distance
    /// - Returns: array of commn, insertion and deletion to each the element.
    public func calculate<Algorithm: EditDistanceAlgorithm>(with algorithm: Algorithm) -> EditDistanceContainer<T> where Algorithm.Element == T {
        return algorithm.calculate(from: _from, to: _to)
    }
    
    
    /// Calculate EditScript with Wu's algorithm.
    /// The implementation is based on S.W.Maner, G.Myers, W.Miller, "An O(NP) Sequence Comparison Algorithm"
    
    /// - Returns: array of commn, insertion, deletion to each the element.
    public func calculate() -> EditDistanceContainer<T> {
        return Wu().calculate(from: _from, to: _to)
    }
}

/// proxy type to Array<T: Equatable>.
/// It receives a starting array, after that evaluate resutls with destination array and an algorithm.
public struct EditDistanceProxy<T: Equatable> {
    private let _generator: ([T]) -> EditDistance<T>
    
    
    /// Create object with a starting array
    ///
    /// - Parameter from: starting array
    public init(_ from: [T]) {
        _generator = { (to: [T]) -> EditDistance<T> in
            return EditDistance(from: from, to: to)
        }
    }
    
    
    /// calculate Edit Distance with destination array and an algorithm.
    ///
    /// - Parameters:
    ///   - ary: destination array
    ///   - algorithm: any algorithm following EditDistanceAlgorithm protocol
    /// - Returns: array of commn, insertion and deletion to each the element.
    public func compare<Algorithm: EditDistanceAlgorithm>(to ary: [T], with algorithm: Algorithm) -> EditDistanceContainer<T> where Algorithm.Element == T {
        return _generator(ary).calculate(with: algorithm)
    }
    
    /// calculate Edit Distance with destination array and an algorithm.
    ///
    /// - Parameters:
    ///   - ary: destination array
    ///   - algorithm: any algorithm following EditDistanceAlgorithm protocol
    /// - Returns: array of commn, insertion and deletion to each the element.
    public func compare(to ary: [T]) -> EditDistanceContainer<T> {
        return _generator(ary).calculate(with: Wu())
    }
}


// MARK: - Array Extension
public extension Array where Element: Equatable {
    
    /// namespace for EditDistance. create EditDistanceProxy object with self.
    public var diff: EditDistanceProxy<Element> {
        return EditDistanceProxy(self)
    }
}
