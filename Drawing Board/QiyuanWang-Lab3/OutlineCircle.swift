//
//  SolidCircle.swift
//  QiyuanWang-Lab3
//
//  Created by W Q on 10/6/22.
//

import UIKit

class OutlineCircle: OutlineShape {
    
    required init(origin: CGPoint, color: UIColor){
        //fatalError("IMPLEMENT THIS")
        super.init(origin: origin, color: color)
        self.kind = "circle"
    }
    
    override func draw() {
        path.removeAllPoints()
        
        path.addArc(withCenter: origin, radius: radius    , startAngle: 0, endAngle: CGFloat(Float.pi * 2), clockwise: true)
        shapeRotate(angle: angle)
        path.close()
        //color.setFill()
        //path.fill()
        color.setStroke()
        path.stroke()

    }
}
