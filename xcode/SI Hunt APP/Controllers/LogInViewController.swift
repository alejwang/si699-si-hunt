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
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var passwordTextfield: UITextField!
    
     let LOGIN_URL = "https://alejwang.pythonanywhere.com/auth/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInButton.layer.masksToBounds = true
        logInButton.layer.cornerRadius = 10

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func logIn(_ sender: UIButton) {
        
        guard let username = usernameTextfield.text, let password = passwordTextfield.text, username.count > 0, password.count > 0 else {
            return
        }
        
        logInButton.titleLabel?.text = "Loging in..."
        
        APIClient.login(withUsername: usernameTextfield.text!, password: passwordTextfield.text!, completion: {
            if UserDefaults.standard.string(forKey: "access_token") != nil {
//                var firstTab = self.tabBarController?.viewControllers?[0] as! EventTableViewController
//                firstTab.username = self.usernameTextfield.text!
                let vc = EventTableViewController(nibName: "EventTableViewController", bundle: nil)
//                vc.username = self.usernameTextfield.text!
                
                self.performSegue(withIdentifier: "gotoProfile", sender: self)
//
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let controller = storyboard.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
//                self.present(controller, animated: true, completion: nil)
            } else {
                self.logInButton.titleLabel?.text = "Log in"
            }
            
        })
        
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
