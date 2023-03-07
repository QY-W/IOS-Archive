//
//  ViewController.swift
//  QiyuanWang-Lab4
//
//  Created by W Q on 10/21/22.
//
//   
/// 3D touch: https://www.youtube.com/watch?v=a1Agazw2JxM&ab_channel=iOSAcademy
/// Collection Layout //https://www.youtube.com/watch?v=nPf5X5z0eA4&t=958s&ab_channel=TheSwiftGuy

import UIKit

class ViewController: UIViewController{
//    ,UICollectionViewDelegate

    @IBOutlet weak var collectionView: UICollectionView!
    var theData: [Movie] = []
    var theImageCache: [UIImage] = []
    var favoriteTitle:[String] = []
    var favoriteId:[Int] = []
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var spinnerIndicator: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //collectionView.dataSource = self
        spinnerIndicator.hidesWhenStopped = true
        setupCollectionViewLayout()
        loadDefault()
        
        setupCollectionView()
        searchBar.delegate = self
//        // disatch
//        DispatchQueue.global(qos: .userInitiated).async {
//
//            self.fetchDataForCollectionView(textQuery:"test")
//            self.cacheImages()
//            //after is done
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    

    func setupCollectionViewLayout(){

        let cellWidth = UIScreen.main.bounds.width / 3 - 10
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * 3 / 2)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 50
        layout.footerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        collectionView.collectionViewLayout = layout
    }
    
    func setupCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionMovieCell.self, forCellWithReuseIdentifier: "myCell")
        
    }
    
    func fetchDataForCollectionView(textQuery: String){

        let apiKey:String = "b6b69f707b050d3512d5a46fccb83ad8"
        
        // encoding query user input search
        let apiSearch = textQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let apiSearch = apiSearch else {
            return
        }
        print("query input is\(apiSearch)")
        let apiQuery:String = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=en-US&query=\(apiSearch)&page=1&include_adult=false"
        
        print("url is\(apiQuery)")
        let url = URL(string: apiQuery)
        guard let url = url else {
            spinnerIndicator.stopAnimating()
            return
        }
   
        if let data = try? Data(contentsOf: url){
            if data.count == 0{
                spinnerIndicator.stopAnimating()
                self.showAlert(alertText: "Hello", alertMessage: "World")
                return
            }
            if let someData = try? JSONDecoder().decode(APIResults.self, from: data).results{
                theData = someData
            }
        }
        spinnerIndicator.stopAnimating()
    
    }
    func cacheImages(){
        for item in theData{
            if let posterPath = item.poster_path{
                //let id = item.id
                let urlPrefix = "https://image.tmdb.org/t/p/w500"
                if let url = URL(string: urlPrefix + posterPath) {
                    if let data = try? Data(contentsOf: url){
                        if let image = UIImage(data: data){
                            theImageCache.append(image)
                        }
                    }
                }
            }else{
                // use default image if poster is not available
                let defaultImage = #imageLiteral(resourceName: "ImageDefaultPoster")
                theImageCache.append(defaultImage)
            }
        }
    }
    
    func loadDefault(){
        favoriteTitle = []
        if let anyArray = UserDefaults.standard.array(forKey: "movieTitle"){
            for (item) in anyArray{
                if let item = item as? String{
                    favoriteTitle.append(item)
                }
            }
        }
        if let anyArray = UserDefaults.standard.array(forKey: "movieId"){
            for (item) in anyArray{
                if let item = item as? Int{
                    favoriteId.append(item)
                }
            }
        }
        UserDefaults.standard.set(favoriteId, forKey: "movieId")
        UserDefaults.standard.set(favoriteTitle, forKey: "movieTitle")
    }
    
    func insertDefault(id:Int , title:String){
        favoriteId.append(id)
        favoriteTitle.append(title)
        UserDefaults.standard.set(favoriteId, forKey: "movieId")
        UserDefaults.standard.set(favoriteTitle, forKey: "movieTitle")
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return theImageCache.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? CollectionMovieCell else{
            return UICollectionViewCell()
        }
        // Title 2 line
        cell.movieTitle.text = theData[indexPath.row].title
        cell.movieTitle.numberOfLines = 2
        cell.movieTitle.lineBreakMode = .byTruncatingTail

        cell.movieImage.image = theImageCache[indexPath.row]
        cell.movieId = theData[indexPath.row].id
        
        cell.addSubview(cell.movieImage)
        cell.addSubview(cell.movieTitle)
        cell.backgroundColor = .systemGray3
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // do some initialization
        let detailedVC = DetailedViewController()
        detailedVC.imageName = theData[indexPath.row].title
        detailedVC.image = theImageCache[indexPath.row]
        detailedVC.id = theData[indexPath.row].id
        navigationController?.pushViewController(detailedVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil){_ in
            let favoriteAction = UIAction(title: "Add to Favorite", image: UIImage(systemName: "star"), identifier: nil, discoverabilityTitle: nil, state: .off){
                _ in
                print("Tapped, title is\(self.theData[indexPath.row].title)")
                self.insertDefault(id: self.theData[indexPath.row].id, title: self.theData[indexPath.row].title)
            }
            return UIMenu(title: "Add To Favorite", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [favoriteAction])
        }
        return config
    }
}

extension ViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
                
        if let enteredText = (searchBar.text){
            
            //theData = []
            //clear image cache
            theImageCache = []
            
            self.collectionView.reloadData()
            spinnerIndicator.startAnimating()
            
            print("search text is \(enteredText))")
            
            // dispatch
            DispatchQueue.global(qos: .userInitiated).async {

                self.fetchDataForCollectionView(textQuery: enteredText)
                self.cacheImages()
                //after is done
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            //fetchDataForCollectionView(textQuery: enteredText)
        }
    }
    
}
