//
//  CollectionViewController.swift
//
//  Copyright © 2017年 Kazuhiro Hayashi. All rights reserved.
//

import UIKit
import EditDistance

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {

    var source = [0, 1, 2, 3, 4, 5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return source.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    
    @IBAction func rightBarButtonItemDidTap(_ sender: UIBarButtonItem) {
        let newSource = Array(0..<Int(arc4random() % 50)).shuffled()
        let container = source.diff.compare(to: newSource)
        source = Array(newSource)
        collectionView?.diff.performBatchUpdates(with: container, completion: nil)
    }
}
