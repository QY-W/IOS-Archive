//
//  Shape.swift
//  CSE 438S Lab 3
//
//  Created by Michael Ginn on 5/31/21.
//

import UIKit

/**
 YOU SHOULD MODIFY THIS FILE.
 
 Feel free to implement it however you want, adding properties, methods, etc. Your different shapes might be subclasses of this class, or you could store information in this class about which type of shape it is. Remember that you are partially graded based on object-oriented design. You may ask TAs for an assessment of your implementation.
 */

/// A `DrawingItem` that draws some shape to the screen.
class Shape: DrawingItem {
    var origin: CGPoint
    var color: UIColor
    // Raidus: Radius of circle or radius of circumcircle for the square or triangle
    var radius: CGFloat = 100.0;
    var kind : String =  "cirlce" 
    var angle: CGFloat = 0.0
    var path = UIBezierPath()
    
    
    
    public required init(origin: CGPoint, color: UIColor){
        self.origin = origin
        self.color = color
    }
    
    func draw() {
        // Fuction is implemented in each subclass
    }
    
    func contains(point: CGPoint) -> Bool {
        //fatalError("IMPLEMENT THIS")
        //self.contains(point: point)
        if (path.contains(point)){
            return true
        }else{
            return false
        }
    }
    // adapeted from: https://piazza.com/class/l77ttghofcl355/post/135
    func shapeRotate(angle: CGFloat){
        let center = origin
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: center.x, y: center.y)
        transform = transform.rotated(by: angle)
        transform = transform.translatedBy(x: -center.x, y: -center.y)
        path.apply(transform)
        
    }
}

