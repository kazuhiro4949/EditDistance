//
//  EditDistanceContainer.swift
//  EditDistance
//
//  Created by Kazuhiro Hayashi on 2/21/17.
//  Copyright © 2017 Kazuhiro Hayashi. All rights reserved.
//

import Foundation

struct EditDistanceContainer<T: Comparable>: Equatable {
    let indexPath: IndexPath
    let element: T
}

func ==<T: Comparable>(lhs: EditDistanceContainer<T>, rhs: EditDistanceContainer<T>) -> Bool {
    return lhs.element == rhs.element
}
