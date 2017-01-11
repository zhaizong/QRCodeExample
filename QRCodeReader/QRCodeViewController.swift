//
//  QRCodeViewController.swift
//  QRCodeReader
//
//  Created by Crazy on 10/1/2017.
//  Copyright © 2017 Crazy. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }
  
  // MARK: - Navigation

  @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
    dismiss(animated: true, completion: nil)
  }

}
