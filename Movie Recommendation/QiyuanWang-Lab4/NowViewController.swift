//
//  NowViewController.swift
//  QiyuanWang-Lab4
//
//  Created by W Q on 10/30/22.
//

import UIKit

class NowViewController: UIViewController {
    
    var theData: [Movie] = []
    var theImageCache: [UIImage] = []
    //@IBOutlet weak var navigationViewNow: UINavigationItem!
    @IBOutlet weak var spinnerNow: UIActivityIndicatorView!
    
    @IBOutlet weak var collectionViewNow: UICollectionView!
    var favoriteTitle:[String] = []
    var favoriteId:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCollectionViewLayout()
        fetchDataForCollectionViewPlayNow()
        loadDefault()

        setupCollectionView()
        collectionViewNow.reloadData()

        DispatchQueue.global(qos: .userInitiated).async { [self] in

            self.spinnerNow.startAnimating()
            

            self.fetchDataForCollectionViewPlayNow()
            self.cacheImages()
            
            //after is done
            DispatchQueue.main.async {
                self.collectionViewNow.reloadData()
                print("Count is: \(self.theImageCache.count)")
            }
            self.spinnerNow.stopAnimating()
            self.spinnerNow.isHidden = true
        }
        
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
        collectionViewNow.collectionViewLayout = layout
    }
    
    func setupCollectionView(){
        collectionViewNow.dataSource = self
        collectionViewNow.delegate = self
        collectionViewNow.register(CollectionMovieCell.self, forCellWithReuseIdentifier: "myCell")
        
    }
    
    func fetchDataForCollectionViewPlayNow(){

        let apiKey:String = "b6b69f707b050d3512d5a46fccb83ad8"
        let apiQuery:String = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&language=en-US&page=1"
        let url = URL(string: apiQuery)
        guard let url = url else {
            return
        }
        let data = try! Data(contentsOf: url)
        
        if data.count == 0{
            print("No Data")
        }
        theData = try! JSONDecoder().decode(APIResults.self, from: data).results
        //spinnerIndicator.stopAnimating()
    }
    func insertDefault(id:Int , title:String){
        favoriteId.append(id)
        favoriteTitle.append(title)
        UserDefaults.standard.set(favoriteId, forKey: "movieId")
        UserDefaults.standard.set(favoriteTitle, forKey: "movieTitle")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension NowViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return theImageCache.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! CollectionMovieCell
        
        cell.movieTitle.text = theData[indexPath.row].title
        
        cell.movieTitle.numberOfLines = 2
        cell.movieTitle.lineBreakMode = .byTruncatingTail
        
        //print("Title: \(theData[indexPath.row].title)")
        cell.movieImage.image = theImageCache[indexPath.row]
        cell.movieId = theData[indexPath.row].id
        
        //print("ID: \(theData[indexPath.row].id)")
        
        //cell.movieImage.image = theData[indexPath.row].title//theImageCache[indexPath.row]
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
        // push nav controller
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
