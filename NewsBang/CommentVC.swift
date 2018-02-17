//
//  CommentVC.swift
//  NewsBang
///Users/xwn/Downloads/NewsBang/NewsBang/CommentVC.swift
//  Created by 徐炜楠 on 2018/1/12.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit
import AVOSCloud

class CommentVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var comments = [Comment]()
    var url:String!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentInput: UITextField!
    @IBOutlet weak var commentSendBtn: UIButton!
    
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate  = self
        tableView.dataSource = self
        //监听键盘出现或消失的状态
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        //加载已有评论
        loadComments()
    }
    func loadComments(){
        let query = AVQuery(className: "Comments")
        query.whereKey("to", equalTo: url)
        query.addAscendingOrder("createdAt")
        query.findObjectsInBackground { (objects:[Any]?, error:Error?) in
            if error == nil{
                self.comments.removeAll(keepingCapacity: false)
                for object in objects!{
                    let tempObject = object as AnyObject
                    let username = tempObject["username"] as! String
                    let content = tempObject["content"] as! String
                    self.comments.append(Comment.init(imageFile: nil, username: username, content: content))
                    self.tableView.reloadData()
                }
            }
        }
    }
    @objc func showKeyboard(notification:Notification){
        let rect = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        tableViewBottom.constant = rect.cgRectValue.height
        inputViewBottom.constant = rect.cgRectValue.height
    }
    @objc func hideKeyboard(notification:Notification){
        //print(notification)
        tableViewBottom.constant = 0
        inputViewBottom.constant = 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CommentCell
        //如果有数据，那么直接读取，如果没有，那么查询
        //if let cellAvatarFile = comments[indexPath.row].imageFile{
        //    cellAvatarFile.getDataInBackground({ (data:Data?, error:Error?) in
        //        cell.avatar.image = UIImage(data: data!)
        //    })
        //}else{
            let avatarQuery = AVQuery(className: "_User")
            avatarQuery.whereKey("username", equalTo: AVUser.current()?.username!)
            avatarQuery.findObjectsInBackground({ (objects:[Any]?, error:Error?) in
                if error == nil{
                    guard let objects = objects,objects.count>0 else{
                        return
                    }
                    let tempObject = objects.first as! AnyObject
                    let avaFile = tempObject["avatar"] as? AVFile
                    avaFile?.getDataInBackground({ (data:Data?, error:Error?) in
                        cell.avatar.image = UIImage(data: data!)
                    })
                }else{
                    print("读取数据错了\(error?.localizedDescription)")
                }
            })
        //}
        cell.username.text = comments[indexPath.row].username
        cell.content.text = comments[indexPath.row].content
        print("cellForRowAt")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    @IBAction func commentSendAction(_ sender: UIButton) {
        
        if let user = AVUser.current(){
            print("avatar\(user["avatar"])")
            let imageFile = user["avatar"] as? AVFile
            let username = user.username!
            let content = commentInput.text!
            if content != ""{
                //更新表格视图
                comments.append(Comment(imageFile: imageFile, username: username, content: content))
                tableView.reloadData()
                commentInput.text = ""
                //发送至云端
                let commentObj = AVObject(className: "Comments")
                commentObj["to"] = url
                commentObj["username"] = username
                commentObj["content"] = content
                commentObj.saveEventually()//提交提交
                //commentObj["to"]
            }else{
                print("内容为空无法发送")
                alert(error: "内容为空", message: "内容为空无法发送")
            }
        }else{
            print("未登录无法发送评论")
        }
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
    struct Comment {
        var imageFile:AVFile?
        var username:String!
        var content:String!
        init(imageFile:AVFile?,username:String,content:String) {
            self.imageFile = imageFile
            self.username = username
            self.content = content
        }
        init() {
            self.imageFile = nil
            self.username = ""
            self.content = ""
        }
    }
}
