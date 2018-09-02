//
//  WeiBoCrawlerVC.swift
//  NewsBang
//
//  Created by 徐炜楠 on 2018/2/24.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit
import WebKit
import Ji

class WeiBoCrawlerVC2: UIViewController {
    
    
    var profile = [String]()
    var items = [Item]()
    let headTitle = ["用户名","QQ","邮件"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for j in 1...106{
            let jiDoc = Ji(htmlURL: URL.init(string: "http://www.ui.cn/list.html?p=\(j)&tag=1&r=edit&subcatid=4&catid=0&timeid=0")!)
            for i in 1...40{
                let mainNode = jiDoc?.xPath("//body/div[4]/ul/li[\(i)]/div[3]/p/a")?.first
                if mainNode != nil{
                    print((mainNode?.attributes["href"])!)
                    profile.append((mainNode?.attributes["href"])!)
                }
            }
        }
        
        let reItem = getItemByProfile(url: "http://i.ui.cn/ucenter/93224.html")
        //reItem.toString()
        
        
    }
    @IBOutlet var getUsers: UIButton!
    @IBAction func getUsersAction(_ sender: UIButton) {
        for i in 0..<2500{
            let item = getItemByProfile(url: profile[i])
            print(i)
            //item.toString()
            items.append(item)
        }
    }
    @IBAction func genFile(_ sender: UIButton) {
        
        var excelStr = [String]()
        for item in items{
            excelStr.append("\(item.name)")
            excelStr.append("\(item.qq)")
            excelStr.append("\(item.mail)")
        }
        //生成文件
        let excelFile = Excel(line: headTitle.count, heads: headTitle)
        let path = excelFile.createExcel(lineDatas: excelStr)
        print("文档存储路径\(path)")
    }
    @IBAction func deleteRepeats(_ sender: UIButton) {
        print("去重前\(profile.count)")
        let set = Set(profile)
        profile = Array(set)
        print("去重后\(profile.count)")
    }
    func getItemByProfile(url:String) -> Item{
        let jiDoc = Ji(htmlURL: URL.init(string: url)!)
        let nameNode = jiDoc?.xPath("//body/div[3]/div/ul[2]/li[2]/span[1]")?.first
        let QQNode = jiDoc?.xPath("//*[@id=\"com-card-box\"]/div/ul/li[3]/ul/li[2]")?.first
        let mailNode = jiDoc?.xPath("//*[@id=\"com-card-box\"]/div/ul/li[3]/ul/li[3]")?.first
        let item = Item.init(name: ((nameNode?.content)!.split(separator: "\n").first?.description)!.replacingOccurrences(of: "\t", with: ""), qq: (QQNode?.content)!, mail: (mailNode?.content)!)
        return item
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    struct Item {
        var name = ""
        var qq = ""
        var mail = ""
        init(name:String,qq:String,mail:String){
            self.name = name
            self.qq = qq
            self.mail = mail
        }
        func toString(){
            print("name:\(name)\nqq:\(qq)\nmail:\(mail)")
        }
    }
}
