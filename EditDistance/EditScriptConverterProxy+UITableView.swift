//
//  EditScriptConverter+UITableView.swift
//  EditDistance
//
//  Created by Kazuhiro Hayashi on 2/19/17.
//  Copyright © 2017 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

public extension EditScriptConverterProxy where Converter: UITableView {
    public func reload<T>(with editScripts: [EditScript<T>]) {
        _converter.beginUpdates()
        editScripts.forEach({ (script) in
            switch script {
            case .add(_, let index):
                _converter.insertRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            case .delete(_, let index):
                _converter.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            case .common:
                break
            }
        })
        _converter.endUpdates()
    }
}
