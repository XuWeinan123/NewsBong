//
//  MyCollectionVC.swift
//  NewsBang
//
//  Created by 徐炜楠 on 2018/1/12.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit
import AVOSCloud

class MyCollectionVC: UITableViewController {
    var articleItems = [ArticleItems]()
    var footViewHeight:CGFloat?
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
        let query = AVQuery(className: "Collection")
        query.whereKey("username", equalTo: AVUser.current()?.username)
        query.findObjectsInBackground { (objects:[Any]?, error:Error?) in
            if error == nil{
                for object in objects!{
                    let tempObject = object as AnyObject
                    print("object:\(tempObject["web_url"])")
                    print("object:\(tempObject["name"])")
                    print("object:\(tempObject["date"])")
                    let name:String = tempObject["name"] as! String
                    let date:String = tempObject["date"] as! String
                    let url:String = tempObject["web_url"] as! String
                    self.articleItems.append(ArticleItems(name: name, date: date, url: url))
                }
                self.tableView.reloadData()
            }
            self.articleItems.reverse()
        }
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
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("点击了\(indexPath.row),结果\n\(articleItems[indexPath.row].url)")
        let articlePage = self.storyboard?.instantiateViewController(withIdentifier: "ArticlePage") as! ArticlePageVC
        articlePage.url = articleItems[indexPath.row].url
        //print("str:\(articleItems[indexPath.row].date)")
        articlePage.date = articleItems[indexPath.row].date
        articlePage.from = "我的收藏"
        self.navigationController!.pushViewController(articlePage, animated: true)
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
}
