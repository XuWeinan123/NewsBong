    //
//  DigitInputVC.swift
//  NewsBang
//
//  Created by 徐炜楠 on 2018/2/13.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit

class DigitInputVC: UIViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var buttonClear: UIButton!
    @IBOutlet weak var numberLb: UILabel!
    @IBOutlet weak var button0Constraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        //let begin = UIBarButtonItem(title: "分析", style: .plain, target: self, action: #selector(beginCrawler))
        //self.navigationItem.rightBarButtonItems = [begin]
        // Do any additional setup after loading the view.
        button0Constraint.constant = UIScreen.main.bounds.height*32/736
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func buttonAction(_ sender:UIButton){
        if sender.tag == 10{
            numberLb.text = ""
            self.navigationItem.rightBarButtonItems = []
        }else if sender.tag == 11{
            if numberLb.text?.count != 0 {
                var string = numberLb.text
                string?.removeLast()
                numberLb.text = string
                if numberLb.text == "" {
                    self.navigationItem.rightBarButtonItems = []
                }
            }
        }else{
            if numberLb.text == ""{
                let begin = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(beginCrawler))
                self.navigationItem.rightBarButtonItems = [begin]
            }
            if numberLb.text?.count != 9{
                numberLb.text = "\((numberLb.text)!)\(sender.tag)"
            }
        }
    }
    @objc func beginCrawler(){
        let zhiHuCrawlerVC = self.storyboard?.instantiateViewController(withIdentifier: "ZhiHuCrawler") as! ZhiHuCrawlerVC
        zhiHuCrawlerVC.urlStr = "https://www.zhihu.com/question/\((numberLb.text)!)"
        
        let backBtn = UIBarButtonItem()
        backBtn.title = "返回"
        navigationItem.backBarButtonItem = backBtn
        
        self.navigationController?.pushViewController(zhiHuCrawlerVC, animated: true)
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
