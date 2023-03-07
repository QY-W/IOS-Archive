//
//  Functions.swift
//  InClassDemo1
//
//  Created by Todd Sproull on 6/16/20.
//  Copyright © 2020 Todd Sproull. All rights reserved.
//

import UIKit

class Functions {
    
    static func distance(a: CGPoint, b: CGPoint) -> CGFloat {
        return sqrt(pow(a.x - b.x,2) + pow(a.y - b.y,2))
    }
    
}
