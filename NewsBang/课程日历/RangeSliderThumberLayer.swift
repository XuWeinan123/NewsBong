//
//  RangeSliderThumberLayer.swift
//  CustomSliderExample
//
//  Created by test on 10/21/15.
//  Copyright © 2015 Mrtang. All rights reserved.
//

import UIKit
import QuartzCore

/**集成了CALayer类,用来绘制两个圆圈*/
class RangeSliderThumberLayer: CALayer {
    var highlighted:Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    weak var rangeSlider:RangeSlider?
    
    override func draw(in ctx: CGContext) {
        if let slider = rangeSlider {
            let thumbFrame = self.bounds.insetBy(dx: 2, dy: 2)
            let cornerRadius = thumbFrame.height / 2.0
            let path = UIBezierPath(roundedRect: thumbFrame, cornerRadius: cornerRadius)
            
            let shadowColor = UIColor.gray
            ctx.setShadow(offset: CGSize(width:0,height:1.0), blur: 0.5, color: shadowColor.cgColor)
            ctx.setFillColor(slider.thumbTintColor.cgColor)
            ctx.addPath(path.cgPath)
            ctx.fillPath()
            
            ctx.setStrokeColor(shadowColor.cgColor)
            ctx.setLineWidth(0.5)
            ctx.addPath(path.cgPath)
            ctx.strokePath()
            
            if highlighted {
                ctx.setFillColor(UIColor(white: 0.0, alpha: 0.1).cgColor)
                ctx.addPath(path.cgPath)
                ctx.fillPath()
            }
        }
    }
    
    
}


