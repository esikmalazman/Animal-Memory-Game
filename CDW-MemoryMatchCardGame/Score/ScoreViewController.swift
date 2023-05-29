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
    @IBOutlet weak var restartButton: UIButton!
    
    private (set) var scores = [Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restartButton.layer.cornerRadius = 5
        collectionView.register(ScoreCardCell.nib(), forCellWithReuseIdentifier: ScoreCardCell.identifier)
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func configureScore(_ matchesCard : [Card]) {
        scores = matchesCard
        loadViewIfNeeded()
        resultsTitle.text = "You complete \(scores.count) matches, Congrats !!"
        collectionView.reloadData()
    }
}

extension ScoreViewController {
    @IBAction func restartTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK:  UICollectionViewDataSource
extension ScoreViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scores.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let card = scores[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScoreCardCell.identifier, for: indexPath) as! ScoreCardCell
        cell.configureScoreCard(card)
        cell.delegate = self
        return cell
    }
}

extension ScoreViewController : ScoreCardCellDelegate {
    func didSelectPlaySound(_ card: Card) {
        SoundManager.playTextToSpeech(card.cardLabel)
    }
    
    func didSelectVirtualAnimal(_ card: Card) {
        let virtualAnimalsVC = VirtualAnimalsViewController()
        virtualAnimalsVC.animalsName = card.cardName
        virtualAnimalsVC.modalPresentationStyle = .fullScreen
        navigationController?.present(virtualAnimalsVC, animated: true)
    }
}
