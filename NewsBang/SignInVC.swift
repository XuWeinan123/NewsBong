//
//  SignInVC.swift
//  NewsBang
//
//  Created by 徐炜楠 on 2018/1/10.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit
import AVOSCloud

class SignInVC: UIViewController {

    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //按钮圆角
        signInBtn.layer.cornerRadius = signInBtn.frame.height/2
        // Do any additional setup after loading the view.
    }
    @IBAction func signInBtn(_ sender: UIButton) {
        guard usernameInput.text != "" else {
            alert(error: "学号为空", message: "学号为空时无法注册")
            return
        }
        guard passwordInput.text != "" else {
            alert(error: "密码为空", message: "密码为空时无法注册")
            return
        }
        AVUser.logInWithUsername(inBackground: usernameInput.text!.uppercased(), password: passwordInput.text!, block: {(user:AVUser?,error:Error?) in
            if error == nil{
                UserDefaults.standard.set(user!.username, forKey: "username")
                UserDefaults.standard.synchronize()
                
                let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
            }else{
                print("登录错误\(error?.localizedDescription)")
                self.alert(error: "登录错误", message: "用户名或密码出错")
                self.passwordInput.text = ""
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
