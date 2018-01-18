//
//  PersonalInfoModify.swift
//  NewsBang
//
//  Created by 徐炜楠 on 2018/1/11.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit

class PersonalInfoModifyVC: UIViewController {
    
    var imageAvatar:UIImage!
    var name:String!
    var number:String!

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var numberLb: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置图片圆角
        image.layer.cornerRadius = image.frame.height/2
        
        //设置初始资源
        image.image = imageAvatar
        nameLb.text = name
        numberLb.text = number
        
        // Do any additional setup after loading the view.
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
