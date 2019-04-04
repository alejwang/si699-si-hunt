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
    
    // rewrite the back button action
    @objc func backButtonPressed(_ sender : Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // action for go back to log in from sign up
    @IBAction func goBackToLogIn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // called when user failed to login
    func loginFailed(message: String){
        self.logInButton.titleLabel?.text = "Go "
        let alertController = UIAlertController(title: "Emm...", message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "🆗", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        guard let username = usernameTextfield.text, let password = passwordTextfield.text, let repeatPassword = repeatPasswordTextfield.text else {
            loginFailed(message: "Please fill in the username and password")
            return
        }
        guard username.count > 5, password.count > 5, repeatPassword.count > 5  else {
            loginFailed(message: "Username or password is too short! Try a username/password with at least 6 characters")
            return
        }
        guard repeatPassword == password else {
            loginFailed(message: "Passwords not the same")
            return
        }
        logInButton.titleLabel?.text = "... "
        
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
                self.view.endEditing(true) // remove the keyboard
                let vc = EventTableViewController(nibName: "EventTableViewController", bundle: nil)
                vc.user_name = self.usernameTextfield.text!
                UserDefaults.standard.set(self.usernameTextfield.text!, forKey: "username")
                print("> vc.user_name + UD.username: \(vc.user_name ?? "no_name")")
                self.passwordTextfield.text = ""
                self.performSegue(withIdentifier: "gotoProfile2", sender: self)
            } else {
                self.loginFailed(message: "Log in failed, please try to log in again")
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
}
