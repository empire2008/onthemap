//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Nuttapong Nateetaweesak on 3/8/2562 BE.
//  Copyright © 2562 Nuttapong Nateetaweesak. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTapAround()
    }
    
    func setActivityIndicator(isOn: Bool){
        if isOn{
            self.activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        else{
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        if emailInput.text != "" && passwordInput.text != ""{
            self.setActivityIndicator(isOn: true)
            UdacityClient.requestSession(username: emailInput.text!, password: passwordInput.text!) { (success, error) in
                self.setActivityIndicator(isOn: false)
                if success{
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "MainViewController", sender: self)
                    }
                }
                else{
                    self.popupAlert(topic: nil, message: error?.localizedDescription ?? "")
                }
            }
        }
        else{
            self.popupAlert(topic: nil, message: "Empty Email or Password")
        }
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        guard let url = URL(string: "https://www.udacity.com/account/auth#!/signup") else { return }
        UIApplication.shared.open(url)
    }
}
