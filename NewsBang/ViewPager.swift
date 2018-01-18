//
//  ViewController.swift
//  ISViewPager
//
//  Created by invictus on 2016/11/17.
//  Copyright © 2016年 invictus. All rights reserved.
//

import Foundation
import UIKit

class ViewPager:UIViewController{
    init(title:String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel.init(frame: CGRect(x: self.view.frame.width/2-50, y: self.view.frame.height/2-100, width: 100, height: 50))
        label.text = title
        label.textAlignment = NSTextAlignment.center
        self.view.addSubview(label)
    }
}
