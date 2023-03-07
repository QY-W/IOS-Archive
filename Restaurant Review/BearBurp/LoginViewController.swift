//
//  LoginViewController.swift
//  BearBurp
//
//  Created by W Q on 11/7/22.
//

import UIKit
import SwiftUI

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var pwInput: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    var username:String?
    var password:String?
    var theData:Message?
    var logoutBtn = UIButton(frame: CGRect(x: 0, y: 0 , width: 100, height: 30 ))
    var loggedView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        //UI
        usernameInput.layer.cornerRadius = 10
        usernameInput.layer.borderWidth = 1
        usernameInput.layer.borderColor = UIColor.white.cgColor
        usernameInput.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])

        pwInput.layer.cornerRadius = 10
        pwInput.layer.borderWidth = 1
        pwInput.layer.borderColor = UIColor.white.cgColor
        pwInput.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])


        loginBtn.backgroundColor = .white
        loginBtn.layer.cornerRadius = 17
        loginBtn.layer.borderWidth = 1
        loginBtn.layer.borderColor = UIColor.white.cgColor
        loginBtn.clearColorForTitle()

        registerBtn.backgroundColor = .white
        registerBtn.layer.cornerRadius = 17
        registerBtn.layer.borderWidth = 1
        registerBtn.layer.borderColor = UIColor.white.cgColor
        registerBtn.clearColorForTitle()
    }
    @IBAction func click_login(_ sender: Any) {
        var url:URL?
        
//        var myQuery = query.removeSpecialCharacters().condensedWhitespace
//        myQuery = myQuery.unicodeScalars
//            .filter { !$0.properties.isEmojiPresentation }
//            .reduce("") { $0 + String($1) }
        
        username = (usernameInput.text ?? "default").removeSpecialCharacters().condensedWhitespace
        password = (pwInput.text ?? "default").removeSpecialCharacters().condensedWhitespace
        url = URL(string: "http://3.86.178.119/~Charles/CSE438-final/login.php?username=\(username!)&password=\(password!)")
        let data = try! Data(contentsOf: url!)
        theData = try! JSONDecoder().decode(Message.self,from:data)
        
        if let loginIndicator = theData?.success, let loginMSG = theData?.message {
            if (!loginIndicator){
                showAlert(alertText: "Login Error", alertMessage: loginMSG)
            }else{
                // hide login UI and show logged in UI
                if let username = username{
                    // jump to favoriteView
                    
                    loginSuccessfully()
                    showLoggedUI(username: username)
                    // set username to user default
                    let defaults = UserDefaults.standard
                    defaults.set(username, forKey: "username")
                    // any addtional steps, potentially id or some hashing
                }
            }
        }

    }
    @IBAction func click_register(_ sender: Any) {
        var url:URL?
        if(usernameInput.text != "" && pwInput.text != ""){
            username = usernameInput.text
            password = pwInput.text
            url = URL(string: "http://3.86.178.119/~Charles/CSE438-final/signup.php?username=\(username!)&password=\(password!)")
            let data = try! Data(contentsOf: url!)
            theData = try! JSONDecoder().decode(Message.self,from:data)
            
            if let regIndicator = theData?.success, let regMSG = theData?.message {
                if (!regIndicator){
                    showAlert(alertText: "Register Error", alertMessage: regMSG)
                }else{
                    // jump to favoriteView
                    loginSuccessfully()
                    showLoggedUI(username: username!)
                    // set username to user default
                    let defaults = UserDefaults.standard
                    defaults.set(username, forKey: "username")
                    // any addtional steps, potentially id or some hashing
                }
            }
        }
        else{
            showAlert(alertText: "Register Error", alertMessage: "Please input username or password")
        }
    }
    
    func showLoggedUI(username:String){
        let screenWidth = view.frame.width;
        let screenHeight = UIScreen.main.bounds.height;
        loggedView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        loggedView.backgroundColor = .lightGray
        
        // username label
        let usernameLabel = UILabel()
        usernameLabel.text = "You are logged in as \(username)"
        usernameLabel.frame = CGRect(x: 0,y: screenHeight * 0.3,width: 0, height: 0 )
        usernameLabel.sizeToFit()
        usernameLabel.center.x = loggedView.center.x
        loggedView.addSubview(usernameLabel)
        
        // log out button
        logoutBtn.setTitle("Log Out", for: .normal)
        logoutBtn.frame = CGRect(x: 0,y: screenHeight * 0.5,width: 0, height: 0)
        logoutBtn.setTitleColor(.tintColor, for: .normal)
        logoutBtn.layer.cornerRadius = 10
        logoutBtn.backgroundColor = #colorLiteral(red: 0.8104380965, green: 0.9008539915, blue: 0.9891548753, alpha: 1)
        logoutBtn.sizeToFit()
        logoutBtn.frame.size.width += 35
        logoutBtn.center.x = loggedView.center.x
        logoutBtn.addTarget(self, action: #selector(pressLogout), for: .touchUpInside)
        loggedView.addSubview(logoutBtn)
        
        view.addSubview(loggedView)
    }
    
    func loginSuccessfully(){
        let favoriteCV = self.storyboard?.instantiateViewController(withIdentifier: "favorite") as! FavoriteViewController
        self.navigationController?.setViewControllers([favoriteCV], animated: true)
    }
    
    @objc func pressLogout(){
        loggedView.removeFromSuperview()
        showAlert(alertText: "Sucess", alertMessage: "You've logged out!")
        // any addtional process for logging out
        let defaults = UserDefaults.standard
        // set guest account username to nil
        defaults.set(nil, forKey: "username")
    }
    
}

extension UIViewController {
//Show a basic alert
    func showAlert(alertText : String, alertMessage : String) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        //Add more actions as you see fit
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
            let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
    }
        
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//UI
//reference: https://stackoverflow.com/questions/27458101/transparent-uibutton-title
extension UIButton{
    func clearColorForTitle() {

        let buttonSize = bounds.size

        if let font = titleLabel?.font{
            let attribs = [NSAttributedString.Key.font: font]

            if let textSize = titleLabel?.text?.size(withAttributes: attribs){
                UIGraphicsBeginImageContextWithOptions(buttonSize, false, UIScreen.main.scale)

                if let ctx = UIGraphicsGetCurrentContext(){
                    ctx.setFillColor(UIColor.white.cgColor)

                    let center = CGPoint(x: buttonSize.width / 2 - textSize.width / 2, y: buttonSize.height / 2 - textSize.height / 2)
                    let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: buttonSize.width, height: buttonSize.height))
                    ctx.addPath(path.cgPath)
                    ctx.fillPath()
                    ctx.setBlendMode(.destinationOut)

                    titleLabel?.text?.draw(at: center, withAttributes: [NSAttributedString.Key.font: font])

                    if let viewImage = UIGraphicsGetImageFromCurrentImageContext(){
                        UIGraphicsEndImageContext()

                        let maskLayer = CALayer()
                        maskLayer.contents = ((viewImage.cgImage) as AnyObject)
                        maskLayer.frame = bounds

                        layer.mask = maskLayer
                    }
                }
            }
        }
    }
}
