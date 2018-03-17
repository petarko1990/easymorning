//
//  WebViewController.swift
//  EasyMornig
//
//  Created by Petar Korda on 6/15/17.
//  Copyright © 2017 Cash Me Outside. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.loadRequest(URLRequest(url: URL(string: url!)!))
        
    }
    
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    

}
