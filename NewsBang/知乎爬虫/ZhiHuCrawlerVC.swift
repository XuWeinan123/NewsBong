//
//  ZhiHuCrawlerVC.swift
//  NewsBang
//
//  Created by 徐炜楠 on 2018/2/12.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit
import Ji
import WebKit
//import Lottie

class ZhiHuCrawlerVC: UIViewController,WKNavigationDelegate {

    @IBOutlet weak var statusLb: UILabel!
    @IBOutlet var webView1: WKWebView!
    //let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    @IBOutlet weak var percentLb: UILabel!
    @IBOutlet weak var numberLb: UILabel!
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var forceStopBtn: UIButton!
    var urlRequest:URLRequest!
    var url:URL!
    var urlStr = ""
    var timer = Timer()
    var takenStr = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        //导航栏
        //let sourceCode = UIBarButtonItem(title: "源码", style: .plain, target: self, action: #selector(sourceCodeAction))
        //self.navigationItem.rightBarButtonItem = sourceCode
        
        url = URL.init(string: urlStr)!
        urlRequest = URLRequest(url: url)
        webView1.load(urlRequest)
        webView1.navigationDelegate = self
        
        //配置UI
        forceStopBtn.layer.cornerRadius = 4
        
        //添加动画
        gifImageView.loadGif(name: "刘看山动画")
        //设置屏幕常亮
        UIApplication.shared.isIdleTimerDisabled = true

