//
//  EditDistanceConverter+UICollectionView.swift
//  EditDistance
//
//  Created by Kazuhiro Hayashi on 2/19/17.
//  Copyright © 2017 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

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
