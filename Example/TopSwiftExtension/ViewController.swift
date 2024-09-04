//
//  ViewController.swift
//  TopSwiftExtension
//
//  Created by ishupassi1990 on 09/04/2024.
//  Copyright (c) 2024 ishupassi1990. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set date
        self.dateLabel?.text = "Date : " + "\(Data())"
    }
}

