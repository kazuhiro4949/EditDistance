//
//  EditScriptConverterProxy.swift
//  EditDistance
//
//  Created by Kazuhiro Hayashi on 2/19/17.
//  Copyright © 2017 Kazuhiro Hayashi. All rights reserved.
//

import Foundation


public class EditScriptConverterProxy<Converter: EditScriptConverter> {
    let _converter: Converter
    
    public init(_ converter: Converter) {
        _converter = converter
    }
}
