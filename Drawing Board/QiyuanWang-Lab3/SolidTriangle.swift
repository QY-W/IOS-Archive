//
//  SolidTriangle.swift
//  QiyuanWang-Lab3
//
//  Created by W Q on 10/6/22.
//

import UIKit

class SolidTriangle: SolidShape {
    required init(origin: CGPoint, color: UIColor){
        //fatalError("IMPLEMENT THIS")
        super.init(origin: origin, color: color)
        self.kind = "triangle"
    }
    
    override func draw() {
        
        path.removeAllPoints()
        
        // calculating the cord for Equilateral triangle
        let x_diff = radius * 3.squareRoot() / 2
        let y_diff = radius * 3 / 2
        
        //to find the center of a Equilateral triangle
        let centerX = origin.x
        let centerY = origin.y - radius
        
        path.move(to: CGPoint(x: centerX, y: centerY))
        path.addLine(to: CGPoint(x: centerX - x_diff, y: centerY + y_diff))
        path.addLine(to: CGPoint(x: centerX + x_diff, y: centerY + y_diff))
        path.close()
        shapeRotate(angle: angle)
        color.setFill()
        path.fill()
        color.setStroke()
        path.stroke()
    }
}
