//
//  CourseAdvancedSettingVC.swift
//  NewsBang
//
//  Created by 徐炜楠 on 2018/1/21.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit

class CourseAdvancedSettingVC: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let startDateFromUserDefaults = UserDefaults.standard.object(forKey: "startDate"){
            datePicker.date = startDateFromUserDefaults as! Date
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        let gregorianCalendar: Calendar = Calendar(identifier: .gregorian)
        let timesComponents = gregorianCalendar.dateComponents([.year,.month,.day, .weekday, .hour, .minute,.second], from: Date.init(timeInterval: TimeInterval(timeZone*60*60), since: sender.date))
        let date = numberToDate(year: timesComponents.year!, month: timesComponents.month!, day: timesComponents.day!)
        
        print("datePickerChanged\(date)\n\(sender.date)\n\(timeZone)")
        UserDefaults.standard.set(date, forKey: "startDate")
    }
    @IBAction func datePickerDidEnd(_ sender: UIDatePicker) {
        print("datePickerDidEnd\(sender.date)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**将三个数字转换为Date*/
    func numberToDate(year:Int,month:Int,day:Int) -> Date{
        var monthStr:String = "\(month)"
        var dayStr:String = "\(day)"
        if month<10{monthStr = "0\(month)"}
        if day<10{dayStr = "0\(day)"}
        let str = "\(year)-\(monthStr)-\(dayStr)"
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy/MM/dd"
        var date = formatter.date(from: str) //直接这么转会偏移8小时的时区
        date = Date(timeInterval: TimeInterval(timeZone*60*60), since: date!)
        return date!
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
