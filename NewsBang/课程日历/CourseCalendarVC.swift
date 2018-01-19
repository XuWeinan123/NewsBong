//
//  CourseCalendarVC.swift
//  NewsBang
//
//  Created by 徐炜楠 on 2018/1/18.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit
import EventKit

class CourseCalendarVC: UIViewController {
    
    var startDate:Date!
    var switchTime:Int!
    var courseItems = [CourseItem]()
    var semester = "第一学期"
    var grade = gradeChoose.unchoose
    var major = majorChoose.unchoose

    @IBOutlet weak var seniorBtn: UIButton!
    @IBOutlet weak var juniorBtn: UIButton!
    @IBOutlet weak var sophomoreBtn: UIButton!
    @IBOutlet weak var freshmanBtn: UIButton!
    
    @IBOutlet weak var xinwenBtn: UIButton!
    @IBOutlet weak var guangdianBtn: UIButton!
    @IBOutlet weak var guanggaoBtn: UIButton!
    @IBOutlet weak var chuanboBtn: UIButton!
    @IBOutlet weak var bozhuBtn: UIButton!
    
    var freshmanYear = 2018
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        //起始日期
        startDate = numberToDate(year: 2018, month: 9, day: 4)
        switchTime = 5*100+7    //第五周第七天开始执行秋季表
        //"2018-01-15"
        courseItems.append(CourseItem.init(dayInWeek: 1, classLowToUp: [5,6], name: "西方新闻思想", weeks: [1,2,3,4,6,7], teacher: "刘锐", location: "东九楼D215"))
        