        // Do any additional setup after loading the view.
    }
    @objc func sourceCodeAction(){
        //let string = webView.stringByEvaluatingJavaScript(from: "document.documentElement.innerHTML")
        var string = takenStr
        
        let mainDoc = Ji(htmlString: string)
        let node = mainDoc?.xPath("//*[@id=\"QuestionAnswers-answers\"]/div/div/div[2]/div")?.first
        guard node != nil else {
            self.noticeTop("出现错误，无法抓取")
            return
        }
        self.noticeTop("答案数量：\((node?.children.count)!-1)")
        var totalStrArray = [[String]]()
        for i in 0..<((node?.children.count)!-1){
            totalStrArray.append(self.analyseNode(children: (node?.children[i])!))
        }
        //createXLSFile()
        
        //跳转表格
        
        let backBtn = UIBarButtonItem()
        backBtn.title = "返回"
        self.navigationItem.backBarButtonItem = backBtn
        
        let excelVC = self.storyboard?.instantiateViewController(withIdentifier: "Excel") as! ExcelVC
        excelVC.doubleString = totalStrArray
        self.navigationController?.pushViewController(excelVC, animated: true)
    }
    @IBAction func forceBtnAction(_ sender: UIButton) {
        if sender.title(for: .normal) == "强行终止"{
            timer.invalidate()
            self.statusLb.text = "抓取中断"
            self.gifImageView.image = UIImage(named: "刘看山动画-死亡")
            //设置屏幕常亮
            UIApplication.shared.isIdleTimerDisabled = false
            //设置按钮
            self.forceStopBtn.setTitle("查看结果", for: .normal)
            //跳转源码页面
            sourceCodeAction()
        }else if sender.title(for: .normal) == "查看结果"{
            sourceCodeAction()
        }
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("高级网页开始加载")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.navigationItem.rightBarButtonItems = []
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("高级网页加载结束")
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        var string:String?
        webView.evaluateJavaScript("document.documentElement.innerHTML") { (result, error) in
            if error != nil{
                print("获取网页内容出错179")
            }else{
                string = result as? String
                
                let mainDoc = Ji(htmlString: string!)
                let numberNode = mainDoc?.xPath("//*[@id=\"QuestionAnswers-answers\"]/div/div/div[1]/h4/span")?.first
                //判断网页是否有效
                guard numberNode != nil else {
                    self.noticeTop("错误的问题编号！")
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                //获取回答总数
                let numberStr = "\((numberNode?.content?.split(separator: " ").first)!)".replacingOccurrences(of: ",", with: "")
                let number = Int(numberStr)!
                //print("回答总数\(number)")
                self.statusLb.text = "正在爬...稍等..."
                let statusTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
                    if self.statusLb.text == "抓取中断" || self.statusLb.text == "抓取结束"{
                        timer.invalidate()
                        return
                    }
                    
                    if self.statusLb.text == "正在爬...稍等..."{
                        self.statusLb.text = "抓取数据超过设备内存会停止"
                    }else if self.statusLb.text == "抓取数据超过设备内存会停止"{
                        self.statusLb.text = "本爬虫只适用于抓取少量数据"
                    }else if self.statusLb.text == "本爬虫只适用于抓取少量数据"{
                        self.statusLb.text = " 抓取速度与性能、网速相关"
                    }else{
                        self.statusLb.text = "正在爬...稍等..."
                    }
                }
                self.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (timer) in
                    webView.evaluateJavaScript("document.body.scrollTop = document.body.scrollHeight", completionHandler: nil)
                    webView.evaluateJavaScript("document.documentElement.innerHTML", completionHandler: { (result, error) in
                        if error != nil{
                            print("获取网页内容错误147:\(error?.localizedDescription)")
                        }else{
                            self.takenStr = result as! String
                            
                            let mainDoc = Ji(htmlString: self.takenStr)
                            let node = mainDoc?.xPath("//*[@id=\"QuestionAnswers-answers\"]/div/div/div[2]/div")?.first
                            let percent = Float((node?.children.count)!-1)/Float(number)
                            self.percentLb.text = "\(String(format: "%.2f", percent*100))%"
                            self.numberLb.text = "(\((node?.children.count)!-1)/\(number))"
                            print("抓取数量:"+(self.numberLb.text)!)
                            //激活按钮
                            if self.forceStopBtn.isHidden{ self.forceStopBtn.isHidden = false }
                            //print("\(number)现在抓到数量\((node?.children.count)!-1)\n抓取进度:\(String(format: "%.2f", percent*100))%")
                            if (node?.children.count)!-1 >= number || percent>0.995{
                                print("定时任务结束")
                                statusTimer.invalidate()
                                timer.invalidate()
                                self.statusLb.text = "抓取结束"
                                self.gifImageView.image = UIImage(named: "刘看山动画")
                                //导航栏
                                //let sourceCode = UIBarButtonItem(title: "查看", style: .plain, target: self, action: #selector(self.sourceCodeAction))
                                //self.navigationItem.rightBarButtonItems = [sourceCode]
                                //设置屏幕常亮
                                UIApplication.shared.isIdleTimerDisabled = false
                                //设置按钮
                                self.forceStopBtn.setTitle("查看结果", for: .normal)
                                //self.clearAllNotice()
                            }
                        }
                    })
                }
            }
        }
    }
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("进程即将终止")
        timer.invalidate()
        
        self.statusLb.text = "抓取中断"
        self.gifImageView.image = UIImage(named: "刘看山动画-死亡")
        //设置屏幕常亮
        UIApplication.shared.isIdleTimerDisabled = false
        //设置按钮
        self.forceStopBtn.setTitle("查看结果", for: .normal)
        
        let alert = UIAlertController(title: "抓取中断", message: "设备性能不足，抓取数据有限", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    func analyseNode(children node:JiNode) -> [String]{
        let node = node
        //用户头像，用户名称，用户简介，用户答案节点
        var avatar = ""
        var name = ""
        var userHomepage = ""
        var userFollowers = 0
        var bio = ""
        var likeNumber = 0
        var contentNode:JiNode
        let metas = node.firstChild?.firstChild?.firstChild?.children
        name = (metas?[0].attributes["content"])!
        avatar = (metas?[1].attributes["content"])!
        userHomepage = (metas?[2].attributes["content"])!
        userFollowers = Int((metas?[3].attributes["content"])!)!
        let nameAndDetailNodes = metas?[5].children
        let bioNode = nameAndDetailNodes?[1].firstChild?.firstChild
        bio = (bioNode?.content)!
        if bio.contains("react-empty:"){
            bio = ""
        }
        if bio.contains("被遗弃的"){
            print("简介:\(bio)")
        }
        bio = bio.replacingOccurrences(of: "\n", with: "_")

        //分析赞数
        if (node.firstChild?.firstChild?.children.count)! > 1{
            if let likeNumberNode = node.firstChild?.firstChild?.children[1].firstChild?.firstChild?.firstChild{
                likeNumber = Int((likeNumberNode.content)!.split(separator: " ")[0].replacingOccurrences(of: ",", with: ""))!
            }else{
                //let tempStr = node.firstChild?.firstChild?.children[1].firstChild?.children
                //print("\(name)余额：\(tempStr![0])\n\(tempStr![1])\n\(tempStr![2])")
                
                let tempNode = node.firstChild?.firstChild?.children[1].children
                likeNumber = Int((tempNode![(tempNode?.count)!-1].content)!.split(separator: " ")[0].replacingOccurrences(of: ",", with: ""))!
                //print("\(name) 最后的倔强:\(likeNumber)")
            }
        }
        //文章内容 //*[@id="QuestionAnswers-answers"]/div/div/div[2]/div/div[1]/div/div[2]/div[1]/span
        contentNode = (node.firstChild?.children[7].firstChild?.firstChild)!
        let content = (contentNode.content)!.replacingOccurrences(of: "\n", with: "\\n")
        
        //print("\n\n用户名称：\(name)\n用户头像：\n\(avatar)\n用户简介：\(bio)\n用户主页：\n\(userHomepage)\n用户粉丝：\(userFollowers)\n赞同数量：\(likeNumber)\n文章内容：\n\((contentNode.content)!)")
        return [name,bio,"\(likeNumber)","\(userFollowers)","\(content)"]
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

}
