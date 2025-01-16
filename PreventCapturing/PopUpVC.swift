//
//  PopUpVC.swift
//  PreventCapturing
//
//  Created by ToTo on 16/1/25.
//

import Foundation
import UIKit
class PopUpVC : UIViewController {
    @IBOutlet weak var lilpopupContainer : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lilpopupContainer.layer.cornerRadius = 10
        lilpopupContainer.layer.masksToBounds = true
    }
}
