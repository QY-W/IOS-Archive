//
//  ViewController.swift
//  QiyuanWang-Lab3
//
//  Created by W Q on 9/29/22.
//

import UIKit
import Foundation
//import ExtensionUsed
class ViewController: UIViewController {

    @IBOutlet weak var canvas: DrawingView!
    @IBOutlet weak var shapeSelector: UISegmentedControl!
    @IBOutlet weak var actionSelector: UISegmentedControl!
    @IBOutlet weak var colorSelector: UISegmentedControl!
    @IBOutlet weak var clearButton: UIButton!

    var currentShape: Shape?
    var shapeIsSolid: Bool = true
    
    @IBOutlet var pinchGesture: UIPinchGestureRecognizer!
    @IBOutlet var rotateGesture: UIRotationGestureRecognizer!
    var shapeToMove: Shape?
    var optionShape = "circle"
    var optionAction = "draw"
    var colorTypes = [#colorLiteral(red: 1, green: 0.7206584811, blue: 0.6217915416, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 1, green: 0.5141333342, blue: 0.544773221, alpha: 1), #colorLiteral(red: 0.5888525248, green: 0.9461932778, blue: 0.7729094625, alpha: 1), #colorLiteral(red: 0.6423185468, green: 0.7368238568, blue: 0.9550125003, alpha: 1)]
    
    //var optionColor = #colorLiteral(red: 1, green: 0.5141333342, blue: 0.544773221, alpha: 1)
    var curColor = #colorLiteral(red: 1, green: 0.7206584811, blue: 0.6217915416, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Fill the color in color segment control programmatically
        // cite: https://sarunw.com/posts/how-to-change-uiimage-color-in-swift/
        for i in 0...colorSelector.numberOfSegments-1{
            //handle potential array out of index
            if colorTypes.count > i {
                let segmentTint = colorTypes[i]
                let segmentImage = UIImage(systemName: "pencil.circle.fill")?.withTintColor(segmentTint, renderingMode: .alwaysOriginal)
                colorSelector.setImage(segmentImage , forSegmentAt: i)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1,
              let touchPoint = touches.first?.location(in: canvas)
        else { return }
        //print("touch point is at \(touchPoint)")
        if (optionAction == "draw"){
            let currentShape = createShape(shapeIsSolid:shapeIsSolid,kind:optionShape, origin:touchPoint, color:curColor)
            print ("draw a \(currentShape.kind )")
            canvas.items.append(currentShape)
        }else{
            // checking if shape exist in canvas
            if ((canvas.items.count == 0)){
                print ("No shape yet")
                return
            }else{
                var lastShapeIndex = -999
                for i in 0...canvas.items.count-1 {
                    if (canvas.items[i].contains(point: touchPoint)){
                        lastShapeIndex = i
                    }
                }
                if (optionAction == "move"){
                    // set the shape to be the move target shape
                    shapeToMove = canvas.itemAtLocation(touchPoint) as? Shape
                    //checking index out of range
                    if 0...canvas.items.count-1 ~= lastShapeIndex{
                        // rearrange the shape to the last of array
                        canvas.items.rearrange(from: lastShapeIndex, to: canvas.items.count-1)
                    }
                }else if (optionAction == "delete"){
                    if 0...canvas.items.count-1 ~= lastShapeIndex{
                        canvas.items.remove(at: lastShapeIndex)
                        print ("Deleted a shape")
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1,
              let touchPoint = touches.first?.location(in: canvas)
        else { return }
        if (optionAction == "move"){
            if let currentShape =  shapeToMove {
                let newShape = createShape(shapeIsSolid:shapeIsSolid,kind: currentShape.kind, origin: touchPoint, color: currentShape.color)
                    currentShape.origin = touchPoint
                    newShape.radius = currentShape.radius
                    canvas.setNeedsDisplay()
            }
        }
    }

    @IBAction func didPinch(_ sender: UIPinchGestureRecognizer) {
        var shapeScale = -999.0
        let originalTouch = sender.location(in: canvas)
        if let tempShape = canvas.itemAtLocation(originalTouch) as? Shape {
            shapeScale = tempShape.radius
            if sender.state == .changed{
                let scale = sender.scale
                if shapeScale > 0{
                    tempShape.radius = shapeScale * scale
                }
                canvas.setNeedsDisplay()
            }
            // set scale to 1 such that framewise it is only updating the delta scale rather than exponentially
            sender.scale = 1
        }

    }
    
    @IBAction func didRotate(_ sender: UIRotationGestureRecognizer) {
        let originalTouch = sender.location(in: canvas)
        if let tempShape = canvas.itemAtLocation(originalTouch) as? Shape {
            tempShape.angle += sender.rotation
            //print("sender rotation is \(sender.rotation)")
            canvas.items = canvas.items.map{$0}
        }
        // set rotation to 0 such that framewise it is only updating the delta rotation rather than quadratically
        sender.rotation = 0.0
    }

    // Segmented Controlls that handle user selections
    @IBAction func switchShape(_ sender: UISegmentedControl) {

        let shapeTypes = ["circle","square","triangle"]
        optionShape = shapeTypes[sender.selectedSegmentIndex]
        print("Shape changes to \(optionShape)")
    }

    @IBAction func switchAction(_ sender: UISegmentedControl) {
        let actionTypes = ["draw","move","delete"]
        optionAction = actionTypes[sender.selectedSegmentIndex]
        print("Action changes to \(optionAction)")
    }
    
    @IBAction func switchSoildOutline(_ sender: Any) {
        shapeIsSolid = !shapeIsSolid
    }
    
    @IBAction func switchColor(_ sender: UISegmentedControl) {
        curColor = colorTypes[sender.selectedSegmentIndex]
        //curColor = optionColor
        print("Color changes to \(curColor)")
    }

    @IBAction func pressClearButton(_ sender: Any) {
        canvas.items = []
    }

    @IBAction func takeScreenshot(_ sender: Any) {
        
        let myImage: UIImage? = UIImage(view: view)
        let canvasCord = canvas.frame.origin;
        let scale = UIScreen.main.scale
        // crop image with rect
        if let myImage = myImage?.cgImage {
            //https://medium.com/@joehattori/cropping-images-in-swift-and-the-basics-of-uiimage-cgimage-and-ciimage-42608e4531bb
            let rect = CGRect(x:0, y: scale * (canvasCord.y),width: scale * canvas.bounds.width, height: scale * canvas.bounds.height)
            guard let croppedCGImage = myImage.cropping(to: rect) else { return  }
            UIImageWriteToSavedPhotosAlbum(UIImage(cgImage: croppedCGImage), nil, nil, nil)
            // Create alert: https://www.appsdeveloperblog.com/how-to-show-an-alert-in-swift/
            let dialogMessage = UIAlertController(title: "Image Saved", message: "Canvas image has been save to photo library", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
             })
            dialogMessage.addAction(okAction)
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    // Helper functions

    func createShape(shapeIsSolid:Bool , kind:String, origin:CGPoint, color:UIColor) -> (Shape) {
        var newShape: Shape
        if shapeIsSolid{
            if kind == "circle"{
                newShape = SolidCircle(origin:origin, color: color)
            }else if kind == "square" {
                newShape = SolidSquare(origin:origin, color: color)
            }else{
                newShape = SolidTriangle(origin:origin, color: color)
            }
        }else{
            if kind == "circle"{
                newShape = OutlineCircle(origin:origin, color: color)
            }else if kind == "square" {
                newShape = OutlineSquare(origin:origin, color: color)
            }else{
                newShape = OutlineTriangle(origin:origin, color: color)
            }
            
        }
        return newShape
    }
    
    @IBAction func pickColor(_ sender: Any) {
        let picker = UIColorPickerViewController()

        // Setting the Initial Color of the Picker
        picker.selectedColor = self.view.backgroundColor ?? #colorLiteral(red: 0.6423185468, green: 0.7368238568, blue: 0.9550125003, alpha: 1)

        // Setting Delegate
        picker.delegate = self

        // Presenting the Color Picker
        self.present(picker, animated: true, completion: nil)
        curColor = picker.selectedColor
    }
}

// Extensions

// Citation: https://stackoverflow.com/questions/25448879/how-do-i-take-a-full-screen-screenshot-in-swift
extension UIImage {
    convenience init?(view: UIView?) {
        guard let view: UIView = view else { return nil }

        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        view.layer.render(in: context)
        let contextImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard
            let image: UIImage = contextImage,
            let pngData: Data = image.pngData()
            else { return nil }
        self.init(data: pngData)
    }
}
extension ViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer:UIGestureRecognizer) -> Bool {
        true
    }
}

// modified from: https://www.swiftpal.io/articles/how-to-use-uicolorpickerviewcontroller-in-swift
extension ViewController: UIColorPickerViewControllerDelegate {
    
    //  Called once you have finished picking the color.
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        curColor = viewController.selectedColor
    }
    //  Called on every color selection done in the picker.
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        curColor = viewController.selectedColor
    }
}
extension UIBezierPath {
    func rotate(by angleRadians: CGFloat){
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: center.x, y: center.y)
        transform = transform.rotated(by: angleRadians)
        transform = transform.translatedBy(x: -center.x, y: -center.y)
        self.apply(transform)
    }
}
// https://stackoverflow.com/questions/36541764/how-to-rearrange-item-of-an-array-to-new-position-in-swift
extension Array {
    mutating func rearrange(from: Int, to: Int) {
        insert(remove(at: from), at: to)
    }
}


