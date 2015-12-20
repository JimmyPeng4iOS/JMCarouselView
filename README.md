# JMCarouselView
#####JMCarouselView 是本人 Jimmy 使用Swift语言封装的图片轮播器。 基于UIScrollView/UICollectionView 用两种思路做了整合, 可实现无间隙循环播放，可方便的整合入app , 支持本地图片和网络图片(依赖SDWebImage 第三方库), 简单易用。 
---
#####Github地址:

<https://github.com/JimmyPeng4iOS/JMCarouselView>

---
#####无间隙循环展示

![JMCarouselView.gif](http://upload-images.jianshu.io/upload_images/1115674-4189b9ef0de2754e.gif?imageMogr2/auto-orient/strip)

#使用方法:

* 主要有两种思路 

##ScrollView

* 初始化方法1 -- 网络加载

```
     /**
    初始化方法1,传入图片URL数组,以及pageControl的当前page点的颜色,特别注意需要SDWebImage框架支持
        
    - parameter frame:          frame
    - parameter imgURLArray:    图片URL数组
    - parameter pagePointColor: pageControl的当前page点的颜色
    - parameter stepTime:       广告每一页停留时间
        
    - returns: ScrollView图片轮播器
    */

    tableView.tableHeaderView = JMCarouselScrollView(frame: CGRect(x: 0, y: 0, width:UIScreen.mainScreen().bounds.width, height: 220), imageURLArray: urlStringArr(), pagePointColor: UIColor.whiteColor(), stepTime: 2.0)
```

* 初始化方法2 -- 本地加载

```
        /**
        初始化方法2,传入图片数组,以及pageControl的当前page点的颜色,无需依赖第三方库
        
        - parameter frame:          frame
        - parameter imgArray:       图片数组
        - parameter pagePointColor: pageControl的当前page点的颜色
        - parameter stepTime:       广告每一页停留时间
        
        - returns: ScrollView图片轮播器
        */
        
          tableView.tableHeaderView = JMCarouselScrollView(frame: CGRect(x: 0, y: 0, width:UIScreen.mainScreen().bounds.width, height: 220), imageArray: imgArr(), pagePointColor: UIColor.whiteColor(), stepTime: 1.0)
```
ScrollView是采用前后添加一张图片,然后到达多出来的两张图片瞬间跳转(肉眼观察不到)的方式来实现无限轮播


##CollectionView

* 初始化方法1 -- 网络加载

```
     /**
    初始化方法1,传入图片URL数组,以及pageControl的当前page点的颜色,特别注意需要SDWebImage框架支持
        
    - parameter frame:          frame
    - parameter imgURLArray:    图片URL数组
    - parameter pagePointColor: pageControl的当前page点的颜色
    - parameter stepTime:       广告每一页停留时间
        
    - returns: ScrollView图片轮播器
    */

    tableView.tableHeaderView = JMCarouselCollection(frame: CGRect(x: 0, y: 0, width:UIScreen.mainScreen().bounds.width, height: 220), imageURLArray: urlStringArr(), pagePointColor: UIColor.whiteColor(), stepTime: 2.0)
```

* 初始化方法2 -- 本地加载

```
        /**
        初始化方法2,传入图片数组,以及pageControl的当前page点的颜色,无需依赖第三方库
        
        - parameter frame:          frame
        - parameter imgArray:       图片数组
        - parameter pagePointColor: pageControl的当前page点的颜色
        - parameter stepTime:       广告每一页停留时间
        
        - returns: ScrollView图片轮播器
        */
        
          tableView.tableHeaderView = JMCarouselCollection(frame: CGRect(x: 0, y: 0, width:UIScreen.mainScreen().bounds.width, height: 220), imageArray: imgArr(), pagePointColor: UIColor.whiteColor(), stepTime: 1.0)
```

CollectionView是添加大量的组,每一组的items就是需要展示的图片,来实现伪无限轮播,由于SDWebImage自带缓存功能, 使用本地的方式也会去下载,该方法不会浪费用户流量



 
#注意事项: 
1. 需要使用第一种初始化方式传入URL的时候, 需要依赖第三方库  SDWebImage!! ⊙▽⊙
2. 通过替换`Assets.xcassets`资源夹内的`holder.jpg`可更改placeholderImage(建议使用同名,要更换名字可到源文件下更改)
3. 需要定义一个属性强引用轮播器,以便于释放内存

eg.


```
    var headerView: JMCarouselCollection?

    headerView =JMCarouselCollection(xxxxxxxx) 

    tableView.tableHeaderView = headerView
```

```
    //MARK:释放
    override func viewWillDisappear(animated: Bool)
    {
        headerView?.stopTimer()
    }
```

---
#####最后 再来一遍github地址 (๑•̀ㅂ•́)و✧

<https://github.com/JimmyPeng4iOS/JMCarouselView>

---