        //insertEventByCourseItems()
        
    }
    func setUI(){
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var comps: DateComponents = DateComponents()
        comps = calendar.dateComponents([.year,.month,.day, .weekday, .hour, .minute,.second], from: Date())
        freshmanYear = comps.year!
        if comps.month! < 9 {
            freshmanYear -= 1
        }
        seniorBtn.setTitle("\(freshmanYear-3)", for: .normal)
        juniorBtn.setTitle("\(freshmanYear-2)", for: .normal)
        sophomoreBtn.setTitle("\(freshmanYear-1)", for: .normal)
        freshmanBtn.setTitle("\(freshmanYear)", for: .normal)
        
    }
    //以下开始四个按钮的动作模式（暂时只知道这个简单粗暴的方法）
    @IBAction func seniorBtnAction(_ sender: UIButton) {
        seniorBtn.isSelected = true
        juniorBtn.isSelected = false
        sophomoreBtn.isSelected = false
        freshmanBtn.isSelected = false
        
        grade = gradeChoose.senior
        whenFinishChoose()
    }
    @IBAction func juniorBtnAction(_ sender: UIButton) {
        seniorBtn.isSelected = false
        juniorBtn.isSelected = true
        sophomoreBtn.isSelected = false
        freshmanBtn.isSelected = false
        
        grade = gradeChoose.junior
        whenFinishChoose()
    }
    @IBAction func sophomoreBtnAction(_ sender: UIButton) {
        seniorBtn.isSelected = false
        juniorBtn.isSelected = false
        sophomoreBtn.isSelected = true
        freshmanBtn.isSelected = false
        
        grade = gradeChoose.sophomore
        whenFinishChoose()
    }
    @IBAction func freshmanBtnAction(_ sender: UIButton) {
        seniorBtn.isSelected = false
        juniorBtn.isSelected = false
        sophomoreBtn.isSelected = false
        freshmanBtn.isSelected = true
        
        grade = gradeChoose.freshman
        whenFinishChoose()
    }
    //五个按钮的
    @IBAction func xinwenAction(_ sender: UIButton) {
        xinwenBtn.isSelected = true
        guangdianBtn.isSelected = false
        guanggaoBtn.isSelected = false
        chuanboBtn.isSelected = false
        bozhuBtn.isSelected = false
        
        major = majorChoose.xinwen
        whenFinishChoose()
    }
    @IBAction func guangdianAction(_ sender: UIButton) {
        xinwenBtn.isSelected = false
        guangdianBtn.isSelected = true
        guanggaoBtn.isSelected = false
        chuanboBtn.isSelected = false
        bozhuBtn.isSelected = false
        
        major = majorChoose.guangdian
        whenFinishChoose()
    }
    @IBAction func guanggaoAction(_ sender: UIButton) {
        xinwenBtn.isSelected = false
        guangdianBtn.isSelected = false
        guanggaoBtn.isSelected = true
        chuanboBtn.isSelected = false
        bozhuBtn.isSelected = false
        
        major = majorChoose.guanggao
        whenFinishChoose()
    }
    @IBAction func chuanboAction(_ sender: UIButton) {
        xinwenBtn.isSelected = false
        guangdianBtn.isSelected = false
        guanggaoBtn.isSelected = false
        chuanboBtn.isSelected = true
        bozhuBtn.isSelected = false
        
        major = majorChoose.chuanbo
        whenFinishChoose()
    }
    @IBAction func bozhuAction(_ sender: UIButton) {
        xinwenBtn.isSelected = false
        guangdianBtn.isSelected = false
        guanggaoBtn.isSelected = false
        chuanboBtn.isSelected = false
        bozhuBtn.isSelected = true
        
        major = majorChoose.bozhu
        whenFinishChoose()
    }
    //马丹总算结束了
    func whenFinishChoose(){
        if grade != gradeChoose.unchoose && major != majorChoose.unchoose{
            print("选择了\(grade)、\(major)")
        }
    }
    
    
    
    //插入文件
    func insertEventByCourseItems(){
        let eventStore = EKEventStore()
        //建立一个课表日历
        let tempCalendar = EKCalendar.init(for: .event, eventStore: eventStore)
        do{
            tempCalendar.title = "学习"
            tempCalendar.source = eventStore.defaultCalendarForNewEvents?.source
            print("calendarIdentifier:\(tempCalendar.calendarIdentifier)")
            try eventStore.saveCalendar(tempCalendar, commit: true)
        }catch{
            print("error:\(error)")
        }
        //添加事件
        eventStore.requestAccess(to: .event, completion: {
            granted, error in
            if (granted) && (error == nil) {
                //print("granted \(granted)")
                //print("error  \(error)")
                let events = self.switchCourseItemToEvent(courseItem: self.courseItems[0], eventStore: eventStore, calendar: tempCalendar)
                print("events的数量\(events.count)")
                for event in events{
                    do{
                        try eventStore.save(event, span: .thisEvent)
                        print("Saved Event")
                    }catch{
                        print("添加失败：\(error)")
                        self.alert(error: "添加失败", message: "请确认日历权限是否打开")
                    }
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //把一个CourseItem对象变成EKEvent事件组
    func switchCourseItemToEvent(courseItem:CourseItem,eventStore:EKEventStore,calendar:EKCalendar) -> [EKEvent]{
        var tempCourseItem = courseItem
        var events = [EKEvent]()
        for i in 0..<tempCourseItem.weeks.count{
            let event = EKEvent(eventStore: eventStore)
            event.title = tempCourseItem.name
            let isSummer = ((tempCourseItem.weeks[i]*100 + tempCourseItem.dayInWeek) > switchTime) != (semester == "第一学期")
            print("isSummer:\(isSummer)")
            let dates = inferDates(week: tempCourseItem.weeks[i],
                                   dayInWeek: tempCourseItem.dayInWeek,
                                   classLowToUp: tempCourseItem.classLowToUp,
                                   startDate: startDate,
                                   isSummer: isSummer)
            event.startDate = dates[0]
            event.endDate = dates[1]
            
            event.notes = "上课老师:\((tempCourseItem.teacher!))"
            event.location = tempCourseItem.location
            event.calendar = calendar
            events.append(event)
        }
        return events
    }
    //从week\dayInWeek\classLowToUp推断出日期
    func inferDates(week:Int,dayInWeek:Int,classLowToUp:[Int],startDate:Date,isSummer:Bool) -> [Date]{
        //开始
        var offset = 7*24*60*60*(week-1)
        offset += 24*60*60*(dayInWeek-1)
        if isSummer{
            switch classLowToUp[0]{
            case 1:
                offset += (8*60*60+0*60)
            case 2:
                offset += (8*60*60+55*60)
            case 3:
                offset += (10*60*60+10*60)
            case 4:
                offset += (11*60*60+5*60)
            case 5:
                offset += (14*60*60+30*60)
            case 6:
                offset += (15*60*60+20*60)
            case 7:
                offset += (16*60*60+25*60)
            case 8:
                offset += (17*60*60+15*60)
            case 9:
                offset += (19*60*60+0*60)
            case 10:
                offset += (19*60*60+50*60)
            case 11:
                offset += (20*60*60+45*60)
            case 12:
                offset += (21*60*60+35*60)
            default:
                break
            }
        }else{
            switch classLowToUp[0]{
            case 1:
                offset += (8*60*60+0*60)
            case 2:
                offset += (8*60*60+55*60)
            case 3:
                offset += (10*60*60+10*60)
            case 4:
                offset += (11*60*60+5*60)
            case 5:
                offset += (14*60*60+0*60)
            case 6:
                offset += (14*60*60+50*60)
            case 7:
                offset += (15*60*60+55*60)
            case 8:
                offset += (16*60*60+45*60)
            case 9:
                offset += (18*60*60+30*60)
            case 10:
                offset += (19*60*60+20*60)
            case 11:
                offset += (20*60*60+15*60)
            case 12:
                offset += (21*60*60+05*60)
            default:
                break
            }
        }
        let date1 = Date.init(timeInterval: TimeInterval(offset), since: startDate)
        
        //结束
        var offset2 = 7*24*60*60*(week-1)
        offset2 += 24*60*60*(dayInWeek-1)
        if isSummer{
            switch classLowToUp[1]{
            case 1:
                offset2 += (8*60*60+45*60)
            case 2:
                offset2 += (9*60*60+40*60)
            case 3:
                offset2 += (10*60*60+55*60)
            case 4:
                offset2 += (11*60*60+50*60)
            case 5:
                offset2 += (15*60*60+15*60)
            case 6:
                offset2 += (16*60*60+05*60)
            case 7:
                offset2 += (17*60*60+10*60)
            case 8:
                offset2 += (18*60*60+0*60)
            case 9:
                offset2 += (19*60*60+45*60)
            case 10:
                offset2 += (20*60*60+35*60)
            case 11:
                offset2 += (21*60*60+30*60)
            case 12:
                offset2 += (22*60*60+20*60)
            default:
                break
            }
        }else{
            switch classLowToUp[1]{
            case 1:
                offset2 += (8*60*60+45*60)
            case 2:
                offset2 += (9*60*60+40*60)
            case 3:
                offset2 += (10*60*60+55*60)
            case 4:
                offset2 += (11*60*60+50*60)
            case 5:
                offset2 += (14*60*60+45*60)
            case 6:
                offset2 += (15*60*60+35*60)
            case 7:
                offset2 += (16*60*60+40*60)
            case 8:
                offset2 += (17*60*60+30*60)
            case 9:
                offset2 += (19*60*60+15*60)
            case 10:
                offset2 += (20*60*60+5*60)
            case 11:
                offset2 += (21*60*60+0*60)
            case 12:
                offset2 += (21*60*60+50*60)
            default:
                break
            }
        }
        let date2 = Date.init(timeInterval: TimeInterval(offset2), since: startDate)
        
        var dates = [Date]()
        dates.append(date1)
        dates.append(date2)
        return dates
    }
    //将三个数字转换为Date
    func numberToDate(year:Int,month:Int,day:Int) -> Date{
        var monthStr:String = "\(month)"
        var dayStr:String = "\(day)"
        if month<10{monthStr = "0\(month)"}
        if day<10{dayStr = "0\(day)"}
        let str = "\(year)-\(monthStr)-\(dayStr)"
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy/MM/dd"
        let date = formatter.date(from: str)
        return date!
    }
    func alert(error:String,message:String){
        let alert = UIAlertController(title: error, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    struct CourseItem {
        var dayInWeek:Int!  //星期几上课
        var classLowToUp = [Int]()  //课程从第几节到第几节
        var name:String!    //课程名字
        var weeks = [Int]()     //上课的周次
        var teacher:String!     //上课老师
        var location:String!    //上课地点
        init(dayInWeek:Int,classLowToUp:[Int],name:String,weeks:[Int],teacher:String!,location:String) {
            self.dayInWeek = dayInWeek
            self.classLowToUp = classLowToUp
            self.name = name
            self.weeks = weeks
            self.teacher = teacher
            self.location = location
            print("teacher2:\(teacher)")
        }
    }
    struct gradeChoose {
        static let senior = "大四"
        static let junior = "大三"
        static let sophomore = "大二"
        static let freshman = "大一"
        static let unchoose = "未选择"
    }
    struct majorChoose {
        static let xinwen = "新闻"
        static let guangdian = "广电"
        static let guanggao = "广告"
        static let chuanbo = "传播"
        static let bozhu = "播主"
        static let unchoose = "未选择"
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
