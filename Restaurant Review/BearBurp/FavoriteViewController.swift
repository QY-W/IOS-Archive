//
//  MyViewController.swift
//  HaoranSong-Lab4
//
//  Created by Haoran Song on 10/23/22.
//

import UIKit
import Photos
import PhotosUI
import SwiftUI

class FavoriteViewController: UIViewController {
    
    var likedList: [Restaurant] = []
    let defaults = UserDefaults.standard
    var myAvatar: UIImage?
    var theUrl:String = ""
//    var myUserName = "Guest"
//    var myAvatar: UIImage?
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userBack: UIView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserAvatar()
        setupTableView()
        
        //UI - gradient background
//        let colorTop = UIColor(red: 253, green: 123, blue: 69, alpha: 1).cgColor
//        let colorMid = UIColor(red: 248, green: 67, blue: 37, alpha: 1).cgColor
//        let colorBot = UIColor(red: 242, green: 4, blue: 2, alpha: 1).cgColor

//        let gdLayer = CAGradientLayer()
//        gdLayer.frame = userBack.bounds
//        userBack.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.88, alpha: 1.00)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setupUserAvatar()
        var tempList: [Restaurant] = []
        for i in defaults.dictionaryRepresentation().keys{
            if i.contains("Favorite_") {
                if let temp = defaults.object(forKey: i) as? Data {
                    let decoder = JSONDecoder()
                    if let loadedTemp = try? decoder.decode(Restaurant.self, from: temp) {
                        tempList.append(loadedTemp)
                    }
                }
            }
        }
        likedList = tempList.sorted { (lhs, rhs) in
            return lhs.id > rhs.id
        }
        tableView.reloadData()
        setupUserAvatar()

        // move logout below tableview
//        titleView.frame.maxY + margin
//        logoutButton.frame.origin.y = 500 //tableView.frame.maxY - 50
//        logoutButton.addTarget(self, action: #selector(didPressLogout), for: .touchUpInside)
        
        view.bringSubviewToFront(logoutButton)
        
            
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    func setupUserAvatar(){
        let avatarInDefaults = UIImage(systemName: "face.smiling")
//        UIImage(systemName: "face.smiling")
//        if(avatarInDefaults==nil){
//            userAvatar.image = myAvatar
//        }
        /// getting avatar from DB/default
        if let username = UserDefaults.standard.string(forKey: "username"){
            let key = username + "/" + "imagedata"
            if let imageData = UserDefaults.standard.data(forKey: key){
                userAvatar.image = UIImage(data: imageData)
            }else{
//                let newImageData = Data(base64Encoded: avatarInDefaults!)
//                let newImage = UIImage(data: newImageData!)
                userAvatar.image = avatarInDefaults
            }
        }
        userAvatar.layer.cornerRadius = (userAvatar.frame.size.width)/2
        userAvatar.layer.masksToBounds = true
        userAvatar.layer.borderWidth = 2;
        userAvatar.layer.borderColor = UIColor.white.cgColor
        userName.text = UserDefaults.standard.string(forKey: "username")
    }
 
    @IBAction func pressUploadImg(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @IBAction func pressLogout(_ sender: Any) {
        print("pressed logout")
//      reset user default
        defaults.set(nil, forKey: "username")
        
//      send to login page
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
//        self.present(loginVC, animated: true, completion: nil)
        self.navigationController?.setViewControllers([loginVC], animated: true)
    }
}



extension FavoriteViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedList.count+1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        if(indexPath.item==0){
            cell.textLabel!.text = "@BearBurp All Rights Reserved"
            cell.textLabel!.font =  UIFont.italicSystemFont(ofSize: 12)
            cell.isUserInteractionEnabled = false
        }else{
            cell.textLabel!.text = likedList[indexPath.item-1].name
            cell.textLabel!.font = UIFont.boldSystemFont(ofSize: 18.0)

            let tempString = likedList[indexPath.item-1].location
            cell.detailTextLabel?.text = tempString

            let image_url = likedList[indexPath.item-1].image_url
            let url = URL(string: image_url)
            let data = try! Data(contentsOf: url!)
            let image = UIImage(data: data)
            cell.imageView?.image = image
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailedCV = self.storyboard?.instantiateViewController(withIdentifier: "detail") as! DetailViewController
        let image_url = likedList[indexPath.item-1].image_url
        let url = URL(string: image_url)
        let data = try! Data(contentsOf: url!)
        let image = UIImage(data: data)
        detailedCV.image = image
        detailedCV.restaurant = likedList[indexPath.item-1]
        navigationController?.pushViewController(detailedCV, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if(indexPath.item==0){
            return UITableViewCell.EditingStyle.none
        }else{
            return UITableViewCell.EditingStyle.delete
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if tableView.numberOfRows(inSection: indexPath.section) == 1{}else{
                if(indexPath.item==0){}else{
                    let key = "Favorite_\(likedList[indexPath.item-1].id)"
                    likedList.remove(at: indexPath.item-1)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    defaults.removeObject(forKey: key)
                }
            }
        }
    }
    
    

}

extension FavoriteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        userAvatar.image = UIImage(systemName: "circle")
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            // replace the avatar image
            //self.userAvatar.image = image
            // convert to imageData
            guard let imageData = image.pngData() else { return  }
            if let convertImage = UIImage(data: imageData){
                
                self.userAvatar.image = convertImage
                
                // Store the image data to DB/default
                guard let username = UserDefaults.standard.string(forKey: "username") else { return}
                let key = username + "/" + "imagedata"
                defaults.set(imageData, forKey: key)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

