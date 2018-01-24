//
//  ViewController.swift
//  CZQLaunchView
//
//  Created by parkhome1 on 2018/1/23.
//  Copyright © 2018年 parkhome1. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    fileprivate var launchView:CZQLaunchView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首页"
        //静态图片
//        self.addStaticLaunch()
        
        //动态图片
//        self.addDynamicLaunch()
        //视频
        self.addVideoLaunch()
        let label = UILabel.init()
        label.center = CGPoint(x: self.view.center.x - 60, y: self.view.center.y)
        label.frame.size = CGSize(width: 120, height: 30)
        label.text = "成功启动页"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        self.view.addSubview(label)
        
    }
    
    //加载静止图片
    fileprivate func addStaticLaunch(){
        let imageNames = ["guide00","guide01","guide02"]
        launchView = CZQLaunchView.init(imageNameArray: imageNames, second:10)
        self.navigationController?.view.addSubview(launchView!)
    }
    //加载动态图片
    fileprivate func addDynamicLaunch(){
        let imageNames = ["guideImage1.gif","guideImage2.gif","guideImage3.gif"]
        launchView = CZQLaunchView.init(imageNameArray: imageNames,second:12)
        self.navigationController?.view.addSubview(launchView!)
    }
    //加载视频
    fileprivate func addVideoLaunch(){
        let path = Bundle.main.path(forResource: "voice.mp4", ofType: nil)
        let url = NSURL.fileURL(withPath: path!)
        launchView = CZQLaunchView.init(videoUrl: url)
        self.navigationController?.view.addSubview(launchView!)
    }
    

}


