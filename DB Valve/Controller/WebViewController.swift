//
//  WebViewController.swift
//  DB Valve
//
//  Created by Lokesh Kumar on 03/03/20.
//  Copyright © 2020 Lokesh Kumar. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var item: DataModel!
    
    /// Progress view reflecting the current loading progress of the web view.
    fileprivate let progressView = UIProgressView(progressViewStyle: .default)
    
    /// The observation object for the progress of the web view (we only receive notifications until it is deallocated).
    private var estimatedProgressObserver: NSKeyValueObservation?
    
    lazy var activityIndicator: MKActivityIndicator = {
        let activity = MKActivityIndicator(frame: CGRect(x: (self.view.width/2)-30, y: 160, width: 60, height: 60))
        activity.color = UIColor(red: 255, green: 195, blue: 11)
        self.view.addSubview(activity)
        return activity
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.title = item.name
        //self.webView.scrollView.contentInset = UIEdgeInsets(top: -60, left: 0, bottom: 0, right: 0)
        activityIndicator.startAnimating()
        setupProgressView()
        setupEstimatedProgressObserver()
        
        if let strUrl = item.url, let url = URL(string: strUrl) {
            let req = URLRequest(url: url)
            self.webView.navigationDelegate = self
            self.webView.load(req)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.progressView.removeFromSuperview()
    }
    
    private func setupProgressView() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(progressView)
        
        progressView.isHidden = true
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor),
            
            progressView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2.0)
        ])
    }
    
    private func setupEstimatedProgressObserver() {
        estimatedProgressObserver = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            self?.progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
}

// MARK: - WKNavigationDelegate
/// By implementing the `WKNavigationDelegate` we can update the visibility of the `progressView` according to the `WKNavigation` loading progress.
/// The view-visibility updates are based on my gist [fxm90/UIView+AnimateIsHidden.swift](https://gist.github.com/fxm90/723b5def31b46035cd92a641e3b184f6)
extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
    
    func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        if progressView.isHidden {
            // Make sure our animation is visible.
            progressView.isHidden = false
        }
        
        UIView.animate(withDuration: 0.33,
                       animations: {
                        self.progressView.alpha = 1.0
        })
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.33,
                       animations: {
                        self.progressView.alpha = 0.0
        },
                       completion: { isFinished in
                        // Update `isHidden` flag accordingly:
                        //  - set to `true` in case animation was completly finished.
                        //  - set to `false` in case animation was interrupted, e.g. due to starting of another animation.
                        self.progressView.isHidden = isFinished
        })
                
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.url?.absoluteString,
            url == "http://www.dbvalves.com/" ||
                url == "http://dbvalves.com/thank-you.html" {
            self.navigationController?.popViewController(animated: true)
        }
        
        if let url = navigationAction.request.url?.absoluteString,
            url == "http://www.dbvalves.com/enquiry-mobile.html/" ||
                url == "http://www.dbvalves.com/enquiry-mobile.html",
                 Locale.current.regionCode != "IN" {
            
            AKAlertController.alert(item.name, message: "Do you want to purchase this product or making enquiry only.", buttons: ["Enquiry", "Purchase"]) { (_, _, index) in
                switch index {
                case 0:
                    decisionHandler(.allow)
                default:
                    decisionHandler(.cancel)

                    let vc = FormViewController.instantiate(fromAppStoryboard: .Main)
                    vc.title = "Enter Details"
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
            
        } else {
            decisionHandler(.allow)
            
        }

       
    }
    
}


extension WebViewController: NavigationBarColorable {
    var navigationBarTintColor: UIColor? {
        return UIColor(red: 255, green: 195, blue: 11)
    }
}

