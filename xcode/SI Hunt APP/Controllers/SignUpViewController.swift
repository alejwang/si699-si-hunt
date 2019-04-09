//
//  SignUpViewController.swift
//  ARKitImageRecognition
//
//  Created by Alejandro Wang on 4/4/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var repeatPasswordTextfield: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // rewrite nav bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1867006123, green: 0.1476626396, blue: 0.8859024048, alpha: 1)
        
        // rewrite nav bar back btn
        // ref: https://medium.com/simple-swift-programming-tips/how-to-make-custom-uinavigationcontroller-back-button-image-without-title-swift-7ea5673d7e03
        let backButton: UIButton = UIButton (type: UIButtonType.custom)
        backButton.setImage(UIImage(named: "backButton"), for: UIControlState.normal)
        backButton.frame = CGRect(x: 0 , y: 0, width: 33, height: 32)
        backButton.addTarget(self, action: #selector(SignUpViewController.backButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let barButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = barButton
        
        // rewrite the placeholder text
        // ref: https://stackoverflow.com/questions/26076054/changing-placeholder-text-color-with-swift
        usernameTextfield.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)])
        passwordTextfield.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)])
        repeatPasswordTextfield.attributedPlaceholder = NSAttributedString(string: "Repeat your password", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)])
        
        // rewrite the go button
        logInButton.titleEdgeInsets = UIEdgeInsetsMake(0, -logInButton.imageView!.frame.size.width-10, 0, logInButton.imageView!.frame.size.width+10);
        logInButton.imageEdgeInsets = UIEdgeInsetsMake(0, logInButton.titleLabel!.frame.size.width, 0, -logInButton.titleLabel!.frame.size.width);
    }
    
    
    // rewrite the back button action
    @objc func backButtonPressed(_ sender : Any) {
        performSegue(withIdentifier: "unwindSegueToHomepage3", sender: self)
    }
    
    
    // action for go back to log in from sign up
    @IBAction func goBackToLogIn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    // rewrite exit keyboard interaction
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // called when user failed to login
    // ref: https://stackoverflow.com/questions/37293656/change-uialertcontroller-background-color
    // ref: https://iosdevcenters.blogspot.com/2016/05/hacking-uialertcontroller-in-swift.html
    // ref: https://learnappmaking.com/uialertcontroller-alerts-swift-how-to/
    func loginFailed(message: String){
        self.logInButton.titleLabel?.text = "Join"
        let alertController = UIAlertController(title: "😐 Nice Try", message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "🆗", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // sign up func
    @IBAction func signUp(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "username")
        self.view.endEditing(true) // remove the keyboard
        
        guard let username = usernameTextfield.text else {
            loginFailed(message: "Pick a nice username for yourself!")
            return
        }
        guard let password = passwordTextfield.text else {
            loginFailed(message: "So what is your password?")
            return
        }
        guard let repeatPassword = repeatPasswordTextfield.text,  repeatPassword == password else {
            loginFailed(message: "Emm, passwords are not the same")
            return
        }
        guard username.count > 5, password.count > 5 else {
            loginFailed(message: "Try another longer (>5 chars) username or password!")
            return
        }
        logInButton.titleLabel?.text = "..."
        
        
        // TODO: check if the username is used!
        // APIClient.getProfile()
        
        // register first
        APIClient.register(withUsername: username, password: password, completion: {
            print("> Signing up \(String(describing: self.usernameTextfield.text!)) \(String(describing: self.passwordTextfield.text!)) ")
        })
        
        // log in then and perform segue
        APIClient.login(withUsername: usernameTextfield.text!, password: passwordTextfield.text!, completion: {
            print("> Auth returned string: \(String(describing: UserDefaults.standard.string(forKey: "access_token"))))")
            
            if UserDefaults.standard.string(forKey: "access_token") != nil {
                UserDefaults.standard.set(username, forKey: "username")
                self.passwordTextfield.text = ""
                self.performSegue(withIdentifier: "gotoProfile2", sender: self)
            } else {
                self.loginFailed(message: "Log in failed, please try to log in again")
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
}
