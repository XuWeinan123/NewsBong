//
//  SignUpVC.swift
//  NewsBang
//
//  Created by 徐炜楠 on 2018/1/11.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit
import AVOSCloud

class SignUpVC: UIViewController {

    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var passwordInputRepeat: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var scrollBottomClose: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        //按钮圆角
        signUpBtn.layer.cornerRadius = signUpBtn.frame.height/2
        closeBtn.layer.cornerRadius = closeBtn.frame.height/2
        //监听键盘出现或消失的状态
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func showKeyboard(notification:Notification){
        let rect = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        scrollBottomClose.constant = -rect.cgRectValue.height
    }
    @objc func hideKeyboard(notification:Notification){
        //print(notification)
        scrollBottomClose.constant = 0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpBtn(_ sender: UIButton) {
        //检测用户名密码是否为空
        print("用户名:\(usernameInput.text)")
        guard usernameInput.text != "" else {
            alert(error: "学号为空", message: "学号为空时无法注册")
            return
        }
        guard passwordInput.text != "" else {
            alert(error: "密码为空", message: "密码为空时无法注册")
            return
        }
        guard passwordInput.text == passwordInputRepeat.text else {
            alert(error: "密码不一致", message: "两次输入的密码不一致")
            return
        }
        let signUpUser = AVUser()
        signUpUser.username = usernameInput.text!.uppercased()
        signUpUser.password = passwordInput.text!
        signUpUser["fullname"] = "未设置用户名"
        //signUpUser.email = "woshixwn@gmail.com"
        signUpUser.signUpInBackground { (success:Bool, error:Error?) in
            if success{
                print("注册成功")
                AVUser.logInWithUsername(inBackground: signUpUser.username!, password: signUpUser.password!, block: {(user:AVUser?,error:Error?) in
                    if let user = user{
                        UserDefaults.standard.set(user.username, forKey: "username")
                        UserDefaults.standard.set("未设置用户名", forKey: "fullname")
                        UserDefaults.standard.synchronize()
                        //从AppDelegate类中调用login方法
                        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.login()
                    }else{
                        print(error?.localizedDescription)
                    }
                })
            }else{
                print("注册失败:\(error?.localizedDescription)")
            }
        }
    }
    @IBAction func closeBtn(_ sender: UIButton) {
        dismiss(animated: true) {
        }
    }
    
    func alert(error:String,message:String){
        let alert = UIAlertController(title: error, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
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
