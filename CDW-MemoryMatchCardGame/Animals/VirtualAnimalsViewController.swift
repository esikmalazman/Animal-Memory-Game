//
//  VirtualAnimalsViewController.swift
//  CDW-MemoryMatchCardGame
//
//  Created by Ikmal Azman on 27/05/2023.
//

import UIKit
import QuickLook

final class VirtualAnimalsViewController: QLPreviewController {

    var animalsName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension VirtualAnimalsViewController : QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        guard let path = Bundle.main.url(forResource: animalsName, withExtension: "usdz") else {
            fatalError("Could not found usdz model for : \(animalsName ?? "-")")
        }
        return path as QLPreviewItem
    }
}
