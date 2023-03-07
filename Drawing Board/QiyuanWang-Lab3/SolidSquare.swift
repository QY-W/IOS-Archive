//
//  SolidSquare.swift
//  QiyuanWang-Lab3
//
//  Created by W Q on 10/6/22.
//

import UIKit

class SolidSquare: SolidShape {

    required init(origin: CGPoint, color: UIColor){
        //fatalError("IMPLEMENT THIS")
        super.init(origin: origin, color: color)
        self.kind = "square"
    }
    
    override func draw() {
        path.removeAllPoints()
        let rectLeng = 2.squareRoot() * radius
        path.append(UIBezierPath(rect: CGRect(x: origin.x - rectLeng/2 , y: origin.y - rectLeng/2, width: rectLeng, height: rectLeng)))
        // rotation need to be applied after shape is drawn
        shapeRotate(angle: angle)
        path.close()
        color.setFill()
        color.setStroke()
        path.stroke()
        
        path.fill()
    }
}

