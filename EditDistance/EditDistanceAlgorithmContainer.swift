//
//  EditDistanceContainer.swift
//  EditDistance
//
//  Created by Kazuhiro Hayashi on 2/21/17.
//  Copyright © 2017 Kazuhiro Hayashi. All rights reserved.
//

import Foundation

public struct EditDistanceAlgorithmContainer<T: Comparable>: Equatable {
    public let indexPath: IndexPath
    public let element: T
    
    public init(indexPath: IndexPath, element: T) {
        self.indexPath = indexPath
        self.element = element
    }
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==<T: Comparable>(lhs: EditDistanceAlgorithmContainer<T>, rhs: EditDistanceAlgorithmContainer<T>) -> Bool {
        return lhs.element == rhs.element
    }
}
