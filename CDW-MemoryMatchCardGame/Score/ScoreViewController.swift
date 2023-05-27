//
//  ScoreViewController.swift
//  CDW-MemoryMatchCardGame
//
//  Created by Ikmal Azman on 27/05/2023.
//

import UIKit

final class ScoreViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var resultsTitle: UILabel!
    
    private (set) var scores = [Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(ScoreCardCell.nib(), forCellWithReuseIdentifier: ScoreCardCell.identifier)
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func configureScore(_ matchesCard : [Card]) {
        scores = matchesCard
        loadViewIfNeeded()
        resultsTitle.text = "You complete \(scores.count) matched cards, Congrats !!"
        collectionView.reloadData()
    }
}

// MARK:  UICollectionViewDataSource
extension ScoreViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scores.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScoreCardCell.identifier, for: indexPath) as! ScoreCardCell
        cell.delegate = self
        return cell
    }
}

extension ScoreViewController : ScoreCardCellDelegate {
    func didSelectPlaySound(_ card: Card) {
        
    }
    
    func didSelectVirtualAnimal(_ card: Card) {
        
    }
}
