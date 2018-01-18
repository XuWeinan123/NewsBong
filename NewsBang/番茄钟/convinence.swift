//
//  content.swift
//  25分
//
//  Created by blues on 15/12/11.
//  Copyright © 2015年 blues. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

let shortMusicDirPath = "/Bgm/ShortMusic"
func formatToDisplayTime(currentTime:Int) -> String{
    let min = currentTime / 60
    let second = currentTime % 60
    let time = String(format: "%02d:%02d", arguments: [min,second])
    return time
}
struct timerState {
    static let start = "开始"
    static let giveUp = "放弃"
    static let workingComplete = "完成工作"
    static let restComplete = "休息完了"
    static let rest = "休息"
    static let updating = "时间更新中"
}
