//
//  LibraryNextVC.swift
//  NewsBang
//
//  Created by 徐炜楠 on 2018/2/18.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit
import Ji

class LibraryNextVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var tableView:UITableView!
    var url = ""
    var items = [Item]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置表格视图
        tableView.delegate = self
        tableView.dataSource = self
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        url = self.replaceUrlUni(urlStr: url)
        
        DispatchQueue.global().async {
            //分析url
            let jiDoc = Ji(htmlURL: URL.init(string: self.url)!)
            let mainCode = jiDoc?.xPath("//*[@id=\"infoTable\"]/div[2]/div/table")?.first
            if mainCode != nil{
                for i in 1..<(mainCode?.children.count)!{
                    //print("项目:\(mainCode?.children[i].content)")
                    let itemCode = mainCode?.children[i].children
                    var callNumber = itemCode?[1].content?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
                    var location = itemCode?[0].content?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
                    var code = itemCode?[2].content?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
                    var status = itemCode?[3].content?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
                    callNumber?.removeFirst()
                    location?.removeFirst()
                    code?.removeFirst()
                    status?.removeFirst()
                    let item = Item(callNumber: callNumber!, location: location!, code: code!, status: status!)
                    self.items.append(item)
                    //item.toString()
                }
            }else{
                let tempCode = jiDoc?.xPath("//*[@id=\"infoTable\"]/table[2]/tr/td")?.first
                self.items.append(Item(callNumber: (tempCode?.content?.replacingOccurrences(of: "\n", with: ""))!, location: "", code: "", status: ""))
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        // Do any additional setup after loading the view.
    }
    ///将网址中的中文字符替换成安全字符
    func replaceUrlUni(urlStr:String) -> String{
        print("替换前:\(urlStr)")
        //0.判断是否有中文字符需要替换
        if !url.contains("{"){return urlStr}
        //1.获取需要替换的字符
        let low = self.url.range(of: "/X{")?.upperBound
        var up = self.url.range(of: "}&SORT=D")?.lowerBound
        up = String.Index.init(encodedOffset: (up?.encodedOffset)!-1)
        ///需要替换的字符串
        let replaceStr = self.url[low!...up!]

        //2.转变字符
        let strArray = replaceStr.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: "}{", with: "_").split(separator: "_")
        var transStrArray = [String]()
        for i in 0..<strArray.count{
            transStrArray.append(unicodeToChinese(unicode: "\(strArray[i])").addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        }
        
        //3.替换字符
        var urlStrToReturn = urlStr
        for j in 0..<strArray.count{
            urlStrToReturn = urlStrToReturn.replacingOccurrences(of: "{\(strArray[j])}", with: transStrArray[j])
        }
        print("替换后:\(urlStrToReturn)")
        return urlStrToReturn
    }
    ///将unicode转变成中文字,(u4E60->你)
    func unicodeToChinese(unicode:String) -> String{
        var unicode = unicode
        unicode.removeFirst()
        let word = (Int(unicode, radix: 16).map{ UnicodeScalar($0)})!
        return "\(word!)"
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! LibraryNextCell
        cell.callNumber.text = items[indexPath.row].callNumber
        cell.location.text = items[indexPath.row].location
        cell.code.text = items[indexPath.row].code
        cell.status.text = items[indexPath.row].status
        if cell.status.text == "在架上" {
            cell.status.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }else if (cell.status.text?.contains("馆内阅览"))!{
            cell.status.textColor = UIColor.orange
        }
        
        if cell.code.text == ""{
            cell.codeImage.isHidden = true
            cell.spline.isHidden = true
            if (cell.callNumber.text?.contains("连接到"))!{
                cell.callNumber.text = "暂无馆藏信息"
            }
        }
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    struct Item {
        var callNumber = ""
        var location = ""
        var code = ""
        var status = ""
        init(callNumber:String,location:String,code:String,status:String) {
            self.callNumber = callNumber
            self.location = location
            self.code = code
            self.status = status
        }
        func toString(){
            print("项目打印:\n索书号:\(callNumber)\n位置:\(location)\n条码:\(code)\n状态:\(status)")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
