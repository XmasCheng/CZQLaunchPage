//
//  CZQJumpButton.swift
//  CZQLaunchView
//
//  Created by parkhome1 on 2018/1/23.
//  Copyright © 2018年 parkhome1. All rights reserved.
//

import UIKit

@objc protocol ClickJumpDelegate {
    func jumpToLaunchPage()
}

class CZQJumpButton: UIButton {
    
    //默认是三秒
    weak var delegate:ClickJumpDelegate?
    fileprivate var timer:Timer?
    fileprivate var captcha:Int?
    init(second:Int) {
        let frame = CGRect.init(x: kScreenWidth * 0.8, y: kScreenWidth * 0.1, width: 70, height: 35)
        super.init(frame: frame)
        self.setTitleColor(UIColor.white, for: .normal)
        self.addTarget(self, action: #selector(clickJumpButtonAction), for: .touchUpInside)
        self.backgroundColor = UIColor.gray
        self.layer.cornerRadius = 17.5
        startTimer(second: second)
    }
    
    //开启定时器
    func startTimer(second:Int) {
        if self.timer == nil {
            captcha = second
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(captchaChange), userInfo: nil, repeats: true)
            timer?.fire()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension CZQJumpButton{
    @objc fileprivate func captchaChange(){
        captcha! -= 1
        self.setTitle("\(captcha!) 跳过", for: .normal)
        if captcha! <= 0 {
            stopCaptcha()
        }
    }
    fileprivate func stopCaptcha(){
        timer?.invalidate()
        timer = nil
        clickJumpButtonAction()
    }
    
    @objc fileprivate func clickJumpButtonAction(){
        delegate?.jumpToLaunchPage()
    }
    
}
