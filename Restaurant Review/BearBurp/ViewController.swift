//
//  ViewController.swift
//  HaoranSong-Lab4
//
//  Created by Haoran Song on 10/20/22.
//

import UIKit
import SwiftUI

class ViewController: UIViewController{
    
//    var theRestaurant : [Restaurant] = []
//    var theAPIData : APIData?
    
    @IBOutlet weak var sortBtn: UIButton!
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    var theData : restaurantAPIData?
    var theImageCache : [UIImage] = []
    let defaults = UserDefaults.standard
    var sortData : restaurantAPIData?
    var isSort : Bool?
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func refreshBtnClicked(_ sender: Any) {
        addLoadingView()
        DispatchQueue.global(qos: .userInitiated).async {
            self.getDataFromMysql(query: "")
            self.cacheImages()
            
            DispatchQueue.main.async {
                self.removeLoadingView()
                self.collectionView.reloadData()
            }
        }
    }
    
    // Users can sort the movies (by "Release date" or by "Rating")
    @IBAction func sortButton(_ sender: UIButton) {
        sender.showsMenuAsPrimaryAction = true
        sender.menu = UIMenu(children: [
                UIAction(title: "Popularity/Rating", handler: { action in
                    if(self.isSort == true){
                        self.theData = self.sortData
                        self.sortBtn.setTitle(" sorting by popularity", for: .normal)
                        self.isSort = false
                    }else{
                        if(!(self.theData?.message.isEmpty)!){
                            self.theData?.message.sort(by: {$0.rating > $1.rating})
                        }
                        self.sortBtn.setTitle(" sorting by rating", for: .normal)
                        self.isSort = true
                    }
                    
                    self.theImageCache = []
                    self.cacheImages()
                    self.collectionView.reloadData()
                })
            ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        self.title = "BearBurp"
        searchBar.delegate = self
        setupCollectionView()
        refreshControl.addTarget(self, action: #selector(ViewController.refreshData),
                                 for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        collectionView.addSubview(refreshControl)
        addLoadingView()
        DispatchQueue.global(qos: .userInitiated).async {
            self.getDataFromMysql(query: "")
            self.cacheImages()
            DispatchQueue.main.async {
                self.removeLoadingView()
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func refreshData() {
        setupCollectionView()
        getDataFromMysql(query: "")
        cacheImages()
        collectionView.reloadData()
        refreshControl.endRefreshing()
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
    
    func setupCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "mycell")
    }
    
    func getDataFromMysql(query: String){
        var url:URL?
        
        var myQuery = query.removeSpecialCharacters().condensedWhitespace
        myQuery = myQuery.unicodeScalars
            .filter { !$0.properties.isEmojiPresentation }
            .reduce("") { $0 + String($1) }
        
        // fetch data from mysql
        do{
            url = URL(string: "http://3.86.178.119/~Charles/CSE438-final/fetchdata.php?&query=\(myQuery)")
            let data = try Data(contentsOf: url!)
            theData = try! JSONDecoder().decode(restaurantAPIData.self,from:data)
            
            // for sort button
            sortData = theData
            isSort = false
        }
        catch{
            print("error")
        }

    }
    
    func cacheImages(){
        theImageCache = []
        for item in theData?.message ?? [] {
            if(item.image_url==""){
                theImageCache.append(UIImage(named: "empty")!)
            }else{
                let url = URL(string: item.image_url)
                do{
                    let data = try Data(contentsOf: url!)
                    let image = UIImage(data: data)
                    theImageCache.append(image!)
                }catch{
                    theImageCache = []
                }

            }
        }
    }
    
    

}

extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        let query = searchBar.text
        addLoadingView()
        DispatchQueue.global(qos: .userInitiated).async {
            self.getDataFromMysql(query: query ?? "")
            self.cacheImages()
            
            DispatchQueue.main.async {
                self.removeLoadingView()
                self.collectionView.reloadData()
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return theData?.message.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mycell", for: indexPath)
        
        
        let imageview:UIImageView=UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width-3, height: 120));
        
        imageview.image = theImageCache[indexPath.item]
        
//        imageview.layer.masksToBounds = true
//        imageview.layer.cornerRadius = 20
//        imageview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let title = UILabel(frame: CGRect(x: 0, y: 120, width: view.frame.size.width/2 - 3, height: 30))
        title.text = theData?.message[indexPath.item].name
        title.font = UIFont(name: "Helvetica", size: CGFloat(14))
        imageview.addSubview(title)
        
        let rate = UILabel(frame: CGRect(x: 280, y: 120, width: view.frame.size.width/2 - 3, height: 30))
        let vote = theData?.message[indexPath.item].rating ?? 0.0
        let rateString = "Vote Average: \(vote)"
        let mString = NSMutableAttributedString(string: rateString)
        if(vote>=7.5){
            mString.setAttributes(
                [NSAttributedString.Key.foregroundColor : UIColor(red: 1.00, green: 0.73, blue: 0.20, alpha: 1.00)],
                range: NSRange(location: 14, length: mString.string.count - 14)
            )
        }else if(vote<6){
            mString.setAttributes(
                [NSAttributedString.Key.foregroundColor : UIColor(red: 1.00, green: 0.20, blue: 0.20, alpha: 1.00)],
                range: NSRange(location: 14, length: mString.string.count - 14)
            )
        }else{
            mString.setAttributes(
                [NSAttributedString.Key.foregroundColor : UIColor(red: 0.36, green: 0.84, blue: 0.36, alpha: 1.00)],
                range: NSRange(location: 14, length: mString.string.count - 14)
            )
        }
        rate.attributedText = mString
        rate.font = UIFont(name: "Helvetica", size: CGFloat(12))
        imageview.addSubview(rate)
        cell.contentView.subviews.forEach {$0.removeFromSuperview()}
        UIView.transition(with: cell.contentView, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            cell.contentView.addSubview(imageview)
        }, completion: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: view.frame.size.width-3,
            height: view.frame.size.width/3
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // spacing between rows
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let detailedCV = self.storyboard?.instantiateViewController(withIdentifier: "detail") as! DetailViewController
        detailedCV.image = theImageCache[indexPath.row]
        detailedCV.restaurant = theData?.message[indexPath.row]
        navigationController?.pushViewController(detailedCV, animated: true)
    }
    
    // Implement a Context Menu
    func collectionView(_ collectionView: UICollectionView,contextMenuConfigurationForItemAt indexPath: IndexPath,point: CGPoint) -> UIContextMenuConfiguration? {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
                return self.makeContextMenu(for:(self.theData?.message[indexPath.row])!)
        }
    }
    
    func makeContextMenu(for restaurant:Restaurant) -> UIMenu {

        // Create a UIAction for favoriting
        let favorite = UIAction(title: "Favorite", image: UIImage(systemName: "star")) { action in
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(restaurant) {
                self.defaults.set(encoded, forKey: "Favorite_\(restaurant.id)")
            }
        }
        
        // Create and return a UIMenu with the favorite action
        return UIMenu(title: "", children: [favorite])
    }
    
}
// Reference:  https://stackoverflow.com/questions/56984247/swift-how-to-remove-special-character-without-remove-emoji-from-string
extension String {
    var condensedWhitespace: String {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }

    func removeSpecialCharacters() -> String {
        let okayChars = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890 ")
        return String(self.unicodeScalars.filter { okayChars.contains($0) || $0.properties.isEmoji })
    }
}



