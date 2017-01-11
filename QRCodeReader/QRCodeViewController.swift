//
//  QRCodeViewController.swift
//  QRCodeReader
//
//  Created by Simon Ng on 13/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
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
