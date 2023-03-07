//
//  FavoriteViewController.swift
//  QiyuanWang-Lab4
//
//  Created by W Q on 10/29/22.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    //var movieDisplayArray = ["apple", "Ioo", "ddd"]
    var favoriteTitle:[String] = []
    var favoriteId:[Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        insertIntoPropertyList()
//        dataFromPropertyList()
        let someString = UserDefaults.standard.array(forKey: "movieTitle")
        print("the key is \(String(describing: someString))")
        loadDefault()
        
        print ("title array :\(favoriteTitle.count)")
        print ("ID array :\(favoriteId.count)")
        
      
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        loadDefault()
        print("favorite view appear, \(favoriteTitle.count)")
        tableView.reloadData()
        if favoriteId.count != favoriteTitle.count{
            print("Array does not matches------------------")
        }
        
    }
    
    func loadDefault(){
        favoriteTitle = []
        favoriteId = []
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
        if favoriteId.count != favoriteTitle.count{
            print("Array does not matches------------------")
        }
    }
    
    func insertDefault(id:Int , title:String){
        favoriteId.append(id)
        favoriteTitle.append(title)
        UserDefaults.standard.set(favoriteId, forKey: "movieId")
        UserDefaults.standard.set(favoriteTitle, forKey: "movieTitle")
    }
    
    
    func deleteDefault(id:Int){
        favoriteTitle.remove(at: id)
        favoriteId.remove(at: id)
        print ("title array :\(favoriteTitle.count)")
        print ("ID array :\(favoriteId.count)")
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
}
extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = UITableViewCell(style: .default, reuseIdentifier: nil) //as! TableMovieCell
        myCell.textLabel?.text = favoriteTitle[indexPath.row]
        return myCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            tableView.beginUpdates()
            print("detect delete at \(indexPath.row)")
            deleteDefault(id:indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            tableView.endUpdates()
        }
    }
}
