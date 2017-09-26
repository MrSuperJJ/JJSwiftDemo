//
//  SharedViewController.swift
//  ShareViewDemo
//
//  Created by 叶佳骏 on 2017/9/26.
//  Copyright © 2017年 Mr.JJ. All rights reserved.
//

import UIKit
import MBProgressHUD

class SharedViewController: UIViewController {
    
    var sharedView: HYSharedView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white
        
        let button = UIButton(frame: CGRect(adX: 10, adY: 60, adWidth: 100, adHeight: 100))
        button.setTitle("点击", for: .normal)
        button.backgroundColor = UIColor.gray
        button.addTarget(self, action: #selector(click), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sharedView = HYSharedView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), sharedCommonTypes: [.sendToColleague, .wechatFriend, .wechatCircle, .sendToColleague, .wechatFriend, .wechatCircle], sharedNormalTypes: [.copy, .refresh])
        sharedView.delegate = self
        self.view.window?.addSubview(sharedView!)
        sharedView.hideWithoutAnimataion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @objc func click() {
        sharedView.show()
    }
}

extension SharedViewController: HYSharedViewDelegate {
    
    func didSharedCommonButtonClicked(type: SharedCommonType) {
        printLog(type.title)
        showPopView(message: type.title, showTime: 1)
        sharedView.hide()
    }
    
    func didSharedNormalButtonClicked(type: SharedNormalType) {
        printLog(type.title)
        showPopView(message: type.title, showTime: 1)
        sharedView.hide()
    }
    
    func showPopView(message: String, showTime: TimeInterval) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .text
        hud.label.text = message
        DispatchQueue.main.asyncAfter(deadline: .now() + showTime) {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}

