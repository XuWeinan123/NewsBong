    //
//  PersonalCenterVC.swift
//  NewsBang
//
//  Created by 徐炜楠 on 2018/1/10.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit
import AVOSCloud
import MessageUI

class PersonalCenterVC: UIViewController,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var personInfo: UIView!
    @IBOutlet weak var collocation: UIView!
    @IBOutlet weak var aboutApp: UIView!
    @IBOutlet weak var feedback: UIView!
    @IBOutlet weak var usernameLb: UILabel!
    @IBOutlet weak var usernumberLb: UILabel!
    @IBOutlet weak var useravatar: UIImageView!
    @IBOutlet weak var functionBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setInteraction()
        //从修改页面接受消息
        NotificationCenter.default.addObserver(self, selector: #selector(reload(notification:)), name: NSNotification.Name(rawValue:"reload"), object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func reload(notification:Notification){
        self.setUI()
    }
    func setUI(){
        avatar.layer.cornerRadius = avatar.frame.width/2
        
        //如果有用户，那么设置
        if let username = UserDefaults.standard.string(forKey: "username"){
            usernameLb.text = AVUser.current()!["fullname"] as? String
            usernumberLb.text = UserDefaults.standard.string(forKey: "username")
            //设置用户头像
            let queryAvatar = AVQuery(className: "_User")
            queryAvatar.whereKey("username", equalTo: username)
            queryAvatar.findObjectsInBackground({ (objects:[Any]?, error:Error?) in
                if error == nil{
                    print("用户头像找到了！")
                    let object = objects?.first as AnyObject
                    let tempFile = object["avatar"] as? AVFile
                    tempFile?.getDataInBackground({ (data:Data?, error:Error?) in
                        self.useravatar.image = UIImage(data: data!)
                    })
                }else{
                    print("寻找用户头像失败:\(error?.localizedDescription)")
                }
            })
            functionBtn.setTitle("退出", for: .normal)
            functionBtn.setTitleColor(UIColor.red, for: .normal)
        }else{
            usernameLb.text = "未登录"
            usernumberLb.text = "U201417000"
            useravatar.image = UIImage(named: "缺省头像")
            functionBtn.setTitle("登录", for: UIControlState.normal)
            functionBtn.setTitleColor(UIColor.blue, for: .normal)
        }
    }
    func setInteraction(){
        let personInfoTapGuesture = UITapGestureRecognizer(target: self, action: #selector(personInfoTap))
        personInfoTapGuesture.numberOfTapsRequired = 1
        personInfo.addGestureRecognizer(personInfoTapGuesture)
        let collocationTapGuesture = UITapGestureRecognizer(target: self, action: #selector(collocationTap))
        collocationTapGuesture.numberOfTapsRequired = 1
        collocation.addGestureRecognizer(collocationTapGuesture)
        let aboutAppTapGuesture = UITapGestureRecognizer(target: self, action: #selector(aboutAppTap))
        aboutAppTapGuesture.numberOfTapsRequired = 1
        aboutApp.addGestureRecognizer(aboutAppTapGuesture)
        let feedbackTapGuesture = UITapGestureRecognizer(target: self, action: #selector(feedbackTap))
        feedbackTapGuesture.numberOfTapsRequired = 1
        feedback.addGestureRecognizer(feedbackTapGuesture)
        
        //对functionBtn配置功能
        if functionBtn.title(for: .normal) == "登录"{
            functionBtn.removeTarget(self, action: #selector(functionBtnLogOut), for: .touchUpInside)
            functionBtn.addTarget(self, action: #selector(functionBtnLogIn), for: .touchUpInside)
        }else if functionBtn.title(for: .normal) == "退出"{
            functionBtn.removeTarget(self, action: #selector(functionBtnLogIn), for: .touchUpInside)
            functionBtn.addTarget(self, action: #selector(functionBtnLogOut), for: .touchUpInside)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func personInfoTap(){
        print("personInfoTap")
        let personalInfoModify = self.storyboard?.instantiateViewController(withIdentifier: "PersonalInfoModify") as! PersonalInfoModifyVC
        personalInfoModify.imageAvatar = avatar.image
        personalInfoModify.name = usernameLb.text!
        personalInfoModify.number = usernumberLb.text!
        self.navigationController?.pushViewController(personalInfoModify, animated: true)
    }
    @objc func collocationTap(){
        print("collocationTap")
        let myCollection = self.storyboard?.instantiateViewController(withIdentifier: "MyCollection") as! MyCollectionVC
        myCollection.footViewHeight = self.tabBarController?.tabBar.frame.height
        myCollection.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(myCollection, animated: true)
    }
    @objc func aboutAppTap(){
        print("aboutAppTap")
    }
    @objc func feedbackTap(){
        print("feedbackTap")
        if MFMailComposeViewController.canSendMail(){
            let mailComposeViewController = configuredMailComposeViewController()
            self.present(mailComposeViewController, animated: true, completion: nil)
        }else{
            self.showSendMailErrorAlert()
        }
        
    }
    @objc func functionBtnLogIn(){
        let signInVC = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        //let delegate = UIApplication.shared.delegate as! AppDelegate
        //delegate.window?.rootViewController = signInVC
        self.present(signInVC, animated: true) {
            print("准备登录，那么清除掉缓存")
        }
    }
    @objc func functionBtnLogOut(){
        //用户注销->弹框询问
        let alert = UIAlertController(title: "确认退出？", message: "退出登录后只保留最基础的新闻浏览功能", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "确认", style: .destructive) { (action) in
            print("退出登录，重新加载视图")
            AVUser.logOut()
            UserDefaults.standard.removeObject(forKey: "username")
            UserDefaults.standard.removeObject(forKey: "fullname")
            UserDefaults.standard.synchronize()
            self.viewDidLoad()
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    func alert(error:String,message:String){
        let alert = UIAlertController(title: error, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    //配置发邮件的视窗。
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        
        //获取设备名称
        let deviceName = UIDevice.current.name
        //获取系统版本号
        let systemVersion = UIDevice.current.systemVersion
        //获取设备的型号
        let deviceModel = UIDevice.current.model
        //获取设备唯一标识符
        let deviceUUID = UIDevice.current.identifierForVendor?.uuidString
        
        let infoDic = Bundle.main.infoDictionary
        
        // 获取App的版本号
        let appVersion = infoDic?["CFBundleShortVersionString"]
        // 获取App的build版本
        let appBuildVersion = infoDic?["CFBundleVersion"]
        // 获取App的名称
        let appName = infoDic?["CFBundleDisplayName"]
        
        //设置邮件地址、主题及正文
        mailComposeVC.setToRecipients(["woshixwn@gmail.com"])
        mailComposeVC.setSubject("NewsB应用反馈")
        mailComposeVC.setMessageBody("反馈：\n\n\n设备名称：\(deviceName)\n系统版本号：\(systemVersion)\n设备唯一标识符：\(deviceUUID!)\napp版本号：\(appVersion!)\napp build版本：\(appBuildVersion!)", isHTML: false)
        
        return mailComposeVC
        
    }
    //如果用户未设置邮箱
    func showSendMailErrorAlert() {
        
        let sendMailErrorAlert = UIAlertController(title: "无法发送邮件", message: "您的设备尚未设置邮箱，请在“邮件”应用中设置后再尝试发送。", preferredStyle: .alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "确定", style: .default) { _ in })
        self.present(sendMailErrorAlert, animated: true){}
        
    }
    //消失
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("取消发送")
        case MFMailComposeResult.sent.rawValue:
            print("发送成功")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
        
    }
}
