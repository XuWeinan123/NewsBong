//
//  RangeSliderTrackLayer.swift
//  CustomSliderExample
//
//  Created by test on 10/22/15.
//  Copyright © 2015 Mrtang. All rights reserved.
//

import UIKit
import QuartzCore

/**绘制条子*/
class RangeSliderTrackLayer: CALayer {
    weak var rangeSlider:RangeSlider?
    
    override func draw(in ctx: CGContext) {
        if let slider = rangeSlider {
            //绘制一个闭合曲线,有圆角
            let cornerRadius = self.bounds.height / slider.curvaceousness / 2.0
            let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius)
            ctx.addPath(path.cgPath)
            
            //为曲线添加颜色
            ctx.setFillColor(slider.trackTintColor.cgColor)
            ctx.addPath(path.cgPath)
            ctx.fillPath()  //为曲线内部着色
            
            
            /*
             CGContextSetStrokeColorWithColor(ctx, UIColor.redColor().CGColor)
             CGContextAddPath(ctx, path.CGPath)
             CGContextStrokePath(ctx) //只为曲线着色
             */
            
            
            //为四边形内铺颜色
            ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
            let lowThumberPosition = CGFloat(slider.positionForValue(value: slider.lowerValue))
            let upperThumberPosition = CGFloat(slider.positionForValue(value: slider.upperValue))
            let rect = CGRect(x:lowThumberPosition, y: 0, width: upperThumberPosition - lowThumberPosition, height: bounds.height)
            ctx.fill(rect)
        }
    }
}

