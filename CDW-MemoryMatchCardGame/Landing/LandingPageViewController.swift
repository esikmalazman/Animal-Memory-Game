//
//  LandingPageViewController.swift
//  CDW-MemoryMatchCardGame
//
//  Created by Ikmal Azman on 29/05/2023.
//

import UIKit

final class LandingPageViewController: UIViewController {

    @IBOutlet weak var learningBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        learningBtn.layer.cornerRadius = 5
    }

    @IBAction func learningTapped(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: .main)
        let vc = sb.instantiateViewController(withIdentifier: "\(CardGameViewController.self)") as! CardGameViewController
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
}
