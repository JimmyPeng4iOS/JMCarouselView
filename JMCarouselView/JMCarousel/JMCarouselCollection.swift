//
//  JMCarouselCollection.swift
//  JMCarouselView
//
//  Created by JimmyPeng on 15/12/17.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

import UIKit

class JMCarouselCollection: UIView,UICollectionViewDelegate,UICollectionViewDataSource
{
    //MARK: - 属性

    private let maxImgNum       = 1000;
    //页码
    private var index:Int       = 0
    //图片数目
    private var imgViewNum:Int  = 0
    //是否URL加载
    private var isFromURL:Bool  = true
    //重用标识
    private let ReuseIdentifier = "ReuseIdentifier"
    //广告每一页停留时间
    private var pageStepTime:NSTimeInterval  = 0
    
    //定时器
    private var timer:NSTimer?
    //图片数组
    private var imgArray:[UIImage]?
    //图片url数组
    private var imgURLArray:[String]?
    
    
    //MARK: - 初始化方法
    /**
     初始化方法1,传入图片URL数组,以及pageControl的当前page点的颜色,特别注意需要SDWebImage框架支持
    
    - parameter frame:          frame
    - parameter imgURLArray:    图片URL数组
    - parameter pagePointColor: pageControl的当前page点的颜色
    - parameter stepTime:       广告每一页停留时间
    
    - returns: ScrollView图片轮播器
    */
    init(frame: CGRect, imageURLArray:[String], pagePointColor: UIColor, stepTime: NSTimeInterval)
    {
        super.init(frame: frame)
        //赋值属性
        imgURLArray = imageURLArray
        
        prepareUI(imageURLArray.count, pagePointColor: pagePointColor, stepTime: stepTime)
        
    }
    
    
    /**
     初始化方法2,传入图片数组,以及pageControl的当前page点的颜色,无需依赖第三方库
     
      -parameter frame:          frame
     - parameter imgArray:       图片数组
     - parameter pagePointColor: pageControl的当前page点的颜色
     - parameter stepTime:       广告每一页停留时间
     
     - returns: ScrollView图片轮播器
     */
    init(frame: CGRect, imageArray:[UIImage], pagePointColor: UIColor, stepTime: NSTimeInterval)
    {
        super.init(frame: frame)
        
        imgArray = imageArray
        
        isFromURL = false
        
        prepareUI(imageArray.count, pagePointColor: pagePointColor, stepTime: stepTime)
        
    }
    
    
    /**
     准备UI
     */
    private func prepareUI(numberOfImage:Int, pagePointColor: UIColor, stepTime: NSTimeInterval)
    {
        //设置图片数量
        imgViewNum = numberOfImage
        //停留时间
        pageStepTime = stepTime
        
        assert(imgViewNum != 0, "传入的图片为空")
        
        //添加collection
        addSubview(collection)
        
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        //注册cell
        collection.registerClass(JMJMCarouselCell.self, forCellWithReuseIdentifier: ReuseIdentifier)
        
        //添加pageControl
        addSubview(pageControl)
        
        //设置页码
        pageControl.numberOfPages = imgViewNum
        //设置颜色
        pageControl.currentPageIndicatorTintColor = pagePointColor
        
        //设置代理
        collection.delegate = self
        collection.dataSource = self
        
        //一页页滚动
        collection.pagingEnabled = true
        
        //隐藏滚动条
        collection.showsHorizontalScrollIndicator = false
        
        //设置timer
        
        setTheTimer()
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    //布局子控件
    override func layoutSubviews()
    {
        super.layoutSubviews()
        //布局collection
        collection.frame = self.frame
        
        layout.itemSize = self.frame.size
        
        //布局pageControl
        let pW = collection.frame.width
        let pH = CGFloat(15)
        let pX = CGFloat(0)
        let pY = collection.frame.height -  CGFloat(pH * 2)
        pageControl.frame = CGRect(x: pX, y: pY, width: pW, height: pH)
        
        collection.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: maxImgNum/2), atScrollPosition: UICollectionViewScrollPosition.None, animated: false)
     
    }
    
    deinit
    {
        print("collectionDeinit")
    }
    
    
    //MARK: - pragma mark- 代理 数据源
    
    //section
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return maxImgNum
    }
    
    //item
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return imgViewNum
    }
    
    //cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collection.dequeueReusableCellWithReuseIdentifier(ReuseIdentifier, forIndexPath: indexPath) as! JMJMCarouselCell
        
        let i = indexPath.item
        
        //正常显示广告
        if !isFromURL
        {   //从图片数组中取值
            cell.bkgImageView = UIImageView(image: imgArray?[i])
        }
        else
        {   //从url中取值
            cell.bkgImageView.sd_setImageWithURL(NSURL(string: (imgURLArray?[i])!), placeholderImage: UIImage(named: "holder"))
        }
        
        return cell
    }
    
    
    //结束滚动
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath)
    {
        let index = collection.indexPathsForVisibleItems().first
        
        pageControl.currentPage = (index?.item)!
    }
    
    /**
     *  拖拽广告时停止timer
     */
    func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
        stopTimer()
    }
    
    /**
     销毁timer
     */
    func stopTimer()
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
    
    
    //MARK: - 其他
    /**
    设置timer
    */
    private func setTheTimer()
    {
        timer = NSTimer.scheduledTimerWithTimeInterval(pageStepTime, target: self, selector: "nextImage", userInfo: nil, repeats: true)
        
        let runloop = NSRunLoop.currentRunLoop()
        
        runloop.addTimer(timer!, forMode: NSRunLoopCommonModes)
    }
    
    
    /**
     自动滚动到下一张图片的方法
     */
    @objc private func nextImage()
    {
        let indexPath = collection.indexPathsForVisibleItems().first!
        
        let item = indexPath.item
        let section = indexPath.section
        
        
        if item == imgViewNum - 1
        {   //最后一个item,跳到下一组
            collection.selectItemAtIndexPath(NSIndexPath(forItem: 0 , inSection: section + 1), animated: true, scrollPosition: UICollectionViewScrollPosition.Right)
        }
        else
        {   //下一个item
            collection.selectItemAtIndexPath(NSIndexPath(forItem: item + 1, inSection: section), animated: true, scrollPosition: UICollectionViewScrollPosition.Right)
        }
    }
    
    
    //MARK: - 懒加载
    //布局
    private lazy var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    //广告滚动view
    private lazy var collection: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
    //pageControl
    private lazy var pageControl: UIPageControl =  UIPageControl()
    
    
}

//MARK: - JMJMCarouselCell
private class JMJMCarouselCell: UICollectionViewCell
{
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        prepareUI()
    }
    
    /**
     cell准备UI
     */
    private func prepareUI()
    {
        // 添加子控件
        contentView.addSubview(bkgImageView)
        
        // 添加约束
        bkgImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // 填充父控件
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[biv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["biv" : bkgImageView]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[biv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["biv" : bkgImageView]))
        
    }
    
    // MARK: - 懒加载
    /// 图片
    private lazy var bkgImageView: UIImageView = UIImageView()
    
}

