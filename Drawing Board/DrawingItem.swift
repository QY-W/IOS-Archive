//
//  DrawingItem.swift
//  CSE 438S Lab 3
//
//  Created by Michael Ginn on 5/31/21.
//

import UIKit

/**
 YOU MAY NOT MODIFY THIS FILE.
 
 You must finish Shape.swift, which implements this protocol.
 */

/// Represents some item (without specifying the type) that can be drawn to the screen.
protocol DrawingItem: AnyObject {
    /// Create an item to be drawn
    /// - Parameters:
    ///   - origin: The origin point
    ///   - color: The color of the item
    init(origin: CGPoint, color: UIColor)
    
    /// Draw the current item to the screen
    func draw()
    
    /// Returns true if the item contains the point
    func contains(point: CGPoint) -> Bool
}
