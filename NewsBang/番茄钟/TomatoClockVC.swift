//
//  TomatoClockVC.swift
//  NewsBang
//
//  Created by 徐炜楠 on 2018/1/17.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit
import AudioToolbox
import Ji

class TomatoClockVC: UIViewController,timerDelegate {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var bgImage: UIImageView!
    
    var myTimer = MyTimer.shareInstance
    //暂时用来保存屏幕亮度
    var brightness:CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
        timerLabel.text = formatToDisplayTime(currentTime: myTimer.fireTime)
        self.myTimer.delegate = self
        brightness = UIScreen.main.brightness
        // Do any additional setup after loading the view.
        initBgPic()
    }
    //每日更新壁纸
    func initBgPic(){
        let temp = Int(arc4random()%8)+1
        let jiDoc = Ji(htmlURL: URL(string: "http://cn.bing.com/HPImageArchive.aspx?idx=0&n=\(temp)")!)
        let imgNode = jiDoc?.xPath("//body/images/image[\(temp)]/url")?.first
        print("jiDoc:\n\(jiDoc)")
        print("imgNode\(temp):\(imgNode?.content)")
        var picUrl = "http://cn.bing.com\((imgNode?.content)!)"
        picUrl = picUrl.replacingOccurrences(of: "1366x768", with: "1080x1920")
        //获取本地图像
        var UDimg = UIImage(named: "番茄钟🍅_bg")!
        if let imgData = UserDefaults.standard.object(forKey: "bgImage"){
            UDimg = UIImage(data: imgData as! Data)!
        }
        bgImage.imageFromURL(picUrl, placeholder: UDimg)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func timerBtnAction(_ sender: UIButton) {
        myTimer.timerWillAction()
    }
    override func viewWillAppear(_ animated: Bool) {
        //开启定时器
        myTimer.timerCurrentState = timerState.giveUp
        myTimer.timerWillState = timerState.start
        myTimer.time.fireDate = Date.distantPast
        print("myTimer = MyTimer.shareInstance")
        //设置屏幕常亮
        UIApplication.shared.isIdleTimerDisabled = true
        //设置状态栏
        UIApplication.shared.statusBarStyle = .lightContent
    }
    override func viewWillDisappear(_ animated: Bool) {
        //关闭定时器
        myTimer.time.fireDate = Date.distantFuture
        //设置屏幕常亮
        UIApplication.shared.isIdleTimerDisabled = false
        //保存离开图片
        UserDefaults.standard.set(UIImagePNGRepresentation(bgImage.image!), forKey: "bgImage")
        //设置状态栏
        UIApplication.shared.statusBarStyle = .default
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //代理中的方法
    @IBAction func dismissBtnAction(_ sender: UIButton) {
        //print("myTimer.timerCurrentState:\(myTimer.timerCurrentState)。myTimer.timerWillState:\(myTimer.timerWillState)")
        if myTimer.timerCurrentState == timerState.start && myTimer.timerWillState == timerState.giveUp {
            let alert = UIAlertController.init(title: "正在番茄中", message: "正在执行一个🍅，确定退出？", preferredStyle: .alert)
            let sure = UIAlertAction.init(title: "确定", style: .destructive, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
            let cancel = UIAlertAction.init(title: "取消", style: .default, handler: nil)
            alert.addAction(sure)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    func timerStateToController(timerWillState: String){
        switch timerWillState{
        case timerState.start:
            self.timerLabel.text = formatToDisplayTime(currentTime: self.myTimer.fireTime)
            //self.timerButton.setTitle("start", for: .normal)
            self.timerButton.setImage(UIImage(named: "🍅start"), for: .normal)
            //dismissBtn.isHidden = true
            UIScreen.main.brightness = brightness
        case timerState.giveUp:
            //self.timerButton.setTitle("giveUp", for: .normal)
            self.timerButton.setImage(UIImage(named: "🍅giveUp"), for: .normal)
            //dismissBtn.isHidden = true
            UIScreen.main.brightness = brightness
        case timerState.workingComplete:
            //self.timerButton.setTitle("restButton", for: .normal)
            self.timerButton.setImage(UIImage(named: "🍅rest"), for: .normal)
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            UIScreen.main.brightness = 1.0
        case timerState.rest:
            //self.timerButton.setTitle("restButton", for: .normal)
            self.timerButton.setImage(UIImage(named: "🍅rest"), for: .normal)
            UIScreen.main.brightness = brightness
        case timerState.restComplete:
            //self.timerButton.setTitle("work", for: .normal)
            self.timerButton.setImage(UIImage(named: "🍅work"), for: .normal)
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            UIScreen.main.brightness = 1.0
        default:
            print("error : \(timerWillState)")
        }
    }
    func updateingTime(currentTime:Int){
        timerLabel.text = formatToDisplayTime(currentTime: currentTime)
    }
}
