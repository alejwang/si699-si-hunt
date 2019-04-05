//
//  LogInViewController.swift
//  ARKitImageRecognition
//
//  Created by Alejandro Wang on 3/31/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import QuartzCore

class LogInViewController: UIViewController {

    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
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
        let button: UIButton = UIButton (type: UIButtonType.custom)
        button.setImage(UIImage(named: "backButton"), for: UIControlState.normal)
        button.frame = CGRect(x: 32 , y: 10, width: 60, height: 32)
        button.addTarget(self, action: #selector(LogInViewController.backButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        // rewrite the go button
        logInButton.titleEdgeInsets = UIEdgeInsetsMake(0, -logInButton.imageView!.frame.size.width, 0, logInButton.imageView!.frame.size.width);
        logInButton.imageEdgeInsets = UIEdgeInsetsMake(0, logInButton.titleLabel!.frame.size.width, 0, -logInButton.titleLabel!.frame.size.width);

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // validate log in session, if logged in, push the profile vc
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(profileVC, animated: false)
        }
    }
    
    
    // rewrite the back button action
    @objc func backButtonPressed(_ sender : Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // rewrite exit keyboard interaction
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // called when user failed to login
    func loginFailed(message: String){
        self.logInButton.titleLabel?.text = "Go "
        let alertController = UIAlertController(title: "Emm...", message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "🆗", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // called when user clicked the login button
    @IBAction func logIn(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        guard let username = usernameTextfield.text, let password = passwordTextfield.text else {
            loginFailed(message: "Please fill in the username and password")
            return
        }
        guard username.count > 0, password.count > 0 else {
            loginFailed(message: "Username or password is too short!")
            return
        }
        logInButton.titleLabel?.text = "... "
        APIClient.login(withUsername: usernameTextfield.text!, password: passwordTextfield.text!, completion: {
                print("> Loging in \(String(describing: self.usernameTextfield.text!)) \(String(describing: self.passwordTextfield.text!)) ")
                print("> Auth returned string: \(String(describing: UserDefaults.standard.string(forKey: "access_token"))))")
            
                if UserDefaults.standard.string(forKey: "access_token") != nil {
                    self.view.endEditing(true) // remove the keyboard
                    let vc = EventTableViewController(nibName: "EventTableViewController", bundle: nil)
                    vc.user_name = self.usernameTextfield.text!
                    UserDefaults.standard.set(self.usernameTextfield.text!, forKey: "username")
                    print("> vc.user_name + UD.username: \(vc.user_name ?? "no_name")")
                    self.passwordTextfield.text = ""
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    self.performSegue(withIdentifier: "gotoProfile", sender: self)
                } else {
                    self.loginFailed(message: "Wrong username or password!")
                }
        })
    }
    
}
