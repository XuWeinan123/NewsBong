//
//  ToolsCollectionVC.swift
//  NewsBang
//
//  Created by 徐炜楠 on 2018/1/14.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit

class ToolsCollectionVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var toolImage = [UIImage]()
    var toolName = [String]()
    let layout = UICollectionViewFlowLayout()
    @IBOutlet weak var toolsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolsCollectionView.delegate = self
        toolsCollectionView.dataSource = self
        setUI()
        initParameters()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes

        // Do any additional setup after loading the view.
    }
    func setUI(){
        //设置collectionViewFlowLayout
        let itemsize = UIScreen.main.bounds.width/4
        layout.itemSize = CGSize(width: itemsize, height: itemsize)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        toolsCollectionView.collectionViewLayout = layout
    }
    func initParameters(){
        toolImage.append(UIImage(named: "师资队伍")!)
        toolImage.append(UIImage(named: "番茄钟🍅")!)
        //toolImage.append(UIImage(named: "课程日历")!)
        //toolImage.append(UIImage(named: "红包口令")!)
        toolImage.append(UIImage(named: "去哪吃饭")!)
        toolImage.append(UIImage(named: "知乎爬虫")!)
        toolImage.append(UIImage(named: "图书查询")!)
        toolImage.append(UIImage(named: "图书查询")!)
        toolName.append("教师名片")
        toolName.append("番茄时钟")
        //toolName.append("课程日历")
        //toolName.append("红包口令")
        toolName.append("去哪吃饭")
        toolName.append("知乎爬虫")
        toolName.append("图书查询")
        toolName.append("微博爬虫")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return toolName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ToolsCollectionCell
        cell.image.image = toolImage[indexPath.row]
        cell.name.text = toolName[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectiItemAt:\(indexPath.row)")
        switch indexPath.row {
        case 0:
            let teacherCardVC = self.storyboard?.instantiateViewController(withIdentifier: "teacherCard") as! TeacherCardVC
            teacherCardVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(teacherCardVC, animated: true)
        case 1:
            let tomatoClockVC = self.storyboard?.instantiateViewController(withIdentifier: "TomatoClock") as! TomatoClockVC
            tomatoClockVC.hidesBottomBarWhenPushed = true
            self.present(tomatoClockVC, animated: true, completion: nil)
        /*case 2:
            /*let courseCalendarVC = self.storyboard?.instantiateViewController(withIdentifier: "CourseCalendar") as! CourseCalendarVC
            courseCalendarVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(courseCalendarVC, animated: true)*/
            self.noticeError("暂不可用", autoClear: true, autoClearTime: 1)*/
        /*case 2:
            let pasteboard = UIPasteboard.general
            pasteboard.string = "nKjLQL83bX"
            self.noticeInfo("复制成功", autoClear: true, autoClearTime: 1)*/
        case 2:
            let zhuanpan = self.storyboard?.instantiateViewController(withIdentifier: "ZhuanPan") as! ZhuanPanVC
            zhuanpan.hidesBottomBarWhenPushed = true
            self.present(zhuanpan, animated: true, completion: nil)
        case 3:
            let digitInputVC = self.storyboard?.instantiateViewController(withIdentifier: "DigitInput") as! DigitInputVC
            digitInputVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(digitInputVC, animated: true)
        case 4:
            let libraryVC = self.storyboard?.instantiateViewController(withIdentifier: "Library") as! LibraryVC
            libraryVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(libraryVC, animated: true)
        case 5:
            let weiBoCrawlerVC = self.storyboard?.instantiateViewController(withIdentifier: "WeiBoCrawlerVC3") as! WeiBoCrawlerVC3
            weiBoCrawlerVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(weiBoCrawlerVC, animated: true)
        default: break
        }
    }
}
