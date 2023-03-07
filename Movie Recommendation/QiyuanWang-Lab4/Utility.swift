//
//  Utility.swift
//  QiyuanWang-Lab4
//
//  Created by W Q on 10/28/22.
//

import Foundation
import UIKit

// Used for search query
struct APIResults:Decodable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Movie]
}
struct Movie: Decodable {
    let id: Int!
    let poster_path: String?
    let title: String
    let release_date: String?
    let vote_average: Double
    let overview: String
    let vote_count:Int!
}

// For detail query
struct MovieDetail:Decodable{
    let overview: String?
    let vote_average:Double?
    let popularity: Double?
}

// For video trailer query
struct APIVideo:Decodable{
    let id:Int
    let results:[MovieVideo]

}
struct MovieVideo:Decodable{
    let site: String?
    let key:String?
}

// Adjust Label Height to fit content
///https://stackoverflow.com/questions/25180443/adjust-uilabel-height-to-text
extension UILabel
{
var optimalHeight : CGFloat
    {
        get
        {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = 0
            label.lineBreakMode = self.lineBreakMode
            label.font = self.font
            label.text = self.text

            label.sizeToFit()

            return label.frame.height
         }
    }
}

func resetHeight (labelToResize:UILabel){
    labelToResize.frame.size.height = labelToResize.optimalHeight
    labelToResize.lineBreakMode = .byWordWrapping
    /// setting 0 will automaticlly adjust line numbers
    labelToResize.numberOfLines = 0
}

//API useage
//Search:
//https://developers.themoviedb.org/3/search/search-movies
//Detail
//https://developers.themoviedb.org/3/movies/get-movie-details
//Video
//https://developers.themoviedb.org/3/movies/get-movie-videos


// Locate the last view's maxY
func getLastSubviewY(view: UIView)->CGFloat{
    return view.subviews.last?.frame.maxY ?? 0
}

//https://medium.com/@Archetapp/an-extension-that-shows-a-basic-alert-swift-f0d250224e8c
extension UIViewController {
//Show a basic alert
    func showAlert(alertText : String, alertMessage : String) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        //Add more actions as you see fit
        self.present(alert, animated: true, completion: nil)
    }
}
