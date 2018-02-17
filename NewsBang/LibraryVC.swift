//
//  LibraryVC.swift
//  NewsBang
//
//  Created by 徐炜楠 on 2018/2/16.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit
import Ji

class LibraryVC: UIViewController {
    
    var searchText = "从你的全世界路过"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchText = searchText.replacingOccurrences(of: " ", with: "+")
        let str = "http://ftp.lib.hust.edu.cn/search*chx/X?SEARCH=\(searchText)"
        let encodedStr = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        print("测试:\(encodedStr!)")
        let searchResult = seachByUrl(url: encodedStr!)
        //print("打印图书:\(jiNode)")

        // Do any additional setup after loading the view.
    }
    func seachByUrl(url:String) -> SearchResult{
        
        let jiDoc = Ji(htmlURL: URL(string: url)!)
        var jiNode = jiDoc?.xPath("//body/table")?.first?.children[9].firstChild?.firstChild?.children
        if jiNode == nil {
            jiNode = jiDoc?.xPath("//body/table")?.first?.children[7].firstChild?.firstChild?.children
        }
        print(jiNode)
        
        var resultCount = 0
        //遍历数组
        var doubleArrayOne = -1
        var doubleArray = [[BookInfo]]()
        var doubleArrayTitle = [String]()
        
        for i in 1..<(jiNode?.count)!{
            let nodeClassInfo = jiNode![i].attributes["class"]
            if nodeClassInfo == "browseHeader"{
                //获取结果的数量
                var resultCountStr = jiNode![i].firstChild?.content
                resultCountStr = "\((resultCountStr!.split(separator: "共")[1]))"
                resultCountStr = resultCountStr!.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ")\n", with: "")
                resultCount = Int(resultCountStr!)!
                print("查询结果数量:\(resultCount)")
            }else if nodeClassInfo == nil && jiNode![i].firstChild != nil{
                let contentNode = jiNode![i].firstChild?.firstChild?.firstChild
                if var contentNode = contentNode{
                    if contentNode.children.count >= 3{
                        contentNode = contentNode.children[3]
                        let nextUrl = "http://ftp.lib.hust.edu.cn\((contentNode.children[1].firstChild?.attributes["href"])!)"
                        print(nextUrl)
                        let title = contentNode.children[1].content?.replacingOccurrences(of: "\n", with: "")
                        let infos = contentNode.children[3].content?.split(separator: "\n")
                        //print("项目\(i)")
                        let author = "\(infos![0])"
                        let publish = "\(infos![1])"
                        let bio = "\(infos![2])".contains("Website") ? "暂无简介":"\(infos![2])"
                        
                        let book = BookInfo(title: title!, author: author, publish: publish, bio: bio, nextUrl: nextUrl)
                        doubleArray[doubleArrayOne].append(book)
                        //print(book.toString() + "\n")
                    }
                }
            }else if jiNode![i].firstChild != nil{
                let subhead = jiNode![i].content
                doubleArrayTitle.append(subhead!)
                doubleArray.append([BookInfo]())
                doubleArrayOne += 1
                //print("\n副标题:\(subhead!)\n----------")
            }
        }
        
        /*/打印数组看看
        print("\n一重数组大小:\(doubleArray.count)\nn")
        for i in 0..<doubleArray.count{
            print("\n副标题:\(doubleArrayTitle[i])\n----------------")
            for j in 0..<doubleArray[i].count{
                print("\(i)-\(j):\n\(doubleArray[i][j].toString())")
            }
        }*/
        
        let searchResult = SearchResult(bookInfoArray: doubleArray, subheadTitle: doubleArrayTitle)
        return searchResult
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
    struct BookInfo {
        var title = ""
        var author = ""
        var publish = ""
        var bio = ""
        var nextUrl = ""
        init(title:String,author:String,publish:String,bio:String,nextUrl:String) {
            self.title = title
            self.author = author
            self.publish = publish
            self.bio = bio
            self.nextUrl = nextUrl
        }
        func toString() -> String{
            return "书名:\(title)\n作者:\(author)\n出版:\(publish)\n简介:\(bio)\n网址:\(nextUrl)"
        }
    }
    struct SearchResult {
        var bookInfoArray = [[BookInfo]]()
        var subheadTitle = [String]()
        init(bookInfoArray:[[BookInfo]],subheadTitle:[String]) {
            self.bookInfoArray = bookInfoArray
            self.subheadTitle = subheadTitle
        }
    }
}
