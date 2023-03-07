//
//  ARMapViewController.swift
//  BearBurp
//
//  Created by Haoran Song on 11/3/22.
//

import UIKit
import HDAugmentedReality

class ARMapViewController: ARViewController, ARDataSource {
    func ar(_ arViewController: ARViewController, viewForAnnotation annotation: ARAnnotation) -> ARAnnotationView {
        <#code#>
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        super.dataSource = self
        //2
        self.maxVisibleAnnotations = 30
        self.headingSmoothingFactor = 0.05
        //3
        self.setAnnotations(places)
    }


}
