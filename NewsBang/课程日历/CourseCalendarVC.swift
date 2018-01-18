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
    var courseItems = [CourseItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        startDate = numberToDate(year: 2018, month: 1, day: 15)
        //"2018-01-15"
        courseItems.append(CourseItem.init(dayInWeek: 6, classLowToUp: [1,12], name: "哈哈哈", weeks: [1], teacher: "哈哈老师", location: "东九"))
        
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
                print("granted \(granted)")
                print("error  \(error)")
                /*
                // 新建一个事件
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = "新增一个测试事件"
                event.startDate = self.numberToDate(year: 2018, month: 1, day: 18)
                event.endDate = Date.init(timeInterval: 60*60, since: event.startDate)
                event.notes = "这个是备注"
                event.location = "东九楼"
                //event.addAlarm(EKAlarm.init(relativeOffset: 1000))
                event.calendar = tempCalendar
                do{
                    try eventStore.save(event, span: .thisEvent)
                    print("Saved Event")
                }catch{}*/
                
                
                let events = self.switchCourseItemToEvent(courseItem: self.courseItems[0], eventStore: eventStore, calendar: tempCalendar)
                print("events的数量\(events.count)")
                for event in events{
                    do{
                        try eventStore.save(event, span: .thisEvent)
                        print("Saved Event")
                    }catch{
                        print("醋味：\(error)")
                    }
                }
            }
        })
        // Do any additional setup after loading the view.
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
            let dates = inferDates(week: tempCourseItem.weeks[i],
                                   dayInWeek: tempCourseItem.dayInWeek,
                                   classLowToUp: tempCourseItem.classLowToUp,
                                   startDate: startDate,
                                   isSummer: true)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
