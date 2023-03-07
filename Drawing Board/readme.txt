
Extra credit:
Shape has two subclass OutlineShape and SolidShape
Two Home Screen actions is implemented

Creative Feature
1. What you implemented
    a.  A comprehensive color choosing system
        Use guide: tap the pick color button in the center of header

        1. Variety ways of color selection:
            It can pick from grid, or take color from spectrum and also a slider of RGB values
        2. Can adjust opacity.
        3. Come with preset colors
        4. a eyedropper selector that can take color from screen
        5. color and opacity is not altered when moved, rotated or pinched

    b.  Saving the current drawing to the photos library–must be implemented in a way that only saves the drawing, WITHOUT the interface controls.
        Use guide: tap the  button in the right of header


2. How you implemented it
    a.
        add an extension as a ViewController: UIColorPickerViewControllerDelegate object.
        implement support functions that detect states and set current color
        utilize built-in UIColorPickerViewController UI to present

    c.
        first take a screenshot the whole screen.
        Then calculate the scale and canvas(drawing view item) cord
        crop the full screen shot with canvas bound, scale and canvas y
        save wanted current drawing to photo library
        sent a user alert to user to remind the user if photo is saved


3. Why you implemented it
    a. In a drawing app, color is very crucial component. With different ways of selecting color, user can better get the color they want.
        An eyedropper pick enable user to create color with mixing two semi-transparent colors. Improve user experience

    b. A drawing saving feature enable user to keep track of their works. A built-in photo-saving feature help user to better saving their painting.
    Not need to manual take screenshot then crop.