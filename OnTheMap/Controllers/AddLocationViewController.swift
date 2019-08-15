//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Nuttapong Nateetaweesak on 3/8/2562 BE.
//  Copyright © 2562 Nuttapong Nateetaweesak. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController {

    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var websiteInput: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTapAround()
    }
    
    @IBAction func submitButton(_ sender: Any) {
        if locationInput.text != "" && websiteInput.text != ""{
            UdacityClient.Auth.userPosted.mapString = locationInput.text!
            UdacityClient.Auth.userPosted.mediaURL = websiteInput.text ?? ""
            performSegue(withIdentifier: "ShowLocation", sender: self)
        }
        else{
            self.popupAlert(topic: nil, message: "Location and link cannot be empty")
        }
    }
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
