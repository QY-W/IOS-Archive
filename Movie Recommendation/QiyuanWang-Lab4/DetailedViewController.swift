//
//  DetailedViewController.swift
//  QiyuanWang-Lab4
//
//  Created by W Q on 10/25/22.
//

import UIKit
import WebKit

class DetailedViewController:UIViewController {

    
    
    var image: UIImage!
    var imageName: String!
    let imageRatio:CGFloat = 750 / 500
    var id = -1
    //
    var displayOverView = "Overview not available"
    var displayVoteAvg = "No Data"
    var displayPopularity = "No Data"
    let apiKey:String = "b6b69f707b050d3512d5a46fccb83ad8"
    var videoKey:String = ""
    
    var favoriteTitle:[String] = []
    var favoriteId:[Int] = []
    // used for recommdation movies
    var theData: [Movie] = []
    var theImageCache: [UIImage] = []
    let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let collectionView = UICollectionView(frame:CGRect(x: 0, y: 0, width: 0, height: 300), collectionViewLayout: UICollectionViewFlowLayout())
    let favoriteButton = UIButton(frame: CGRect(x: 30, y: 0 , width: 30, height: 30 ))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = #colorLiteral(red: 0.9121729136, green: 0.9247624278, blue: 0.9571543336, alpha: 1)

        fetchDataForTrailer(id: id)
        fetchDataForDeailVC(id: id)
        
        loadDefault()
        setUIObjects()
        
