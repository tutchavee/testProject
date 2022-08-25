//
//  WebViewViewController.swift
//  FoodStory_Owner
//
//  Created by Nuttanai on 18/3/2564 BE.
//  Copyright (c) 2564 BE LivingMobile. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {
    // MARK: @IBOutlet
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextImage: UIImageView!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var shareView: UIView!
    @objc var url: URL?
    
    var interactor: WebViewBusinessLogic?
    var router: (NSObjectProtocol & WebViewRoutingLogic & WebViewDataPassing)?
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWebView()
    }
    
    @IBAction func backAction(_ sender: Any) {
        if webView.canGoBack {
            webView.stopLoading()
            webView.goBack()
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if webView.canGoForward {
            webView.stopLoading()
            webView.goForward()
        }
    }
    
    @IBAction func reloadAction(_ sender: Any) {
        webView.reload()
    }
    
    @IBAction func shareAction(_ sender: Any) {
        if #available(iOS 13.0, *) {
            setSharePopup(sender)
        }
    }
    // MARK: Do something
    
    func setWebView() {
        webView.navigationDelegate = self
        webView.isUserInteractionEnabled = true
        webView.allowsBackForwardNavigationGestures = true
        if let urlDestination = url {
            webView.load(URLRequest(url: urlDestination))
        }
        setPageNavigation()
    }
    
    func setPageNavigation() {
        if webView.canGoBack {
            backImage.image = UIImage(named: "webViewBackEnable")
        } else {
            backImage.image = UIImage(named: "webViewBackDisable")
        }
        if webView.canGoForward {
            nextImage.image = UIImage(named: "webViewNextEnable")
        } else {
            nextImage.image = UIImage(named: "webViewNextDisable")
        }
        if let webViewUrl = webView.title {
            urlLabel.text = "\(webViewUrl)"
        }
    }
    
    @available(iOS 13.0, *)
    func setSharePopup(_ sender: Any) {
        if let titleActivityItem = webView.title, let urlActivityItem = webView.url, let sourceView = sender as? UIButton {
            let activityViewController = UIActivityViewController(
                activityItems: [titleActivityItem, urlActivityItem, UIImage()], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = sourceView
            activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 50, width: 0, height: 0)
            activityViewController.activityItemsConfiguration = [
                UIActivity.ActivityType.message
            ] as? UIActivityItemsConfigurationReading
            activityViewController.excludedActivityTypes = [
                UIActivity.ActivityType.postToWeibo,
                UIActivity.ActivityType.print,
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.addToReadingList,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo,
                UIActivity.ActivityType.postToFacebook
            ]
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: Setup & Configuration
extension WebViewViewController {
    private func setup() {
        
    }
    
    private func configure() {
        WebViewConfiguration.shared.configure(self)
    }
}

extension WebViewViewController : WebViewDisplayLogic {
}

extension WebViewViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        setPageNavigation()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        setPageNavigation()
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
        setPageNavigation()
    }
}
