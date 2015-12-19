//
//  CollectionTestViewController.swift
//  JMCarouselView
//
//  Created by JimmyPeng on 15/12/17.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

import UIKit

class CollectionTestViewController: UITableViewController
{
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        /**
        初始化方法1,传入图片URL数组,以及pageControl的当前page点的颜色,特别注意需要SDWebImage框架支持
        
        - parameter frame:          frame
        - parameter imgURLArray:  图片URL数组
        - parameter pagePointColor: pageControl的当前page点的颜色
        
        - returns: ScrollView图片轮播器
        */
        tableView.tableHeaderView = JMCarouselCollection(frame: CGRect(x: 0, y: 0, width:UIScreen.mainScreen().bounds.width, height: 220), imageURLArray: urlStringArr(), pagePointColor: UIColor.whiteColor())
        
        
        /**
        初始化方法2,传入图片数组,以及pageControl的当前page点的颜色,无需依赖第三方库
        
        - parameter frame:          frame
        - parameter imgArray:     图片数组
        - parameter pagePointColor: pageControl的当前page点的颜色
        
        - returns: ScrollView图片轮播器
        */
        
        /*
        tableView.tableHeaderView = JMCarouselScrollView(frame: CGRect(x: 0, y: 0, width:UIScreen.mainScreen().bounds.width, height: 220), imageArray: imgArr(), pagePointColor: UIColor.whiteColor())
        */
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    //获得图片数组
    func imgArr() ->[UIImage]
    {
        var arr = [UIImage]()
        
        for i in 0 ..< 5
        {
            let img = UIImage(named:"img_0\(i + 1)")
            
            arr.append(img!)
        }
        return arr
    }
    
    //获得图片URL数组
    func urlStringArr() ->[String]
    {
        var arr = [String]()
        
        for i in 0 ..< 5
        {
            let urlStr = "http://7xpbws.com1.z0.glb.clouddn.com/JMCarouselViewIMGimg_0\(i+1).png"
            
            arr.append(urlStr)
        }
        return arr
    }
    
    
    //MARK: - 数据源
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 30
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = "CollectionTestViewController \(indexPath.row)"
        
        return cell
    }
    
}

