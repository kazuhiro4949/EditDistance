//
//  EditScriptConverter.swift
//  EditDistance
//
//  Created by Kazuhiro Hayashi on 2/18/17.
//  Copyright © 2017 Kazuhiro Hayashi. All rights reserved.
//

import Foundation

public protocol EditScriptConverter {}

public extension EditScriptConverter {
    public var diff: EditScriptConverterProxy<Self> {
        return EditScriptConverterProxy(self)
    }
}

public class EditScriptConverterProxy<Converter: EditScriptConverter> {
    let _converter: Converter
    
    public init(_ converter: Converter) {
        _converter = converter
    }
}

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

public extension EditScriptConverterProxy where Converter: UICollectionView {
    public func performBatchUpdates<T>(with editScripts: [EditScript<T>], completion: ((Bool) -> Void)?) {
        _converter.performBatchUpdates({ [weak self] in
            editScripts.forEach({ (script) in
                switch script {
                case .add(_, let index):
                    self?._converter.insertItems(at: [IndexPath(item: index, section: 0)])
                case .delete(_, let index):
                    self?._converter.deleteItems(at: [IndexPath(item: index, section: 0)])
                case .common:
                    break
                }
            })
            }, completion: { (finish) in
                completion?(finish)
        })
    }
}

extension UIView: EditScriptConverter {}
