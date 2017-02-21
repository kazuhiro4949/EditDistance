//
//  EditDistanceProtocol.swift
//  EditDistance
//
//  Created by Kazuhiro Hayashi on 2/18/17.
//  Copyright © 2017 Kazuhiro Hayashi. All rights reserved.
//

import Foundation

public protocol EditDistanceProtocol {
    associatedtype Element: Comparable
    
    func calculate<Col: Collection>(from: Col, to: Col) -> [EditScript<Element>] where Col.Iterator.Element: Collection, Col.Iterator.Element.Iterator.Element == Element
}
