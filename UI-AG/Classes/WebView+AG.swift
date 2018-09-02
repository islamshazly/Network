//
//  WebView+AG.swift
//
//  Created by islam Elshazly on 8/29/18.
//

import UIKit

open class BlockWebView: UIWebView, UIWebViewDelegate {
    open var didStartLoad: ((URLRequest) -> Void)?
    open var didFinishLoad: ((URLRequest) -> Void)?
    open var didFailLoad: ((URLRequest, Error) -> Void)?
    
    open var shouldStartLoadingRequest: ((URLRequest) -> (Bool))?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func webViewDidStartLoad(_ webView: UIWebView) {
        didStartLoad? (webView.request!)
    }
    
    open func webViewDidFinishLoad(_ webView: UIWebView) {
        didFinishLoad? (webView.request!)
    }
    
    open func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        didFailLoad? (webView.request!, error)
    }
    
    open func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let should = shouldStartLoadingRequest {
            return should (request)
        } else {
            return true
        }
    }
}
