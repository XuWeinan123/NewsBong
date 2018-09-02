//
//  PersonalInfoModify.swift
//  NewsBang
//
//  Created by 徐炜楠 on 2018/1/11.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit
import AVOSCloud

class PersonalInfoModifyVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var imageAvatar:UIImage!
    var name:String!
    var number:String!

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var numberLb: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet var nameField: UITextField!
    
    @IBOutlet weak var changeAvatar: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置图片圆角
        image.layer.cornerRadius = image.frame.height/2
        changeAvatar.layer.cornerRadius = changeAvatar.frame.height/2
        
        //设置初始资源
        image.image = imageAvatar
        nameLb.text = name
        numberLb.text = number
        
        //添加点击事件
        let avatarTap = UITapGestureRecognizer(target: self, action: #selector(avatarChange))
        avatarTap.numberOfTapsRequired = 1
        changeAvatar.addGestureRecognizer(avatarTap)
        
        
        //添加bar上右按钮
        let rightBarItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveChanges))
        self.navigationItem.setRightBarButton(rightBarItem, animated: true)
        
        //如果用户已经设置过用户名，则不显示nameField
        if nameLb.text != "未设置用户名"{
            nameField.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    @objc func saveChanges(){
        self.pleaseWait()
        let user = AVUser.current()
        if changeAvatar.alpha != 1{
            let avaData = UIImagePNGRepresentation(image.image!)
            let avaFile = AVFile(name: "ava.jpg", data: avaData!)
            user?["avatar"] = avaFile
        }
        if emailField.text != ""{
            user?.email = emailField.text
        }
        if nameField.text != ""{
            user?["fullname"] = nameField.text!
        }
        user?.saveInBackground({ (success:Bool, error:Error?) in
            if success{
                print("头像上传成功\(self.changeAvatar.alpha)")
                //发送通知到主页
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:"reload"), object: nil)
                self.navigationController?.popViewController(animated: true)
            }else{
                self.noticeTop(error!.localizedDescription)
                print("用户更新失败:\(error?.localizedDescription)")
            }
            self.clearAllNotice()
        })
    }
    @objc func avatarChange(){
        print("点击成功")
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        image.image = (info[UIImagePickerControllerEditedImage] as? UIImage)?.cropToSquare()
        self.dismiss(animated: true, completion: nil)
        changeAvatar.alpha = 0.1
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
