//
//  AnnotationView.swift
//  BearBurp
//
//  Created by Haoran Song on 11/3/22.
//

import UIKit
import HDAugmentedReality
import SwiftUI

protocol AnnotationViewDelegate {
  func didTouch(annotationView: AnnotationView)
}

class AnnotationView: ARAnnotationView {

    var delegate: AnnotationViewDelegate?
    var foods : foodAPIData?
    let tableView = UITableView()
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchFood()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func loadUI() {
        self.frame = CGRect(x: 0, y: 0, width: 200, height: 55)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.subviews.forEach({ $0.removeFromSuperview()})
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 180, height: 30))
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.textColor = UIColor.black
        self.addSubview(label)
        label.alpha = 0.0
        UIView.animate(withDuration: 0.5) {
            label.alpha = 1.0
            self.layoutIfNeeded()
        }

        let rateStar = UILabel(frame: CGRect(x: 10, y: 30, width: 180, height: 20))
        self.addSubview(rateStar)
        rateStar.alpha = 0.0
        UIView.animate(withDuration: 0.5) {
            rateStar.alpha = 1.0
            self.layoutIfNeeded()
        }

        let distanceLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 180, height: 30))
        distanceLabel.backgroundColor = .clear
        distanceLabel.textAlignment = .right
        distanceLabel.textColor = UIColor(red: 1.00, green: 0.13, blue: 0.09, alpha: 1.00)
        distanceLabel.font = UIFont.boldSystemFont(ofSize: 14)
        self.addSubview(distanceLabel)
        distanceLabel.alpha = 0.0
        UIView.animate(withDuration: 0.5) {
            distanceLabel.alpha = 1.0
            self.layoutIfNeeded()
        }

        if let annotation = annotation as? Place {
          label.text = annotation.placeName
          distanceLabel.text = String(format: "%.2f km", annotation.distanceFromUser / 1000)
          rateStar.attributedText = NSMutableAttributedString().starWithRating(rating: Float(round(annotation.rateNum)), outOfTotal: 10, withFontSize: 14.0)
        }
    }

    func loadDetailView(){
        self.subviews.forEach({ $0.removeFromSuperview()})
        tableView.frame = CGRect(x: 0, y: 0, width: 300, height: 295)
        tableView.backgroundColor = .clear
        self.addSubview(tableView)
        tableView.alpha = 0.0
        UIView.animate(withDuration: 0.5) {
            self.tableView.alpha = 1.0
            self.layoutIfNeeded()
        }
    }

    func fetchFood(){
        var url:URL?
        if let annotation = annotation as? Place {
            let rid = annotation.rid
            url = URL(string: "http://3.86.178.119/~Charles/CSE438-final/fetchfood.php?&rid=\(rid)")
            let data = try! Data(contentsOf: url!)
            foods = try! JSONDecoder().decode(foodAPIData.self,from:data)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        loadDetailView()
    }

}

// Reference: https://stackoverflow.com/questions/16100378/is-there-any-controls-available-for-star-rating
extension NSMutableAttributedString{

    func starWithRating(rating:Float, outOfTotal totalNumberOfStars:NSInteger, withFontSize size:CGFloat) ->NSAttributedString{


        let currentFont = UIFont(name: "Futura", size: size)!

        let activeStarFormat = [ NSAttributedString.Key.font:currentFont, NSAttributedString.Key.foregroundColor: UIColor(red: 1.00, green: 0.64, blue: 0.10, alpha: 1.00)];

        let inactiveStarFormat = [ NSAttributedString.Key.font:currentFont, NSAttributedString.Key.foregroundColor: UIColor.lightGray];

        let starString = NSMutableAttributedString()

        for i in 0...totalNumberOfStars-1{

            if(rating >= Float(i+1)){

                starString.append(NSAttributedString(string: "\u{2605}", attributes: activeStarFormat))
            }else{
                starString.append(NSAttributedString(string: "\u{2605}", attributes: inactiveStarFormat))
            }
        }

        return starString
    }
}

extension AnnotationView:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods!.message.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel!.text = foods?.message[indexPath.row].name
        cell.detailTextLabel!.text = "$ \(foods?.message[indexPath.row].price ?? 0.0)"
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        cell.textLabel?.textColor = .black
        cell.detailTextLabel?.textColor = .black
        cell.backgroundColor = .clear
        let view = UIView()
        view.backgroundColor = .clear
        cell.selectedBackgroundView = view

        if let content = cell.textLabel!.text{
            if content.count > 25{
                cell.textLabel!.text = String(content.prefix(25)) + "..."
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadUI()
    }
}

