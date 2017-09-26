//
//  HYSharedButton.swift
//  ShareViewDemo
//
//  Created by 叶佳骏 on 2017/9/26.
//  Copyright © 2017年 Mr.JJ. All rights reserved.
//

import UIKit

class HYSharedButton: UIButton {
    
    private lazy var sharedTitleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: CGFloat(adValue: 12))
        titleLabel.textColor = UIColor(valueRGB: 0x333333, alpha: 1)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private lazy var sharedImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    init(frame: CGRect, title: String, imageName: String) {
        super.init(frame: frame)
        
        self.addSubview(sharedTitleLabel)
        self.addSubview(sharedImageView)
        layoutSnpSubviews()
        
        sharedTitleLabel.text = title
        if let image = UIImage(named: imageName) {
            sharedImageView.image = image
        }
    }
    
    private func layoutSnpSubviews() {
        sharedImageView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: JJAdapter(45), height: JJAdapter(45)))
        }
        
        sharedTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(sharedImageView.snp.bottom)
            make.left.equalTo(self)
            make.bottom.equalTo(self)
            make.width.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//    }
}

