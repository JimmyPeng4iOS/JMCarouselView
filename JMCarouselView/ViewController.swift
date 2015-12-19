//
//  ViewController.swift
//  JMCarouselView
//
//  Created by JimmyPeng on 15/12/17.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    @IBAction func goToScrollView()
    {
        navigationController?.pushViewController(ScrollTestViewController(), animated: true)
    }

    
    @IBAction func goToCollectionView()
    {
        navigationController?.pushViewController(CollectionTestViewController(), animated: true)
    }



}

