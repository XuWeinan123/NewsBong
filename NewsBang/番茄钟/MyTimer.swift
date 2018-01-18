//
//  Timer.swift
//  NewsBang
//
//  Created by 徐炜楠 on 2018/1/17.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit

protocol timerDelegate {
    func updateingTime(currentTime:Int)
    func timerStateToController(timerWillState:String)
}
class MyTimer: NSObject {
    var timerCurrentState = timerState.giveUp
    var fireTime = 25 * 60
    var restFireTime = 5 * 60
    var duractionTime = 25 * 60
    var fireDate:NSDate!
    var currentTime = 60 * 25
    var time:Timer!
    var timerWillState = timerState.start
    
    var delegate:timerDelegate?
    
    static var shareInstance = MyTimer()
    
    override init() {
        super.init()
        print("计时器初始化成功")
        self.time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeUp), userInfo: nil, repeats: true)
    }
    func timerAction(){

        switch timerCurrentState {
        case timerState.giveUp:
            print("give up")
        case timerState.start:
            //设置计时器
            delegate?.timerStateToController(timerWillState: timerState.giveUp)
            timerWillState = timerState.giveUp
            print("starting")
        case timerState.rest:
            //设置计时器
            delegate?.timerStateToController(timerWillState: timerState.giveUp)
            timerWillState = timerState.giveUp
            print("starting")
        default:
            print("error:\(timerCurrentState)")
        }
    }
    func timerWillAction(){
        switch timerWillState{
        case timerState.start:
            timerCurrentState = timerState.start
            currentTime = fireTime
            //设置fireDate
            fireDate = NSDate(timeIntervalSinceNow: Double(fireTime))
            delegate?.timerStateToController(timerWillState: timerState.giveUp)
            timerWillState = timerState.giveUp
            
            currentTime -= 1
            delegate?.updateingTime(currentTime: currentTime)
        case timerState.giveUp:
            self.currentTime = fireTime
            self.timerCurrentState = timerState.giveUp
            delegate?.timerStateToController(timerWillState: timerState.start)
            timerWillState = timerState.start
        case timerState.rest:
            timerCurrentState = timerState.rest
            fireDate = NSDate(timeIntervalSinceNow: Double(restFireTime))
            currentTime = restFireTime
            delegate?.timerStateToController(timerWillState: timerState.giveUp)
            timerWillState = timerState.giveUp
            
            currentTime -= 1
            delegate?.updateingTime(currentTime: currentTime)
        case timerState.workingComplete:
            delegate?.timerStateToController(timerWillState: timerState.workingComplete)
            timerWillState = timerState.rest
            duractionTime = restFireTime
        case timerState.restComplete:
            delegate?.timerStateToController(timerWillState: timerState.restComplete)
            timerWillState = timerState.start
            duractionTime = fireTime
        default:
            print("not have this timerState\(timerWillState)")
            
        }
    }
    @objc func timeUp(timer:Timer){
        //运行
        //print("初始化的时候就在跑了 \(timerCurrentState)")
        if timerCurrentState == timerState.giveUp{
            return
        }
        delegate?.updateingTime(currentTime: currentTime)
        if currentTime > 0{
            currentTime -= 1
            //configNowPlaying(Double(duractionTime - currentTime), fireTime: Double(self.duractionTime))
        }else if timerCurrentState == timerState.start{
            timerCurrentState = timerState.giveUp
            timerWillState = timerState.workingComplete
            timerWillAction()
        }else if timerCurrentState == timerState.rest{
            timerCurrentState = timerState.giveUp
            timerWillState = timerState.restComplete
            timerWillAction()
        }
    }
}
