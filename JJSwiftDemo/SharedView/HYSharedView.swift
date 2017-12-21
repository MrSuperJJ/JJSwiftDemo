//
//  HYPushShareView.swift
//  e企_2015
//
//  Created by 叶佳骏 on 2017/9/25.
//  Copyright © 2017年 中移（杭州）信息技术有限公司. All rights reserved.
//

import UIKit

@objc(HYSharedViewDelegate)
protocol HYSharedViewDelegate {
    func didSharedCommonButtonClicked(type: SharedCommonType)
    func didSharedNormalButtonClicked(type: SharedNormalType)
}

class HYSharedView: UIView {

    // MARK: - properties
    weak internal var delegate: HYSharedViewDelegate?

    fileprivate lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hide))
        backgroundView.addGestureRecognizer(tapGesture)
        return backgroundView
    }()
    
    fileprivate lazy var sharedView: UIView = {
        let sharedView = UIView()
        sharedView.backgroundColor = UIColor.white
        return sharedView
    }()
    
    private lazy var topView: UIView = {
        let topView = UIView()
        topView.backgroundColor = UIColor.clear
        return topView
    }()
    
    private lazy var titleView: UILabel = {
        let titleView = UILabel()
        titleView.text = "分享到"
        titleView.font = UIFont.systemFont(ofSize: CGFloat(adValue: 13))
        titleView.textColor = UIColor(valueRGB: 0x999999, alpha: 1)
        return titleView
    }()
    
    private lazy var titleLeftLine: UIView = {
        let titleLeftLine = UIView()
        titleLeftLine.backgroundColor = UIColor(valueRGB: 0xdddddd, alpha: 1)
        return titleLeftLine
    }()
    
    private lazy var titleRightLine: UIView = {
        let titleRightLine = UIView()
        titleRightLine.backgroundColor = UIColor(valueRGB: 0xdddddd, alpha: 1)
        return titleRightLine
    }()
    
    private lazy var commonScrollView: UIScrollView = {
        let commonScrollView = UIScrollView()
        commonScrollView.backgroundColor = UIColor.clear
        commonScrollView.showsVerticalScrollIndicator = false
        commonScrollView.showsHorizontalScrollIndicator = false
        return commonScrollView
    }()
    
    private lazy var contentDividingLine: UIView = {
        let contentDividingLine = UIView()
        contentDividingLine.backgroundColor = UIColor(valueRGB: 0xdddddd, alpha: 1)
        return contentDividingLine
    }()
    
    private lazy var normalScrollView: UIScrollView = {
        let normalScrollView = UIScrollView()
        normalScrollView.backgroundColor = UIColor.clear
        normalScrollView.showsHorizontalScrollIndicator = false
        normalScrollView.showsVerticalScrollIndicator = false
        return normalScrollView
    }()
    
    private lazy var bottomDividingLine: UIView = {
        let bottomDividingLine = UIView()
        bottomDividingLine.backgroundColor = UIColor(valueRGB: 0xdddddd, alpha: 1)
        return bottomDividingLine
    }()
    
    fileprivate lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor(valueRGB: 0x1da1f2, alpha: 1), for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(16))
        cancelButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
        return cancelButton
    }()
    
    fileprivate let animationTime = 0.25
    fileprivate let backgroundViewAlpha: CGFloat = 0.35
    fileprivate var sharedViewHeight: CGFloat = 0
    private let padding: CGFloat = 20
    private let topViewHeight: CGFloat = 20
    private let srollViewHeight: CGFloat = JJAdapter(65)
    private let bottomDividingLineHeight: CGFloat = 5
    private let bottomViewHeight: CGFloat = 45
    private var sharedButtonWith: CGFloat = 0
    private var isNormalScrollViewHidden = false
    
    // 兼容OC的初始化方法
    convenience init(frame: CGRect, commonTypes: [NSInteger], normalTypes: [NSInteger]?) {
        self.init(frame: frame, commonTypes: commonTypes, normalTypes: normalTypes, title: nil)
    }
    
    // 兼容OC的初始化方法
    convenience init(frame: CGRect, commonTypes: [NSInteger], normalTypes: [NSInteger]?, title: String?) {
        var sharedCommonTypes = [SharedCommonType]()
        var sharedNormalTypes = [SharedNormalType]()
        commonTypes.forEach { type in
            if let commonType = SharedCommonType(rawValue: type) {
                sharedCommonTypes += [commonType]
            }
        }
        if let normalTypes = normalTypes {
            normalTypes.forEach { type in
                if let normalType = SharedNormalType(rawValue: type) {
                    sharedNormalTypes += [normalType]
                }
            }
        }
        self.init(frame: frame, sharedCommonTypes: sharedCommonTypes, sharedNormalTypes: sharedNormalTypes, title: title)
    }
    
    // Swift初始化方法
    init(frame: CGRect, sharedCommonTypes: [SharedCommonType], sharedNormalTypes: [SharedNormalType], title: String? = "分享到" ) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        sharedButtonWith = ScreenWidth / CGFloat(sharedCommonTypes.count >= 3 ? 3 : sharedCommonTypes.count)
        
        if sharedNormalTypes.count > 0 {
            sharedViewHeight = padding + topViewHeight + padding + srollViewHeight * 2 + padding * 3 + bottomDividingLineHeight + bottomViewHeight
        } else {
            isNormalScrollViewHidden = true
            sharedViewHeight = padding + topViewHeight + padding + srollViewHeight + padding + bottomDividingLineHeight + bottomViewHeight
        }

        self.addSubview(backgroundView)
        self.addSubview(sharedView)
        sharedView.addSubview(topView)
        sharedView.addSubview(bottomDividingLine)
        sharedView.addSubview(cancelButton)
        topView.addSubview(titleView)
        topView.addSubview(titleLeftLine)
        topView.addSubview(titleRightLine)
        sharedView.addSubview(commonScrollView)
        if !isNormalScrollViewHidden {
            sharedView.addSubview(contentDividingLine)
            sharedView.addSubview(normalScrollView)
        }
        
        layoutSnpSubviews()
        
        titleView.text = title
        
        commonScrollView.contentSize = CGSize(width: CGFloat(sharedCommonTypes.count) * sharedButtonWith, height: 0)
        for (index, type) in sharedCommonTypes.enumerated() {
            let frame = CGRect(x: CGFloat(index) * sharedButtonWith, y: 0, width: sharedButtonWith, height: srollViewHeight)
            let sharedButton = HYSharedButton(frame: frame, title: type.title, imageName: type.imageName)
            sharedButton.tag = type.rawValue
            sharedButton.addTarget(self, action: #selector(sharedCommonButtonClicked(sender:)), for: .touchUpInside)
            commonScrollView.addSubview(sharedButton)
        }
        
        normalScrollView.contentSize = CGSize(width: CGFloat(sharedNormalTypes.count) * sharedButtonWith, height: 0)
        for (index, type) in sharedNormalTypes.enumerated() {
            let frame = CGRect(x: CGFloat(index) * sharedButtonWith, y: 0, width: sharedButtonWith, height: srollViewHeight)
            let sharedButton = HYSharedButton(frame: frame, title: type.title, imageName: type.imageName)
            sharedButton.tag = type.rawValue
            sharedButton.addTarget(self, action: #selector(sharedNormalButtonClicked(sender:)), for: .touchUpInside)
            normalScrollView.addSubview(sharedButton)
        }
    }
    
    private func layoutSnpSubviews() {
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.size.equalTo(self)
        }
        
        sharedView.snp.makeConstraints { make in
            make.top.equalTo(self.bottom)
            make.left.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(sharedViewHeight)
        }
        
        topView.snp.makeConstraints { make in
            make.top.equalTo(sharedView).offset(padding)
            make.left.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(topViewHeight)
        }
        
        titleView.snp.makeConstraints { make in
            make.center.equalTo(topView)
            make.width.greaterThanOrEqualTo(1)
            make.height.equalTo(topView)
        }
        
        titleLeftLine.snp.makeConstraints { make in
            make.left.equalTo(topView).offset(JJAdapter(20))
            make.right.equalTo(titleView.snp.left).offset(JJAdapter(-15))
            make.centerY.equalTo(topView)
            make.height.equalTo(0.5)
        }
        
        titleRightLine.snp.makeConstraints { make in
            make.right.equalTo(topView).offset(JJAdapter(-20))
            make.left.equalTo(titleView.snp.right).offset(JJAdapter(15))
            make.centerY.equalTo(titleLeftLine)
            make.height.equalTo(titleLeftLine)
        }
        
        commonScrollView.snp.makeConstraints { make in
            make.left.equalTo(sharedView)
            make.top.equalTo(topView.snp.bottom).offset(padding)
            make.width.equalTo(sharedView)
            make.height.equalTo(srollViewHeight)
        }
        
        if !isNormalScrollViewHidden {
            contentDividingLine.snp.makeConstraints { make in
                make.left.equalTo(sharedView)
                make.right.equalTo(sharedView)
                make.bottom.equalTo(commonScrollView).offset(padding)
                make.height.equalTo(titleLeftLine)
            }
            
            normalScrollView.snp.makeConstraints { make in
                make.left.equalTo(commonScrollView)
                make.top.equalTo(contentDividingLine.snp.bottom).offset(padding)
                make.width.equalTo(commonScrollView)
                make.height.equalTo(commonScrollView)
            }
        }
        
        bottomDividingLine.snp.makeConstraints { make in
            if !isNormalScrollViewHidden {
                make.top.equalTo(normalScrollView.snp.bottom).offset(padding)
            } else {
                make.top.equalTo(commonScrollView.snp.bottom).offset(padding)
            }
            make.left.equalTo(sharedView)
            make.width.equalTo(sharedView)
            make.height.equalTo(bottomDividingLineHeight)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.bottom.equalTo(sharedView)
            make.left.equalTo(sharedView)
            make.width.equalTo(sharedView)
            make.height.equalTo(bottomViewHeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Action
extension HYSharedView {
    
    internal func show() {
        self.isHidden = false
        UIView.animate(withDuration: animationTime) {
            self.backgroundView.alpha = self.backgroundViewAlpha
            self.sharedView.frame = CGRect(x: 0, y: ScreenHeight - self.sharedViewHeight, width: ScreenWidth, height: self.sharedViewHeight)
        }
    }
    
    @objc internal func hide() {
        UIView.animate(withDuration: animationTime, animations: {
            self.backgroundView.alpha = 0
            self.sharedView.frame = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: self.sharedViewHeight)
        }) { isCompleted in
            self.isHidden = true
        }
    }
    
    internal func hideWithoutAnimataion() {
        self.backgroundView.alpha = 0
        self.sharedView.frame = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: self.sharedViewHeight)
        self.isHidden = true
    }
    
    @objc fileprivate func sharedCommonButtonClicked(sender: UIButton) {
        let type = SharedCommonType(rawValue: sender.tag)
        if let type = type {
            self.delegate?.didSharedCommonButtonClicked(type: type)
        }
    }
    
    @objc fileprivate func sharedNormalButtonClicked(sender: UIButton) {
        let type = SharedNormalType(rawValue: sender.tag)
        if let type = type {
            self.delegate?.didSharedNormalButtonClicked(type: type)
        }
    }
    
}

