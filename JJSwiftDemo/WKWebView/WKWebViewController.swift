//
//  ViewController.swift
//  SwiftTest
//
//  Created by Mr.JJ on 2017/4/10.
//  Copyright © 2017年 Mr.JJ. All rights reserved.
//

import UIKit
import WebKit

// JS调用Swift函数名称
let JS_TO_SWIFT = "JSToSwift"
// Swift调用JS函数名称
let SWIFT_TO_JS = "SwiftToJS"

class WKWebViewController: UIViewController {

    // MARK: 属性
    var wkWebview: WKWebView?

    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let config = WKWebViewConfiguration()
        let userContent = WKUserContentController()
        config.userContentController = userContent

        wkWebview = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), configuration: config)
        wkWebview?.uiDelegate = self
        if let webview = wkWebview,  let htmlPath = Bundle.main.path(forResource: "test", ofType: "html"){
            let locallHtml = try! NSString.init(contentsOfFile: htmlPath, encoding: String.Encoding.utf8.rawValue)
            let baseURL = URL.init(fileURLWithPath: htmlPath)
            webview.loadHTMLString(locallHtml as String, baseURL: baseURL)
            self.view.addSubview(webview)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addAllScriptMessageHandlers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeAllScriptMessageHandlers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - 添加/删除JS(JS调用iOS)
extension WKWebViewController {

    func addAllScriptMessageHandlers() {
        if let webview = wkWebview {
            let userContentController = webview.configuration.userContentController
            userContentController.add(WeakScriptMessageHandler.init(delegate: self), name: JS_TO_SWIFT)
        }
    }

    func removeAllScriptMessageHandlers() {
        if let webview = wkWebview {
            let userContentController = webview.configuration.userContentController
            userContentController.removeScriptMessageHandler(forName: JS_TO_SWIFT)
        }
    }
}

// MARK: - 添加JS(Swift调用JS)
extension WKWebViewController {

    func evaluateJavaScript(dict: NSDictionary) {
        if let webview = wkWebview {
            let name = dict["name"] as! String
            let age  = dict["age"] as! String
            let jsString = SWIFT_TO_JS + "(\(name),\(age))"
            webview.evaluateJavaScript(jsString, completionHandler: { (response, error) in
                if let e = error {
                    print(e)
                }
            })
        }
    }
}

// MARK: - WKUIDelegate
// WKWebView加载网页，不显示JS的Alert弹框的问题
extension WKWebViewController: WKUIDelegate {

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {

        let alertController = UIAlertController.init(title: "Title", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "OK", style: .default) { (_) in
            completionHandler()
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {

        let alertController = UIAlertController.init(title: "Title", message: defaultText, preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "OK", style: .default) { (_) in
            completionHandler(defaultText)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)

    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {

        let alertController = UIAlertController.init(title: "Title", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "OK", style: .default) { (_) in
            completionHandler(true)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)

    }
}

// MARK: - WKScriptMessageHandler
extension WKWebViewController: WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        let name = message.name
        let body = message.body as! NSDictionary

        if name == JS_TO_SWIFT {
            print("\(body)")
            self.evaluateJavaScript(dict: body)
        }
    }
}


