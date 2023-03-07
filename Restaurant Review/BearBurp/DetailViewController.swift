//
//  DetailViewController.swift
//  HaoranSong-Lab4
//
//  Created by Haoran Song on 10/22/22.
//

import UIKit
import HDAugmentedReality
import CoreLocation
import SwiftUI

class DetailViewController: UIViewController{
    
    var restaurant : Restaurant!
    var image : UIImage!
    var foods : foodAPIData?
    let defaults = UserDefaults.standard
    fileprivate var arViewController: ARViewController!
    
    @IBOutlet weak var restaurantTableView: UITableView!
    @IBOutlet weak var restaurantRate: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var directionBtn: UIButton!
    @IBOutlet weak var reviewBtn: UIButton!
    
    
    
    
    @IBAction func directionARView(_ sender: Any) {
        arViewController = ARViewController()
        arViewController.dataSource = self
        let lat = CLLocationDegrees(restaurant.latitude)
        let lon = CLLocationDegrees(restaurant.longitude)
        let name = restaurant.name
        let loc = CLLocation(latitude: lat, longitude: lon)
        let id = restaurant.id
        let place = Place(location: loc, rate: restaurant.rating, name: name, address: "",id: id)
        arViewController.setAnnotations([place])
            
        self.present(arViewController, animated: true, completion: nil)
    }
    @IBAction func favoriteBtnClicked(_ sender: Any) {
        if(defaults.object(forKey: "Favorite_\(restaurant.id)") == nil){
            
            let encoder = JSONEncoder()
            let defaults = UserDefaults.standard
            
            if let encoded = try? encoder.encode(restaurant) {
                defaults.set(encoded, forKey: "Favorite_\(restaurant.id)")
            }
            
//            favoriteBtn.setTitle(" Liked", for: .normal)
            favoriteBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else{
            defaults.removeObject(forKey: "Favorite_\(restaurant.id)")
//            favoriteBtn.setTitle(" Like", for: .normal)
            favoriteBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    @IBOutlet weak var restaurantImages: UIImageView!
    @IBAction func reviewClicked(_ sender: Any) {
        let reviewVC = self.storyboard?.instantiateViewController(withIdentifier: "review") as! ReviewViewController
        reviewVC.restaurant = restaurant
        navigationController?.pushViewController(reviewVC, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        addLoadingView()
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchFood()
            DispatchQueue.main.async {
                self.viewSetUp()
                self.removeLoadingView()
                self.restaurantTableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLikedButton()
    }
    
    func addLoadingView(){
        let loadingView: LoadingView = LoadingView(frame: CGRect(x: view.frame.size.width/2-50, y: view.frame.size.height/2-50, width: 100, height: 100))

        loadingView.backgroundColor = UIColor(displayP3Red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 0.3)
        UIView.transition(with: view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(loadingView)
        }, completion: nil)
    }
    
    func removeLoadingView(){
        for item in view.subviews {
            if item.isKind(of: LoadingView.self) {
                UIView.transition(with: view, duration: 1, options: [.transitionCrossDissolve], animations: {
                  item.removeFromSuperview()
                }, completion: nil)
            }
        }
    }
    
    func viewSetUp(){
        restaurantTableView.dataSource = self
        restaurantTableView.delegate = self
        view.backgroundColor = .white
        restaurantImages.image = image
        restaurantImages.contentMode = .scaleToFill
        restaurantName.text = restaurant.name
        restaurantRate.text = String(restaurant.rating)
    }
    
    func setLikedButton(){
        // set favorite btn
        if(UserDefaults.standard.object(forKey: "Favorite_\(restaurant.id)") != nil){
            favoriteBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else{
            favoriteBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        favoriteBtn.setTitleColor(.black, for: .normal)
        favoriteBtn.tintColor = .red
        favoriteBtn.backgroundColor = .white
        let favoriteButtonFrame = CGRect(x: 285, y: 293, width: 100, height: 31)
        favoriteBtn.frame = favoriteButtonFrame
        favoriteBtn.layer.cornerRadius = 10
        favoriteBtn.layer.masksToBounds = true
    }
    
    func fetchFood(){
        var url:URL?
        url = URL(string: "http://3.86.178.119/~Charles/CSE438-final/fetchfood.php?&rid=\(restaurant.id)")
        let data = try! Data(contentsOf: url!)
        foods = try! JSONDecoder().decode(foodAPIData.self,from:data)
    }
}

extension DetailViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods!.message.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel!.text = foods?.message[indexPath.row].name
        cell.detailTextLabel!.text = "$ \(foods?.message[indexPath.row].price ?? 0.0)"
        
        if let content = cell.textLabel!.text{
            if content.count > 30{
                cell.textLabel!.text = String(content.prefix(30)) + "..."
            }
        }
        return cell
    }
}

extension DetailViewController: ARDataSource {
  func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
      let annotationView = AnnotationView()
      annotationView.annotation = viewForAnnotation
      annotationView.delegate = self
      annotationView.backgroundColor = .clear
      annotationView.layer.cornerRadius = 10
      annotationView.layer.borderWidth = 1
      annotationView.layer.borderColor = UIColor(named: "black")?.cgColor
      annotationView.frame = CGRect(x: 0, y: 0, width: 200, height: 55)
//      annotationView.restaurant = restaurant
      annotationView.loadUI()
      return annotationView
  }
}
extension DetailViewController: AnnotationViewDelegate {
    func didTouch(annotationView: AnnotationView) {
        
    }
}







