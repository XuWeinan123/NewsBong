//
//  EducationalInfoVC.swift
//  NewsBang
//
//  Created by 徐炜楠 on 2018/1/8.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit
import Ji

class EducationalInfoVC: UITableViewController {
    var articleItems = [ArticleItems]()
    var pageUrl = "http://sjic.hust.edu.cn/xwzx/jwxx.htm"
    var footViewHeight:CGFloat?
    var pageCount = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        initParameters()
        initFootView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func initParameters(){
        let jiDoc = Ji(htmlURL: URL(string: pageUrl)!)
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
                var str = (titleNode?.attributes["href"])!
                str.removeFirst();str.removeFirst();str.removeFirst();
                articleItems.append(ArticleItems.init(name: (titleNode?.content)!, date: (dateNode?.content)!, url: "http://sjic.hust.edu.cn/\(str)"))
            }
        }
        
        let pageDoc = Ji(htmlURL: URL(string: pageUrl)!)
        let pageNode = pageDoc?.xPath("//*[@id=\"fanyeu8\"]")?.first
        var pageCountStr = pageNode?.content
        pageCountStr?.removeLast()
        let slicing = pageCountStr?.split(separator: "/")[1]
        pageCountStr = "\(slicing!)"
        self.pageCount = Int(pageCountStr!)!
        print("pageCountStr:\(self.pageCount)")
    }
    func initFootView(){
        let footView = UIView()
        footView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: footViewHeight!)
        footView.backgroundColor = UIColor.white
        let view = UITextView()
        view.text = "没有内容"
        view.font = UIFont.systemFont(ofSize: 8)
        view.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        view.sizeToFit()
        view.frame.origin.x = footView.frame.width/2-view.frame.width/2
        view.frame.origin.y = 2
        
        footView.addSubview(view)
        self.tableView.tableFooterView = footView
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articleItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CollegeNewsCell
        cell.name.text = articleItems[indexPath.row].name
        cell.date.text = articleItems[indexPath.row].date
        if indexPath.row%2==1{
            cell.bg.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else{
            cell.bg.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        }
        // Configure the cell...
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击了\(indexPath.row),结果\n\(articleItems[indexPath.row].url)")
        //判断是不是站内网址
        if !articleItems[indexPath.row].url.contains("info"){
            let outUrl = articleItems[indexPath.row].url.substring(from: String.Index(encodedOffset: 24))
            print("outUrl:\(outUrl)")
            UIApplication.shared.open(URL(string: "htt\(outUrl)")!, options: [:], completionHandler: nil)
            return
        }
        let articlePage = self.storyboard?.instantiateViewController(withIdentifier: "ArticlePage") as! ArticlePageVC
        articlePage.url = articleItems[indexPath.row].url
        articlePage.date = articleItems[indexPath.row].date
        articlePage.hidesBottomBarWhenPushed = true
        articlePage.from = "教务信息"
        self.navigationController!.pushViewController(articlePage, animated: true)
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y>scrollView.contentSize.height-self.view.frame.height+1{
            print("加载新数据")
            if pageCount > 1{
                let tempUrl = pageUrl.replacingOccurrences(of: ".htm", with: "/\(pageCount-1).htm")
                print(tempUrl)
                let jiDoc = Ji(htmlURL: URL(string:tempUrl)!)
                var titleNode = jiDoc?.xPath("//*[@id=\"line_u8_0\"]/a")?.first
                var dateNode = jiDoc?.xPath("//*[@id=\"line_u8_0\"]/span")?.first
                var i = 0
                while true {
                    titleNode = jiDoc?.xPath("//*[@id=\"line_u8_\(i)\"]/a")?.first
                    dateNode = jiDoc?.xPath("//*[@id=\"line_u8_\(i)\"]/span")?.first
                    i += 1
                    if titleNode == nil{
                        pageCount -= 1
                        self.tableView.reloadData()
                        break
                    }else{
                        //新网页会重复一篇，所以……
                        if i<=1 || i>21 {continue}
                        var str = (titleNode?.attributes["href"])!
                        //print("之前:\(str)")
                        str.removeFirst();str.removeFirst();str.removeFirst();
                        str = str.replacingOccurrences(of: "../", with: "")
                        //print("之后:\(str)")
                        articleItems.append(ArticleItems.init(name: (titleNode?.content)!, date: (dateNode?.content)!, url: "http://sjic.hust.edu.cn/\(str)"))
                    }
                }
            }
        }
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
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
}
