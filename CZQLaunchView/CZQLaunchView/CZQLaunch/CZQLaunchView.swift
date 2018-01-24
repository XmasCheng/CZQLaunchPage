//
//  CZQLaunchView.swift
//  CZQLaunchView
//
//  Created by parkhome1 on 2018/1/23.
//  Copyright © 2018年 parkhome1. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height

class CZQLaunchView: UIView {
    var experName:String?
    fileprivate var scrollView:UIScrollView!
    fileprivate var imageArray:[String]?
    fileprivate var jumpButton:CZQJumpButton?
    fileprivate var experButton:UIButton?
    fileprivate var pageControl:UIPageControl?
    fileprivate var voicePlayer:MPMoviePlayerController?
    fileprivate var voicePlayer1:AVPlayerViewController?
    init(imageNameArray:[String],second:Int) {
        let frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        super.init(frame: frame)
        imageArray = imageNameArray
        if imageArray == nil || imageArray?.count == 0 {
            return
        }
        self.addScrollView(frame: frame)
        self.addImages()
        self.addJumpButton(second: second)
        self.addPageControl()
        
    }
    
    init(videoUrl:URL) {
        let frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        super.init(frame: frame)
        print("videoUrl++\(videoUrl)")
       //这个我用的是只能播放一次
        addVideoControl1(videoUrl: videoUrl)
        addVideoControl(videoUrl: videoUrl)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension CZQLaunchView{
    //创建UIScrollView
   fileprivate func addScrollView(frame:CGRect) {
        scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        scrollView.backgroundColor = UIColor.red
        scrollView?.contentSize = CGSize.init(width: CGFloat((self.imageArray?.count)!) * kScreenWidth, height: kScreenHeight)
        scrollView?.bounces = false
        scrollView?.isPagingEnabled = true
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.delegate = self
        self.addSubview(scrollView!)
    }
    //创建“跳过”button
    fileprivate func addJumpButton(second:Int) {
    
        //默认是三秒
        jumpButton = CZQJumpButton(second: second)
        jumpButton?.delegate = self
        self.addSubview(jumpButton!)
    }
    
    //加载图片
    fileprivate func addImages() {
        guard let images = self.imageArray else {
            return
        }
        for i in 0 ..< images.count {
            let imageView = UIImageView.init(frame: CGRect.init(x: kScreenWidth * CGFloat(i), y: 0, width: kScreenWidth, height: kScreenHeight))
            /*获取图片类型
             如果是gif格式的那么就是可以是动态的，如果是png格式的就是静止
             */
            let typeStr = (images[i] as NSString).substring(from: images[i].count - 3)
            if typeStr == "gif"{
                //动态图片
                imageView.image = UIImage.gifImageWithName(images[i])
                self.scrollView.addSubview(imageView)
            }else{
                //静态图片
                imageView.image = UIImage.init(named: images[i])
                print("images++\(images[i])")
                self.scrollView?.addSubview(imageView)
            }
            
            //在最后一张图片上加上“马上体验”
            if i == images.count - 1{
                imageView.isUserInteractionEnabled = true
                let rightnowBtn = UIButton(type: .custom)
                rightnowBtn.frame = CGRect.init(x: kScreenWidth * 0.1, y: kScreenHeight * 0.8, width: kScreenWidth * 0.8, height: kScreenHeight * 0.08)
                rightnowBtn.setTitle("马上体验", for: .normal)
                rightnowBtn.setTitleColor(UIColor.white, for: .normal)
                rightnowBtn.setBackgroundImage(UIImage.init(named: "rightnow"), for: .normal)
                rightnowBtn.addTarget(self, action: #selector(jumpAndRightnowExperienceAction), for: .touchUpInside)
                imageView.addSubview(rightnowBtn)
            }
        }
    }
    
    //添加分页控制器
    fileprivate func addPageControl(){
        pageControl = UIPageControl.init(frame: CGRect.init(x: 0, y: kScreenHeight * 0.9, width: kScreenWidth, height: kScreenHeight * 0.1))
        pageControl?.currentPage = 0
        pageControl?.numberOfPages = self.imageArray?.count ?? 0
        pageControl?.pageIndicatorTintColor = UIColor.gray
        pageControl?.currentPageIndicatorTintColor = UIColor.white
        self.addSubview(pageControl!)
    }
    
    //加载视频
    fileprivate func addVideoControl(videoUrl:URL){
        voicePlayer = MPMoviePlayerController(contentURL: videoUrl)
        voicePlayer?.view.frame = frame
        voicePlayer?.controlStyle = .none
        voicePlayer?.repeatMode = .one
        voicePlayer?.shouldAutoplay = true
        voicePlayer?.view.alpha = 1
        voicePlayer?.play()
        self.addSubview((voicePlayer?.view)!)
        
        let rightnowBtn = UIButton(type: .custom)
        rightnowBtn.frame = CGRect.init(x: kScreenWidth * 0.1, y: kScreenHeight * 0.8, width: kScreenWidth * 0.8, height: kScreenHeight * 0.08)
        rightnowBtn.setTitle("马上体验", for: .normal)
        rightnowBtn.setTitleColor(UIColor.white, for: .normal)
        rightnowBtn.setBackgroundImage(UIImage.init(named: "rightnow"), for: .normal)
        rightnowBtn.addTarget(self, action: #selector(jumpAndRightnowExperienceAction), for: .touchUpInside)
        voicePlayer?.view.addSubview(rightnowBtn)
        UIView.animate(withDuration: 1) {
            rightnowBtn.alpha = 1
        }
    }
    
    fileprivate func addVideoControl1(videoUrl:URL){
        voicePlayer1 = AVPlayerViewController()
        let item = AVPlayerItem(url: videoUrl)
        let player = AVPlayer(playerItem: item)
        let layer = AVPlayerLayer(player: player)
        layer.frame = frame
        layer.videoGravity = .resize
        self.layer.addSublayer(layer)
        voicePlayer1?.player = player
        player.play()
    }
    
    
}

extension CZQLaunchView:UIScrollViewDelegate,ClickJumpDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl?.currentPage = Int(page)
    }
    
    //实现“跳过”方法
    func jumpToLaunchPage() {
        jumpAndRightnowExperienceAction()
    }
}

extension CZQLaunchView:AVPlayerViewControllerDelegate{
    
}

extension CZQLaunchView{
    //立刻跳过&立即体验
    @objc fileprivate func jumpAndRightnowExperienceAction(){
        UIView.animate(withDuration: 1, animations: {
            self.alpha = 0
        }) { (finish) in
            self.removeFromSuperview()
        }
    }
}
