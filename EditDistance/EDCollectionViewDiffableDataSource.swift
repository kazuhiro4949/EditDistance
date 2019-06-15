//
//  EDCollectionViewDiffableDataSource.swift
//  EditDistance
//
//  Created by Kazuhiro Hayashi on 6/15/1 R.
//  Copyright © 2019 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

public class EDCollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> : NSObject, UICollectionViewDataSource where SectionIdentifierType : Hashable, ItemIdentifierType : Hashable {
    
    private var currentDataSource = [SectionIdentifierType: [ItemIdentifierType]]()
    private let cellProvider: EDCollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.CellProvider
    private let collectionView: UICollectionView
    
    public typealias CellProvider = (UICollectionView, IndexPath, ItemIdentifierType) -> UICollectionViewCell?
    
    public typealias SupplementaryViewProvider = (UICollectionView, String, IndexPath) -> UICollectionReusableView?
    
    public var supplementaryViewProvider: EDCollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.SupplementaryViewProvider? {
        
    }
    
    public init(collectionView: UICollectionView, cellProvider: @escaping EDCollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.CellProvider) {
        self.collectionView = collectionView
        self.cellProvider = cellProvider
        super.init()
    }
    
    public func apply(_ snapshot: EDDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>, animatingDifferences: Bool = true) {
        currentDataSource
    }
    
    public func snapshot() -> EDDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType> {
        
    }
    
    public func itemIdentifier(for indexPath: IndexPath) -> ItemIdentifierType? {
        
    }
    
    // TODO:- items needs search from Hashable
    public func indexPath(for itemIdentifier: ItemIdentifierType) -> IndexPath? {
        let sections = Array(currentDataSource.keys.enumerated())
        var indexPath: IndexPath?
        
        for section in sections {
            let items = currentDataSource[section.element]
            if let item = items?.enumerated().first(where: { $0.element == itemIdentifier }) {
                indexPath = IndexPath(item: item.offset, section: section.offset)
                break
            }
        }
        return indexPath
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return currentDataSource.keys.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionKey = Array(currentDataSource.keys)[section]
        return currentDataSource[sectionKey]?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionKey = Array(currentDataSource.keys)[indexPath.section]
        let item = currentDataSource[sectionKey][indexPath.row]
        return cellProvider(collectionView, indexPath, item)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
    }
}

public class EDDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType> where SectionIdentifierType : Hashable, ItemIdentifierType : Hashable {
    
    private var newDataSource: [SectionIdentifierType: [ItemIdentifierType]]
    
    public init() {
        
    }
    
    public var numberOfItems: Int {
        
    }
    
    public var numberOfSections: Int {
        
    }
    
    public var sectionIdentifiers: [SectionIdentifierType] {
        
    }
    
    public var itemIdentifiers: [ItemIdentifierType] {
        
    }
    
    public func numberOfItems(inSection identifier: SectionIdentifierType) -> Int {
        
    }
    
    public func itemIdentifiers(inSection identifier: SectionIdentifierType) -> [ItemIdentifierType] {
        
    }
    
    public func sectionIdentifier(containingItem identifier: ItemIdentifierType) -> SectionIdentifierType? {
        
    }
    
    public func indexOfItem(_ identifier: ItemIdentifierType) -> Int? {
        
    }
    
    public func indexOfSection(_ identifier: SectionIdentifierType) -> Int? {
        
    }
    
    public func appendItems(_ identifiers: [ItemIdentifierType], toSection sectionIdentifier: SectionIdentifierType? = nil) {
        
    }
    
    public func insertItems(_ identifiers: [ItemIdentifierType], beforeItem beforeIdentifier: ItemIdentifierType) {
        
    }
    
    public func insertItems(_ identifiers: [ItemIdentifierType], afterItem afterIdentifier: ItemIdentifierType) {
        
    }
    
    public func deleteItems(_ identifiers: [ItemIdentifierType]) {
        
    }
    
    public func deleteAllItems() {
        
    }
    
    public func moveItem(_ identifier: ItemIdentifierType, beforeItem toIdentifier: ItemIdentifierType) {
        
    }
    
    public func moveItem(_ identifier: ItemIdentifierType, afterItem toIdentifier: ItemIdentifierType) {
        
    }
    
    public func reloadItems(_ identifiers: [ItemIdentifierType]) {
        
    }
    
    public func appendSections(_ identifiers: [SectionIdentifierType]) {
        
    }
    
    public func insertSections(_ identifiers: [SectionIdentifierType], beforeSection toIdentifier: SectionIdentifierType) {
        
    }
    
    public func insertSections(_ identifiers: [SectionIdentifierType], afterSection toIdentifier: SectionIdentifierType) {
        
    }
    
    public func deleteSections(_ identifiers: [SectionIdentifierType]) {
        
    }
    
    public func moveSection(_ identifier: SectionIdentifierType, beforeSection toIdentifier: SectionIdentifierType) {
        
    }
    
    public func moveSection(_ identifier: SectionIdentifierType, afterSection toIdentifier: SectionIdentifierType) {
        
    }
    
    public func reloadSections(_ identifiers: [SectionIdentifierType]) {
        
    }
}
