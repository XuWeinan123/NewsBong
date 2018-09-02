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

class WeiBoCrawlerVC: UIViewController {

    let headTitle = ["名称","文件名","图片网址","详情页网址","创建时间","种类","下载地址"]
    var webToCrawler = [String]()
    @IBOutlet var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("执行")
        let url = URL.init(string: "https://m.weibo.com")!
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        // Do any additional setup after loading the view.
        
        //初始化需要爬取的网址
        webToCrawler.append("https://www.9906c.com/Html/60/index.html")
        webToCrawler.append("https://www.9906c.com/Html/110/index.html")
        webToCrawler.append("https://www.9906c.com/Html/62/index.html")
        webToCrawler.append("https://www.9906c.com/Html/86/index.html")
        webToCrawler.append("https://www.9906c.com/Html/101/index.html")
        webToCrawler.append("https://www.9906c.com/Html/89/index.html")
        webToCrawler.append("https://www.9906c.com/Html/87/index.html")
        webToCrawler.append("https://www.9906c.com/Html/93/index.html")
        webToCrawler.append("https://www.9906c.com/Html/90/index.html")
        webToCrawler.append("https://www.9906c.com/Html/91/index.html")
        webToCrawler.append("https://www.9906c.com/Html/88/index.html")
        webToCrawler.append("https://www.9906c.com/Html/92/index.html")
        webToCrawler.append("https://www.9906c.com/Html/109/index.html")
        webToCrawler.append("https://www.9906c.com/Html/100/index.html")
        webToCrawler.append("https://www.9906c.com/Html/94/index.html")
        webToCrawler.append("https://www.9906c.com/Html/95/index.html")
        webToCrawler.append("https://www.9906c.com/Html/96/index.html")
        webToCrawler.append("https://www.9906c.com/Html/128/index.html")
        webToCrawler.append("https://www.9906c.com/Html/98/index.html")
        webToCrawler.append("https://www.9906c.com/Html/127/index.html")
        webToCrawler.append("https://www.9906c.com/Html/123/index.html")
        //webToCrawler.append("https://www.9906c.com/Html/110/index.html")
        webToCrawler.append("https://www.9906c.com/Html/111/index.html")
        webToCrawler.append("https://www.9906c.com/Html/112/index.html")
        webToCrawler.append("https://www.9906c.com/Html/113/index.html")
        webToCrawler.append("https://www.9906c.com/Html/114/index.html")
        webToCrawler.append("https://www.9906c.com/Html/130/index.html")
        webToCrawler.append("https://www.9906c.com/Html/131/index.html")
        
        var excelStr = [String]()
        for i in 0..<webToCrawler.count{
            let items = oneTypeCrawler(webUrl: URL.init(string: webToCrawler[i])!)
            for item in items{
                //item.toString()
                excelStr.append(item.name)
                let downloadUrl = getDownloadUrl(item:item)
                //分析下载地址
                excelStr.append((downloadUrl.split(separator: "/").last?.description)!)
                excelStr.append(item.imageUrl)
                excelStr.append(item.detailUrl)
                excelStr.append(item.time)
                excelStr.append(item.type)
                //print(item)
                //通过item获得相应下载地址
                excelStr.append(downloadUrl)
            }
        }
        
        //生成文件
        let excelFile = Excel(line: headTitle.count, heads: headTitle)
        let path = excelFile.createExcel(lineDatas: excelStr)
        print("文档存储路径\(path)")
    }
    func getDownloadUrl(item:Item) -> String{
        let jiDoc = Ji(htmlURL: URL.init(string: item.detailUrl)!)
        let mainNode = jiDoc?.xPath("//*[@id=\"jishu\"]")?.first
        print("\((mainNode?.firstChild?.firstChild?.firstChild?.attributes["href"])!)")
        return "\((mainNode?.firstChild?.firstChild?.firstChild?.attributes["href"])!)"
    }
    func oneTypeCrawler(webUrl:URL) -> [Item]{
        let prefix = "\(webUrl.description.split(separator: "/")[0])//\(webUrl.description.split(separator: "/")[1])"
        let todayTime = "2018-04-02"
        //print("前缀\(prefix)")
        var items = [Item]()
        let jiDoc = Ji(htmlURL: webUrl)
        let mainNode = jiDoc?.xPath("//body/div[3]")?.first
        //获取总页数
        let totalPages = "\((mainNode?.firstChild?.children[2].firstChild?.content?.split(separator: "/").last)!)"
        //获取类别
        let type = jiDoc?.xPath("//body/div[2]")?.first?.firstChild?.firstChild?.children[1].content
        //print("type:\(type!)")
        let uList = mainNode?.firstChild?.children[0].children //每页列表
        //执行完第一页
        for i in uList!{
            let detailUrl = "https://www.9906c.com\((i.firstChild?.attributes["href"])!)"
            let name = i.firstChild?.children[3].content
            let time = i.firstChild?.children[2].content
            let imageUrl = i.firstChild?.children[0].attributes["src"]
            let item = Item(name: name!, imageUrl: imageUrl!, detailUrl: detailUrl, time: time!, type: type!)
            //如果不是今天的片子那么直接退出
            if time! != todayTime {
                return items
            }
            
            items.append(item)
        }
        //("\(type!)执行进度：1/\(totalPages)")
        
        guard Int(totalPages)! >= 2 else {
            return items
        }
        //接下去执行2到最后一页
        for j in 2...Int(totalPages)!{
            let tempUrl = webUrl.description.replacingOccurrences(of: "index.html", with: "index-\(j).html")
            //print(tempUrl.description)
            
            let jiDoc2 = Ji(htmlURL: URL(string:tempUrl)!)
            let mainNode2 = jiDoc2?.xPath("//body/div[3]")?.first
            
            let uList2 = mainNode2?.firstChild?.children[0].children //列表
            
            for i in uList2!{
                let detailUrl = "https://www.9906c.com\((i.firstChild?.attributes["href"])!)"
                let name = i.firstChild?.children[3].content
                let time = i.firstChild?.children[2].content
                let imageUrl = i.firstChild?.children[0].attributes["src"]
                let item = Item(name: name!, imageUrl: imageUrl!, detailUrl: detailUrl, time: time!, type:type!)
                
                if time! != todayTime {
                    return items
                }
                
                items.append(item)
            }
            //print("\(type!)执行进度：\(j)/\(totalPages)")
        }
        
        return items
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
        var imageUrl = ""
        var detailUrl:String = ""
        var time = ""
        var type = ""
        init(name:String,imageUrl:String,detailUrl:String,time:String,type:String){
            self.name = name
            self.imageUrl = imageUrl
            self.detailUrl = detailUrl
            self.time = time
            self.type = type
        }
        func toString(){
            print("name:\(name)\nimageUrl:\(imageUrl)\ndetailUrl:\(detailUrl)\ntime:\(time)\n")
        }
    }
}
