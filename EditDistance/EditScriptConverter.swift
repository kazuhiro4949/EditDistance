//
//  EditScriptConverter.swift
//  EditDistance
//
//  Created by Kazuhiro Hayashi on 2/18/17.
//  Copyright © 2017 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

public protocol EditScriptConverter {}

public extension EditScriptConverter {
    public var diff: EditScriptConverterProxy<Self> {
        return EditScriptConverterProxy(self)
    }
}

extension UIView: EditScriptConverter {}
