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
    var resynthator: Resynthator? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recitadeMultyParagraphText(sender: AnyObject) {
        let paragraphs = ["This is a multi Paragraph Text", "where we will try out our Framework", "at some point we want to be able to", "jump between parts of this", "with the system Controlls for Audio"]
        resynthator = paragraphs.recitade()
    }

    @IBAction func recitadeTextField(sender: AnyObject) {
        resynthator = textField.text.recitade()
    }
}

