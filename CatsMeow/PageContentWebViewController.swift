//
//  PageContentWebViewController.swift
//  CatsMeow
//
//  Created by Coleman, Ray on 1/15/23.
//

import UIKit
import WebKit

class PageContentWebViewController: UIViewController, WKNavigationDelegate
{
    // create our properties
    var webView: WKWebView!
    var catURL: String = SERVER_PATH + catObjectArray[0]._id
    var pageIndex: Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // get the screen dimensions
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height - 20
        
        // setup the webview for the page view container
        let rect = CGRect(x: 0, y: 20, width: width, height: height)
        webView = WKWebView(frame: rect)
        self.view.addSubview(webView)
        
        // update and view the URL
        let url = URL(string: catURL)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}
