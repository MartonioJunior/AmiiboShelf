//
//  CardViewController.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 16/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import UIKit

class CardViewController: AmiiboViewController {
    @IBOutlet weak var cardCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        amiiboItens = Amiibo.from(cdAmiibos: CoreDataManager.current.fetchAllCardAmiibo())
        registerForPreviewing(with: self, sourceView: cardCollectionView)
    }

    override func reloadData() {
        amiiboItens = Amiibo.from(cdAmiibos: CoreDataManager.current.fetchAllCardAmiibo())
        updateView()
    }
    
    override func updateView() {
        DispatchQueue.main.async {
            self.cardCollectionView.reloadData()            
        }
    }
    
    override func source(forLocation location: CGPoint) -> AmiiboDisplayProtocol? {
        guard let indexPath = cardCollectionView.indexPathForItem(at: location), let cell = cardCollectionView.cellForItem(at: indexPath) as? CardItemCollectionViewCell else {
            return nil
        }
        return cell
    }
    
    override func new(amiibo: Amiibo) {
        if amiibo.type == "Card" {
            super.new(amiibo: amiibo)
        }
    }
}

extension CardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = cardCollectionView.dequeueReusableCell(withReuseIdentifier: "Card", for: indexPath) as? CardItemCollectionViewCell else {
            return CardItemCollectionViewCell()
        }
        let amiibo = searchResults[indexPath.row]
        cell.amiibo = amiibo
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let scaleSize = collectionView.frame.width/3.5
        return CGSize(width: scaleSize, height: scaleSize*1.5)
    }
    
}
