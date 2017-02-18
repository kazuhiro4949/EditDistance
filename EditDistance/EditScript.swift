//
//  EditScript.swift
//  EditDistance
//
//  Created by Kazuhiro Hayashi on 2/18/17.
//  Copyright © 2017 Kazuhiro Hayashi. All rights reserved.
//

import Foundation

public enum EditScript<Element> {
    case add(element: Element, index: Int)
    case common(element: Element, index: Int)
    case delete(element: Element, index: Int)
}