        fetchDataForRecommendation(id:id)
        cacheImages()
        if theImageCache.count > 0{
            setupCollectionView()
            setRecommendationUI()
        }
    }
    
    func setUIObjects(){
        
        //scroll view
        let scrollViewFrame = CGRect(x: 0, y: 0, width: view.frame.width - 2 * 0, height: view.safeAreaLayoutGuide.layoutFrame.size.height)
        scrollView.frame = scrollViewFrame

        scrollView.layoutIfNeeded()
        scrollView.isScrollEnabled = true
    
        view.addSubview(scrollView)
        
        let imageWidth = UIScreen.main.bounds.width * 0.9
        let marginLeft = (UIScreen.main.bounds.width - imageWidth) / 2
        let margin:CGFloat = 15
        
        
        // Title
        let titleView = UILabel()
        titleView.text = imageName
        titleView.frame = CGRect(x: marginLeft, y: 0, width: view.frame.width - 2 * marginLeft , height: 0)
        //showing full title by extending height
        resetHeight(labelToResize: titleView)
        
        
        titleView.textAlignment = .center
        scrollView.addSubview(titleView)
        
        // Poster Image
        let theImageFrame = CGRect(x: marginLeft, y: titleView.frame.maxY + margin, width: imageWidth, height: imageWidth * imageRatio)
        let imageView = UIImageView(frame: theImageFrame)
        imageView.image = image
        scrollView.addSubview(imageView)
        

        
        // Addtional info fetch from new API request
        let bannerView = UIView(frame: CGRect(x:marginLeft, y: imageView.frame.maxY + margin, width: imageWidth, height: 30 ))
        
        // vote_average
        let voteLabel = UILabel(frame: CGRect(x: 0, y: 0, width: imageWidth, height: bannerView.frame.height))
        voteLabel.text = displayVoteAvg
        voteLabel.textAlignment = NSTextAlignment.left
        
        // popularity
        let popLabel = UILabel(frame: CGRect(x: 0, y: 0, width: imageWidth, height: bannerView.frame.height))
        popLabel.text = displayPopularity
        popLabel.textAlignment = .right
        
        scrollView.addSubview(bannerView)
        bannerView.addSubview(voteLabel)
        bannerView.addSubview(popLabel)
        
        // Overview Label and Favorite button
        let bannerViewTwo = UIView(frame: CGRect(x:marginLeft, y: bannerView.frame.maxY, width: imageWidth, height: 30 ))
        
        let overViewTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: imageWidth, height: bannerViewTwo.frame.height))
        overViewTitleLabel.text = "Overview: "
        overViewTitleLabel.textAlignment = NSTextAlignment.left
        
        favoriteButton.frame = CGRect(x:imageWidth - 30, y: 0 , width: 30, height: 30 )
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        
        if favoriteId.contains(id){
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        
        
        favoriteButton.addTarget(self, action: #selector(pressFavorite), for: .touchUpInside)
        
        scrollView.addSubview(bannerViewTwo)
        bannerViewTwo.addSubview(overViewTitleLabel)
        bannerViewTwo.addSubview(favoriteButton)
        
        // overview
        
        let overviewView = UILabel()
        overviewView.text = displayOverView
        overviewView.frame = CGRect(x: marginLeft, y: bannerViewTwo.frame.maxY, width: view.frame.width - 2 * marginLeft , height: 30)
        resetHeight(labelToResize: overviewView)
        scrollView.addSubview(overviewView)
        
        // incase no trailer is available
        //scrollView.contentSize = CGSize(width: self.view.frame.width, height: overviewView.frame.maxY + 30)
        
        // webviw
        
        //let videoKey = "bJcLRFWxRno"
        if videoKey != ""{
            if let trailerURL = URL(string: "https://www.youtube.com/embed/\(videoKey)"){
                let webView = WKWebView()
                webView.load(URLRequest(url:trailerURL))
                webView.frame = CGRect(x: marginLeft, y: overviewView.frame.maxY+margin, width: imageWidth, height: imageWidth * 9 / 16)
                scrollView.addSubview(webView)
                //scrollView.contentSize = CGSize(width: self.view.frame.width, height: webView.frame.maxY + 30)
            }
        }
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: getLastSubviewY(view: scrollView) + 30)
    }
    func setRecommendationUI(){
        // section title
        let recommendationTitle = UILabel(frame: CGRect(x: 0, y: getLastSubviewY(view: scrollView) + 30, width: UIScreen.main.bounds.width*0.9, height: 30))
        recommendationTitle.text = "Recommendation: "
        //recommendationTitle.textAlignment = NSTextAlignment.left
        scrollView.addSubview(recommendationTitle)
        
        // add the collection
        collectionView.frame = CGRect(x: 5, y: 10 + getLastSubviewY(view: scrollView), width: UIScreen.main.bounds.width - 10, height: 500)
        collectionView.layoutIfNeeded()
        
        setupCollectionViewLayout()
        //collectionView.backgroundColor = .blue
        collectionView.frame.size.height = collectionView.contentSize.height
        //collectionView.reloadData()
        
        collectionView.backgroundColor = #colorLiteral(red: 0.9121729136, green: 0.9247624278, blue: 0.9571543336, alpha: 1)
        scrollView.addSubview(collectionView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: getLastSubviewY(view: scrollView) + 30)
        
        print("recommdation has size of\(theImageCache.count)")
        print("Collection view has size of\(collectionView.frame.height)")
    }


    
    func fetchDataForDeailVC(id: Int){

        //let apiKey:String = "b6b69f707b050d3512d5a46fccb83ad8"

        // encoding query user input search
        let apiId = id//textQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        let apiQuery:String = "https://api.themoviedb.org/3/movie/\(apiId)?api_key=\(apiKey)&language=en-US"
        
        //print("url is\(apiQuery)")
        let url = URL(string: apiQuery)
        guard let url = url else {
            return
        }
        guard let data = try? Data(contentsOf: url) else{
            return
        }

        if data.count == 0{
            print("No Data")
        }
        let decoder = JSONDecoder()
        
        // setting default values
//        var displayOverView = "Overview not available"
//        var displayVoteAvg = "No Data"
//        var displayPopularity = "No Data"
        
        if let apiOverview = try? decoder.decode(MovieDetail.self, from: data).overview {
            //print ("overview is \(apiOverview)")
            displayOverView = apiOverview
        }
        if let apiVoteAvg = try? decoder.decode(MovieDetail.self, from: data).vote_average {
            displayVoteAvg = "Rating: " + String(format: "%.2f", apiVoteAvg)
        }
        if let apiPopularity = try? decoder.decode(MovieDetail.self, from: data).popularity {
            displayPopularity = "Popularity: " + String(format: "%.2f", apiPopularity)
        }
        //spinnerIndicator.stopAnimating()
    }
    @objc func pressFavorite(){
        print("Favorite button is pressed, id is\(id)")
        if favoriteId.contains(id){
            if let indexToDelete = favoriteId.firstIndex(of: id){
                deleteDefault(id: indexToDelete)
                print("The index that try to delete is at: \(indexToDelete)")
                favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }else{
            if id > 0{
                insertDefault(id:id, title: imageName)
                favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            }else{
                print("Invalid ID")
            }
        }
    }
    
    func fetchDataForTrailer(id: Int){

        //let apiKey:String = "b6b69f707b050d3512d5a46fccb83ad8"

        // encoding query user input search
        let apiId = id//textQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        let apiQuery:String = "https://api.themoviedb.org/3/movie/\(apiId)/videos?api_key=\(apiKey)&language=en-US"
        
        print("Entering trailer is\(apiId)------------------------")
        let url = URL(string: apiQuery)
        guard let url = url else {
            return
        }
        guard let data = try? Data(contentsOf: url) else{
            return
        }
        if data.count == 0{
            print("No Data")
        }
        //var theData: [Movie] = []
        //var theImageCache: [UIImage] = []
        //let decoder = JSONDecoder()
        
        // setting default values
//        var displayOverView = "Overview not available"
//        var displayVoteAvg = "No Data"
//        var displayPopularity = "No Data"
        //var theData: [MovieVideo] = []
        if let theData: [MovieVideo] = try? JSONDecoder().decode(APIVideo.self, from: data).results{
            for item in theData{
                if item.site == "YouTube"{
                    if let siteKey = item.key{
                        videoKey = siteKey
                        
                        print("key is \(videoKey)")
                        break
                    }
                }
            }
        }
        //spinnerIndicator.stopAnimating()
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
    
    
    func fetchDataForRecommendation(id: Int){

        let apiId = id

        let apiQuery:String = "https://api.themoviedb.org/3/movie/\(apiId)/recommendations?api_key=\(apiKey)&language=en-US&page=1"
        print("Getting Recommandation for \(apiId)------------------------")
        let url = URL(string: apiQuery)
        guard let url = url else {
            return
        }
        guard let data = try? Data(contentsOf: url) else{
            return
        }
        if data.count == 0{
            //spinnerIndicator.stopAnimating()
            self.showAlert(alertText: "Hello", alertMessage: "World")
            return
        }
        if let someData = try? JSONDecoder().decode(APIResults.self, from: data).results {
            theData = someData
        }
        
        //spinnerIndicator.stopAnimating()
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
        if favoriteId.contains(id){
            print("Already in favorite")
            return
        }
        
        favoriteId.append(id)
        favoriteTitle.append(title)
        UserDefaults.standard.set(favoriteId, forKey: "movieId")
        UserDefaults.standard.set(favoriteTitle, forKey: "movieTitle")
    }
    
    func deleteDefault(id:Int){
        favoriteTitle.remove(at: id)
        favoriteId.remove(at: id)
        print ("title array length :\(favoriteTitle.count)")
        print ("ID array length:\(favoriteId.count)")
        print ("Trying to remove at :\(id)")
        
        UserDefaults.standard.set(favoriteTitle, forKey: "movieTitle")
        UserDefaults.standard.set(favoriteId, forKey: "movieId")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
}
extension DetailedViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return theImageCache.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? CollectionMovieCell else{
            return UICollectionViewCell()
        }

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


