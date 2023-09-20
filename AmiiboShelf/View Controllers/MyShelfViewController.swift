//
//  MyShelfViewController.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 16/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import UIKit

class MyShelfViewController: AmiiboViewController {
    // MARK: Outlets
    @IBOutlet weak var shelfCollectionView: UICollectionView!
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        AmiiboDetailViewController.delegate = self
        shelfCollectionView.delegate = self
        shelfCollectionView.dataSource = self

        amiiboItens = getShelfAmiibo()
        registerForPreviewing(with: self, sourceView: shelfCollectionView)
        if amiiboItens.count == 0 {
            showNoAmiiboOnShelfAlert()
        }
    }
    
    override func viewDidLayoutSubviews() {
        let shelfView = UIView()
        shelfView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Shelf-Image").resize(width: Int(shelfCollectionView.frame.width), height: Int(shelfCollectionView.frame.height/4.8)) ?? UIImage())
        shelfCollectionView.backgroundView = shelfView
        shelfCollectionView.setNeedsDisplay()
    }
    
    override func updateView() {
        shelfCollectionView.reloadData()
    }
    
    override func reloadData() {
        amiiboItens = getShelfAmiibo()
        updateView()
    }
    
    override func new(amiibo: Amiibo) {
        return
    }
    
    override func source(forLocation location: CGPoint) -> AmiiboDisplayProtocol? {
        guard let indexPath = shelfCollectionView.indexPathForItem(at: location),
              let cell = shelfCollectionView.cellForItem(at: indexPath) as? ShelfItemCollectionViewCell else {
            return nil
        }
        return cell
    }
    
    // MARK: Methods
    func getShelfAmiibo() -> [Amiibo] {
        Amiibo.from(cdAmiibos: CoreDataManager.current.fetchAllShelfAmiibo())
    }
    
    func showNoAmiiboOnShelfAlert() {
        let alertController = UIAlertController (title: "My Shelf", message: "There's no amiibo on the shelves! Add one by selecting an Amiibo -> Add to Shelf", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: MyShelfViewController Collection
extension MyShelfViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = shelfCollectionView.dequeueReusableCell(withReuseIdentifier: "ShelfItem", for: indexPath) as? ShelfItemCollectionViewCell else { return ShelfItemCollectionViewCell() }

        let amiibo = searchResults[indexPath.row]
        cell.amiibo = amiibo
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height/6, height: collectionView.frame.height/6)
    }
}

// MARK: MyShelfViewController AmiiboShelfDelegate
extension MyShelfViewController: AmiiboShelfDelegate {
    func addedToShelf(amiibo: Amiibo) {
        self.amiiboItens.append(amiibo)
        self.updateView()
    }
    
    func removedFromShelf(amiibo: Amiibo) {
        self.amiiboItens.removeAll { shelfAmiibo in
            return shelfAmiibo.id == amiibo.id
        }
        self.updateView()
    }
}
