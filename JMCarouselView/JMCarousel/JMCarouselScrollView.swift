//
//  JMCarouselScrollView.swift
//  JMCarouselView
//
//  Created by JimmyPeng on 15/12/17.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

import UIKit


//广告数目


class JMCarouselScrollView: UIView,UIScrollViewDelegate
{
    //MARK: - 属性
    //是否URL加载
    var isFromURL:Bool  = true
    //页码
    var index:Int       = 0
    //图片数量
    var imgViewNum:Int  = 0
    //宽度
    var sWidth:CGFloat  = 0
    //高度
    var sHeight:CGFloat = 0

    //定时器
    var timer:NSTimer?
    //图片数组
    var imgArray: [UIImage]?
    //图片url数组
    var imgURLArray:[String]?
    
    
    //MARK: - 初始化方法
    /**
    初始化方法1,传入图片URL数组,以及pageControl的当前page点的颜色,特别注意需要SDWebImage框架支持
    
    - parameter frame:          frame
    - parameter imgURLArray:  图片URL数组
    - parameter pagePointColor: pageControl的当前page点的颜色
    
    - returns: ScrollView图片轮播器
    */
    init(frame: CGRect, imageURLArray:[String], pagePointColor: UIColor)
    {
        super.init(frame: frame)
        
        imgURLArray = imageURLArray
        
        prepareUI(imageURLArray.count, pagePointColor: pagePointColor)
        
    }
    
    /**
     初始化方法2,传入图片数组,以及pageControl的当前page点的颜色,无需依赖第三方库
     
     - parameter frame:          frame
     - parameter imgArray:     图片数组
     - parameter pagePointColor: pageControl的当前page点的颜色
     
     - returns: ScrollView图片轮播器
     */
    init(frame: CGRect, imageArray:[UIImage], pagePointColor: UIColor)
    {
        super.init(frame: frame)
        
        imgArray = imageArray
        
        isFromURL = false
        
        prepareUI(imageArray.count, pagePointColor: pagePointColor)
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 准备UI
    func prepareUI(numberOfImage:Int, pagePointColor: UIColor)
    {
        //设置图片数量
        imgViewNum = numberOfImage;
        //添加scrollView
        addSubview(ScrollView)
        //添加pageControl
        addSubview(pageControl)
        //pageControl数量
        pageControl.numberOfPages = imgViewNum;
        //pageControl颜色
        pageControl.currentPageIndicatorTintColor = pagePointColor
        //view宽度
        sWidth = self.frame.size.width
        //view高度
        sHeight = self.frame.size.height
        
        //设置代理
        ScrollView.delegate = self;
        //一页页滚动
        ScrollView.pagingEnabled = true;
        //隐藏滚动条
        ScrollView.showsHorizontalScrollIndicator = false;
        //设置一开始偏移量
        ScrollView.contentOffset = CGPointMake(sWidth , 0);
        
        //设置timer
        setTheTimer()
        //设置图片
        prepareImage()
    }
    
    //布局子控件
    override func layoutSubviews()
    {
        super.layoutSubviews()
        //布局ScrollView
        ScrollView.frame = self.bounds
        
        //布局pageControl
        let pW = ScrollView.frame.width
        let pH = CGFloat(15)
        let pX = CGFloat(0)
        let pY = ScrollView.frame.height -  CGFloat(pH * 2)
        
        pageControl.frame = CGRect(x: pX, y: pY, width: pW, height: pH)
    }
    
    //MARK: - 创建广告图片
    /**
    *  创建广告图片
    */
    func prepareImage()
    {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            //设置一开始偏移量
            self.ScrollView.contentOffset = CGPointMake(self.sWidth, 0);
            //设置滚动范围
            
            self.ScrollView.contentSize = CGSizeMake(CGFloat(self.imgViewNum + 2) * self.sWidth, 0)
            
        })
        
        
        for i in 0 ..< imgViewNum + 2
        {
            var imgX = CGFloat(i) * sWidth;
            let imgY:CGFloat = 0;
            let imgW = sWidth;
            let imgH = sHeight;
            let imgView = UIImageView()
            
            if i == 0
            {
                //第0张 显示广告最后一张
                imgX = 0;
                
                if !isFromURL
                {
                    imgView.image = imgArray?.last
                }
                else
                {
                    imgView.sd_setImageWithURL(NSURL(string: (imgURLArray?.last)!), placeholderImage: UIImage(named: "holder"))
                }
            }
            else if i == imgViewNum + 1
            {
                //第n+1张,显示广告第一张
                imgX = CGFloat(imgViewNum + 1) * sWidth;
                
                if !isFromURL
                {
                    imgView.image = imgArray?.first
                }
                else
                {
                    imgView.sd_setImageWithURL(NSURL(string: (imgURLArray?.first)!), placeholderImage: UIImage(named: "holder"))
                }
            }
            else
            {
                //正常显示广告
                if !isFromURL
                {
                    imgView.image = imgArray?[i - 1]
                }
                else
                {
                    imgView.sd_setImageWithURL(NSURL(string: (imgURLArray?[i - 1])!), placeholderImage: UIImage(named: "holder"))
                }
            }
            
            imgView.frame = CGRect(x: imgX, y: imgY, width: imgW, height: imgH)
            
            //添加子控件
            ScrollView.addSubview(imgView)
        }
        
    }
    
    /**
     *  执行下一页的方法
     */
    func next()
    {
        index++;
        
        ScrollView.setContentOffset(CGPoint(x: CGFloat(index) * sWidth, y: 0), animated: true)
    }
    
    
    //MARK: - pragma mark- 代理
    
    /**
    * 动画减速时的判断
    *
    */
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView)
    {
        carousel()
    }
    
    
    /**
     *  拖拽减速时的判断
     *
     */
    func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        carousel()
    }
    
    func carousel()
    {
        
        //获取偏移值
        let offset = ScrollView.contentOffset.x;
        //当前页
        let page = Int((offset + sWidth/2) / sWidth);
        //如果是N+1页
        if page == imgViewNum + 1
        {
            //瞬间跳转第1页
            ScrollView.setContentOffset(CGPoint(x: sWidth, y: 0), animated: false)
        }
            //如果是第0页
        else if page == 0
        {
            //瞬间跳转最后一页
            ScrollView.setContentOffset(CGPoint(x: CGFloat(imgViewNum) * sWidth, y: 0), animated: false)
            
        }
    }
    
    /**
     *  滚动时判断页码
     */
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        
        //获取偏移值
        let offset = ScrollView.contentOffset.x - sWidth;
        //页码
        index = Int((offset + sWidth / 2.0) / sWidth);
        
        pageControl.currentPage = index
        
    }
    
    /**
     *  拖拽广告时停止timer
     */
    func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
        
        timer?.invalidate()
        
        timer = nil
    }
    
    /**
     *  结束拖拽时重新创建timer
     */
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        setTheTimer()
    }
    
    //MARK:设置timer
    func setTheTimer()
    {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "next", userInfo: nil, repeats: true)
        
        let runloop = NSRunLoop.currentRunLoop()
        
        runloop.addTimer(timer!, forMode: NSRunLoopCommonModes)
        
    }
    
    
    
    //MARL: - 懒加载
    //广告滚动view
    private lazy var ScrollView: UIScrollView = UIScrollView()
    
    private lazy var pageControl: UIPageControl =  UIPageControl()
    
    
}
