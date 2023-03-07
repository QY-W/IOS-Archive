//
//  movieCell.swift
//  QiyuanWang-Lab4
//
//  Created by W Q on 10/25/22.
//

import UIKit

class CollectionMovieCell: UICollectionViewCell {
    //@IBOutlet weak var myImageView: UIView!
//    @IBOutlet weak var movieImage: UIImageView!

    // image : 500X750, x: y is 2: 3
    let imageWidth = UIScreen.main.bounds.width / 3 - 10
    
    let movieImage = UIImageView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width / 3 - 10), height: (UIScreen.main.bounds.width / 3 - 10) * 3 / 2))
    let movieTitle = UILabel(frame: CGRect(x: 0, y: (UIScreen.main.bounds.width / 3 - 10) * 3 / 2, width: (UIScreen.main.bounds.width / 3 - 10), height: 45))

//    var movieTitle:UILabel {
//        let lbl = UILabel(frame: CGRect(x: 0, y: (UIScreen.main.bounds.width / 3 - 10) * 3 / 2, width: (UIScreen.main.bounds.width / 3 - 10), height: 45))
//        lbl.text = "Default Title"
//        lbl.backgroundColor = .systemGray2
//        return lbl
//    }
    
    
    var movieId: Int = -1
    
    
//    required init() {
//        let movieImage = UIImageView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width / 3 - 10), height: (UIScreen.main.bounds.width / 3 - 10) * 3 / 2))
//        let movieTitle = UILabel(frame: CGRect(x: 0, y: (UIScreen.main.bounds.width / 3 - 10) * 3 / 2, width: (UIScreen.main.bounds.width / 3 - 10), height: 45))
//        var movieId: Int = -1
//    }
//    let movieTitle = UILabel()
//    movieTitle.text = "Default title"
//    movieTitle.numberOfLines = 2
//    movieTitle.lineBreakMode = .byWordWrapping

}
