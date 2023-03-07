//
//  DisplayView.swift
//  CSE 438S Lab 3
//
//  Created by Michael Ginn on 5/31/21.
//

import UIKit

/**
 YOU MAY NOT MODIFY THIS FILE.
 */

/// A view that can draw many custom items to the screen
final class DrawingView: UIView {
    
    /// An array of the items which should be drawn in the `DrawingView`.
    ///
    /// When you change this array, the view will automatically redraw, no need to manually call.
    var items: [DrawingItem] = [] {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        for item in items {
            item.draw()
        }
    }
    
    /// Returns the topmost item, if there is any, at a given point in the view.
    /// - Parameter location: The point within the view to look at.
    /// - Returns: The topmost (last added) item, or `nil` if there is none.
    func itemAtLocation(_ location: CGPoint) -> DrawingItem? {
        return items.last { $0.contains(point: location) }
    }
}
