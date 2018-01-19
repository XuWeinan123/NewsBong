//
//  ArticlePageVC.swift
//  NewsBang
//
//  Created by 徐炜楠 on 2018/1/9.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit
import Ji
import AVOSCloud
import JDStatusBarNotification

class ArticlePageVC: UIViewController,UIWebViewDelegate {
    var url = "www.baidu.com"
    var name = ""
    var date = ""
    var webString = "加载有误，请在原网页打开"
    var from = ""
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var webViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var collectionBtnLeft: NSLayoutConstraint!
    @IBOutlet weak var shareBtnRight: NSLayoutConstraint!
    @IBOutlet weak var collectionBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    var picWidth = UIScreen.main.bounds.width-10*2-32
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = from
        print("url:\(url)")
        initParameters()
        nameLb.text = name
        nameLb.sizeToFit()
        dateLb.text = date
        // Do any additional setup after loading the view.
        webView.delegate = self
        webView.loadHTMLString(webString, baseURL: nil)
        webView.scrollView.isScrollEnabled = false
        webView.sizeToFit()
        //配置底部三个按钮
        webViewHeight.constant = UIScreen.main.bounds.height - (UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)! + 54 + 128 + nameLb.frame.height)
        collectionBtnLeft.constant = UIScreen.main.bounds.width/4 - collectionBtn.frame.width/2
        shareBtnRight.constant = collectionBtnLeft.constant
        //判断收藏按钮是否激活
        let collectionQuery = AVQuery(className: "Collection")
        collectionQuery.whereKey("username", equalTo: AVUser.current()?.username)
        collectionQuery.whereKey("web_url", equalTo: url)
        collectionQuery.countObjectsInBackground { (count:Int, error:Error?) in
            if error == nil{
                self.collectionBtn.isSelected = count != 0
            }
        }
    }
    func initParameters(){
        let jiDoc = Ji(htmlURL: URL(string: url)!)
        let titleNode = jiDoc?.xPath("//body/div[1]/div[4]/div[1]/div/div[2]/form/h2")?.first
        name = (titleNode?.content)!
        let webStringNode = jiDoc?.xPath("//body/div[1]/div[4]/div[1]/div/div[2]/form/div")?.first
        if let webStringNode = webStringNode{
            webString = String(describing: webStringNode)
            webString = webString.replacingOccurrences(of: "src=\"/__local", with: "src=\"http://sjic.hust.edu.cn/__local")
            webString = adjustHtmlImages(webString)
            webString = adjustHtmlExcel(webString)
        }else{
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        }
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let height = webView.stringByEvaluatingJavaScript(from: "document.body.scrollHeight")
        webViewHeight.constant = CGFloat(Int(height!)!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**把网址中的图片大小改一下*/
    func adjustHtmlImages(_ url:String) -> String{
        var adjustUrl = url
        var vwidthPositions = [Range<String.Index>]()
        var vheightPositions = [Range<String.Index>]()
        var vwidthValues = [Int]()
        var vheightValues = [Int]()
        var vwidthValueReplaces = [Int]()
        var vheightValueReplaces = [Int]()
        //第一步，获取所有的vwidth、vheight位置
        while true {
            let tempIndex = adjustUrl.range(of: "vwidth=\"")
            if tempIndex == nil{break}
            vwidthPositions.append(tempIndex!)
            adjustUrl = adjustUrl.substring(from: (tempIndex?.upperBound)!)
        }
        adjustUrl = url
        while true {
            let tempIndex = adjustUrl.range(of: "vheight=\"")
            if tempIndex == nil{break}
            vheightPositions.append(tempIndex!)
            adjustUrl = adjustUrl.substring(from: (tempIndex?.upperBound)!)
        }
        /*/如果图片不包含vwidth与vheight元素的话，那么使用width与height
        if vwidthPositions.count == 0{
            adjustUrl = url
            while true {
                let tempIndex = adjustUrl.range(of: "width=\"")
                if tempIndex == nil{break}
                vwidthPositions.append(tempIndex!)
                adjustUrl = adjustUrl.substring(from: (tempIndex?.upperBound)!)
            }
        }
        if vheightPositions.count == 0{
            adjustUrl = url
            while true {
                let tempIndex = adjustUrl.range(of: "height=\"")
                if tempIndex == nil{break}
                vheightPositions.append(tempIndex!)
                adjustUrl = adjustUrl.substring(from: (tempIndex?.upperBound)!)
            }
        }*/
        /*
        print("一共\(vwidthPositions.count)组\(vheightPositions.count)")
        for vwidthPosition in vwidthPositions{
            print("打印:\(vwidthPosition.lowerBound.encodedOffset)")
        }*/
        //第二步，获取所有的数据信息
        adjustUrl = url
        for vwidthPosition in vwidthPositions{
            adjustUrl = adjustUrl.substring(from: vwidthPosition.upperBound)
            let tempStr = adjustUrl
            adjustUrl = adjustUrl.substring(to: (adjustUrl.range(of: "\"")?.lowerBound)!)
            //获取到数据之后的操作
            if let unwrapInt = Int(adjustUrl){
                vwidthValues.append(unwrapInt)
            }else{
                vwidthValues.append(2)
            }
            //print("出现了！\(adjustUrl)")
            
            adjustUrl = tempStr
        }
        adjustUrl = url
        for vheightPosition in vheightPositions{
            adjustUrl = adjustUrl.substring(from: vheightPosition.upperBound)
            //print("1、\(adjustUrl)")
            let tempStr = adjustUrl
            adjustUrl = adjustUrl.substring(to: (adjustUrl.range(of: "\"")?.lowerBound)!)
            //获取到数据之后的操作
            if let unwrapInt = Int(adjustUrl){
                vheightValues.append(unwrapInt)
            }else{
                vheightValues.append(2)
            }
            
            //print("出现了2！\(adjustUrl)")

            adjustUrl = tempStr
        }
        //第三步，计算用来替换的数据
        for i in 0..<vwidthValues.count{
            print("元数据：\(vwidthValues[i])、\(vheightValues[i])")
            vheightValueReplaces.append(Int(CGFloat(vheightValues[i])/CGFloat(vwidthValues[i])*picWidth))
            vwidthValueReplaces.append(Int(picWidth))
            print("处理后：\(vwidthValueReplaces[i])、\(vheightValueReplaces[i])")
        }
        //第四步，替换
        adjustUrl = url
        for i in 0..<vwidthValues.count{
            adjustUrl = adjustUrl
            .replacingOccurrences(of: "vwidth=\"\(vwidthValues[i])\"", with: "vwidth=\"\(vwidthValueReplaces[i])\"")
            .replacingOccurrences(of: "width=\"\(vwidthValues[i])\"", with: "width=\"\(vwidthValueReplaces[i])\"")
            .replacingOccurrences(of: "vheight=\"\(vheightValues[i])\"", with: "vheight=\"\(vheightValueReplaces[i])\"")
            .replacingOccurrences(of: "height=\"\(vheightValues[i])\"", with: "height=\"\(vheightValueReplaces[i])\"")
        }
        //print("\n\n\n\n\(adjustUrl)")
        return adjustUrl
    }
    func adjustHtmlExcel(_ url:String) -> String{
        var adjustUrl = url
        let low = adjustUrl.range(of: "<table cellpadding=\"0\" cellspacing=\"0\" width=\"")?.upperBound
        guard low != nil else {
            return url
        }
        adjustUrl = adjustUrl.substring(from: low!)
        let up = adjustUrl.range(of: "\">")?.lowerBound
        adjustUrl = adjustUrl.substring(to: up!)
        
        adjustUrl = url.replacingOccurrences(of: "<table cellpadding=\"0\" cellspacing=\"0\" width=\"\(adjustUrl)\">", with: "<table cellpadding=\"0\" cellspacing=\"0\" width=\"\(picWidth)\">")
        return adjustUrl
    }
    @IBAction func collectionBtnAction(_ sender: UIButton) {
        let sendCollection = AVObject(className: "Collection")
        sendCollection["username"] = AVUser.current()?.username
        sendCollection["web_url"] = url
        sendCollection["name"] = name
        sendCollection["date"] = date
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sendCollection.saveEventually()
            JDStatusBarNotification.show(withStatus: "收藏成功", dismissAfter: 0.8)
        }else{
            let query = AVQuery(className: "Collection")
            query.whereKey("username", equalTo: sendCollection["username"])
            query.whereKey("web_url", equalTo: sendCollection["web_url"])
            query.findObjectsInBackground({ (objects:[Any]?, error:Error?) in
                if error == nil{
                    for object in objects!{
                        (object as AnyObject).deleteEventually()
                        JDStatusBarNotification.show(withStatus: "取消收藏", dismissAfter: 0.8)
                    }
                }
            })
        }
    }

    @IBAction func commentBtnAction(_ sender: UIButton) {
        let commentVC = self.storyboard?.instantiateViewController(withIdentifier: "CommentVC") as! CommentVC
        commentVC.url = url
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    @IBAction func shareBtnAction(_ sender: UIButton) {
        //一个URL
        let shareURL = NSURL(string: url)
        //初始化一个UIActivity
        var activity = UIActivity()
        
        let activityItems = [shareURL]
        let activities = [activity]
        //初始化UIActivityViewController
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: activities)
        //排除一些服务：例如拷贝到通讯录
        activityController.excludedActivityTypes = [UIActivityType.assignToContact]
        //iphone中为模式跳转
        self.present(activityController, animated: true) { () -> Void in
        }
        
        //结束后执行的Block，可以查看是那个类型执行，和是否已经完成
        var activityType:String?
        var error:NSError?
        activityController.completionHandler = { activityType, error in
            print("\(activityType)")
            print("\(error.description)")
        }
    }
}
