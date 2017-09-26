//
//  WeakScriptMessageHandler.swift
//  JJSwiftDemo
//
//  Created by Mr.JJ on 2017/4/11.
//  Copyright © 2017年 yejiajun. All rights reserved.
//

import UIKit
import WebKit

/**
 解决循环引用导致WKScriptMessageHandler无法释放的问题
 */
class WeakScriptMessageHandler: NSObject {

    weak var delegate: WKScriptMessageHandler?

    init(delegate: WKScriptMessageHandler) {
        self.delegate = delegate
    }

    deinit {
        print("\(self.description)")
    }
}

// MARK: - WKScriptMessageHandler
extension WeakScriptMessageHandler: WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.delegate?.userContentController(userContentController, didReceive: message)
    }
}
