//
//  ExcelVC.swift
//  NewsBang
//
//  Created by 徐炜楠 on 2018/2/13.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit
import JJStockView

class ExcelVC: UIViewController,StockViewDelegate,StockViewDataSource,UIDocumentInteractionControllerDelegate {
    var stockView = JJStockView()
    let headTitle = ["名称","简介","赞数","用户粉丝","内容"]
    var doubleString = [[String]]()
    var path = ""
    var documentController:UIDocumentInteractionController!

    override func viewDidLoad() {
        super.viewDidLoad()
        stockView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        stockView.dataSource = self
        stockView.delegate = self
        self.view.addSubview(stockView)
        //print("双重数组:\(doubleString)")
        //生成文件
        let excelFile = Excel(line: headTitle.count, heads: headTitle)
        var tempStr = [String]()
        for i in 0..<doubleString.count{
            for j in 0..<doubleString[i].count{
                tempStr.append(doubleString[i][j])
            }
        }
        path = excelFile.createExcel(lineDatas: tempStr)
        print("文档存储路径:\(path)")
        
        //导航栏
        let shareFile = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAction))
        self.navigationItem.rightBarButtonItem = shareFile
        //初始化文档分享器
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let url = urlForDocument[0] as URL
        documentController = UIDocumentInteractionController(url:URL(fileURLWithPath: "\(url)export.xls"))
        documentController.delegate = self;
        
        // Do any additional setup after loading the view.
    }
    @objc func shareAction(){
        //documentController.presentOpenInMenu(from: self.navigationItem.rightBarButtonItem!, animated: true)
        documentController.presentOptionsMenu(from: self.navigationItem.rightBarButtonItem!, animated: true)
    }
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func count(for stockView: JJStockView!) -> UInt {
        return UInt(doubleString.count)
    }
    func titleCell(for stockView: JJStockView!, atRowPath row: UInt) -> UIView! {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        label.text = "\(row+1)"
        label.textColor = UIColor.gray
        label.backgroundColor = UIColor(red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1.0)
        label.textAlignment = .center
        return label
    }
    func contentCell(for stockView: JJStockView!, atRowPath row: UInt) -> UIView! {
        let bg = UIView(frame: CGRect(x: 0, y: 0, width: headTitle.count*100+300, height: 30))
        bg.backgroundColor = row % 2 == 0 ? UIColor.white : UIColor(red: 240.0/255, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        for i in 0..<headTitle.count{
            let label = UILabel(frame: CGRect(x: i*100, y: 0, width: 100, height: 30))
            if i == headTitle.count-1 { label.frame = CGRect(x: i*100, y: 0, width: 400, height: 30) }
            label.text = doubleString[Int(row)][i]
            label.textAlignment = .center
            bg.addSubview(label)
        }
        return bg
    }
    func height(forCell stockView: JJStockView!, atRowPath row: UInt) -> CGFloat {
        return 30.0
    }
    func headRegularTitle(_ stockView: JJStockView!) -> UIView! {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        label.text = ""
        label.backgroundColor = UIColor.white
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }
    func headTitle(_ stockView: JJStockView!) -> UIView! {
        let bg = UIView(frame: CGRect(x: 0, y: 0, width: headTitle.count*100+300, height: 40))
        bg.backgroundColor = UIColor(red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1.0)
        for i in 0..<headTitle.count{
            let label = UILabel(frame: CGRect(x: i*100, y: 0, width: 100, height: 40))
            if i == headTitle.count-1 { label.frame = CGRect(x: i*100, y: 0, width: 400, height: 40) }
            label.text = headTitle[i]
            label.textAlignment = .center
            label.textColor = UIColor.gray
            bg.addSubview(label)
        }
        return bg
    }
    func height(forHeadTitle stockView: JJStockView!) -> CGFloat {
        return 40
    }
    func didSelect(_ stockView: JJStockView!, atRowPath row: UInt) {
        print("选中了\(row)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardS  egue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
