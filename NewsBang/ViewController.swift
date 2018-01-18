//
//  ViewController.swift
//  NewsBang
//
//  Created by 徐炜楠 on 2018/1/8.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit
import Ji

class ViewController: UIViewController {
    
    var articleItems = [ArticleItems]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let pageUrl = "http://sjic.hust.edu.cn/"
        let jiDoc = Ji(htmlURL: URL(string: "http://sjic.hust.edu.cn/xwzx.htm")!)
        var titleNode = jiDoc?.xPath("//*[@id=\"line_u8_0\"]/a")?.first
        var dateNode = jiDoc?.xPath("//*[@id=\"line_u8_0\"]/span")?.first
        var i = 0
        while true {
            titleNode = jiDoc?.xPath("//*[@id=\"line_u8_\(i)\"]/a")?.first
            dateNode = jiDoc?.xPath("//*[@id=\"line_u8_\(i)\"]/span")?.first
            i += 1
            if titleNode==nil{
                break
            }else{
                articleItems.append(ArticleItems.init(name: (titleNode?.content)!, date: (dateNode?.content)!, url: "http://sjic.hust.edu.cn/\((titleNode?.attributes["href"])!)"))
            }
        }
        for articleItem in articleItems{
            articleItem.toString()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
struct ArticleItems {
    var name:String
    var date:String
    var url:String
    init(name:String,date:String,url:String) {
        self.name = name
        self.date = date
        self.url = url
    }
    func toString(){
        print("name:\(name) date:\(date) url:\(url)")
    }
}

