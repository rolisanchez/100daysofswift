//
//  DetailViewController.swift
//  Project16
//
//  Created by Victor Rolando Sanchez Jara on 3/6/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var capital: Capital?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
        
        guard let capital = capital else { return }
        
        let url = URL(string: "https://en.wikipedia.org/wiki/" + capital.wikiLink)!
        
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
