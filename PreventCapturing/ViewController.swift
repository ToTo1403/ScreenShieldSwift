//
//  ViewController.swift
//  PreventCapturing
//
//  Created by ToTo on 16/1/25.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var myView : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        enableSecureScreen(for: myView)
    }


}

