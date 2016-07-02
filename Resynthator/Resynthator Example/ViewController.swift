//
//  ViewController.swift
//  Resynthator Example
//
//  Created by Peter Schumacher on 22.06.16.
//
//

import UIKit
import Resynthator

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func recitadeTextField(sender: AnyObject) {
        textField.text.recitade()
    }
}

