//
//  SharedType.swift
//  ShareViewDemo
//
//  Created by 叶佳骏 on 2017/9/26.
//  Copyright © 2017年 Mr.JJ. All rights reserved.
//

import Foundation

protocol SharedType {
    var title: String { get }      ///标题
    var imageName: String { get }  ///图片名称
}

/// 常用
@objc enum SharedCommonType: NSInteger, SharedType {
    case sendToColleague = 1000 ///发送给同事
    case wechatFriend           ///分享给微信好友
    case wechatCircle           ///分享到微信朋友圈
    case shortMessage           ///短信
    
    var title: String {
        switch self {
        case .sendToColleague:
            return "同事"
        case .wechatFriend:
            return "微信好友"
        case .wechatCircle:
            return "微信朋友圈"
        case .shortMessage:
            return "短信"
        }
    }
    
    var imageName: String {
        switch self {
        case .sendToColleague:
            return "sendToColleague"
        case .wechatFriend:
            return "wechatFriend"
        case .wechatCircle:
            return "wechatCircle"
        case .shortMessage:
            return "shortMessage"
        }
    }
}

// 普通
@objc enum SharedNormalType: NSInteger, SharedType {
    case copy = 1000           ///复制链接
    case refresh               ///刷新页面
    
    var title: String {
        switch self {
        case .copy:
            return "复制链接"
        case .refresh:
            return "刷新"
        }
    }
    
    var imageName: String {
        switch self {
        case .copy:
            return "copy"
        case .refresh:
            return "refresh"
        }
    }
}
