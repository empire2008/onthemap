//
//  Alert+UIViewController.swift
//  OnTheMap
//
//  Created by SpaCE_MAC on 14/8/2562 BE.
//  Copyright © 2562 Nuttapong Nateetaweesak. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func actionAlert(topic: String? = nil, message: String? = nil, complition: @escaping(UIAlertAction) -> Void){
        let alert = UIAlertController(title: topic, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: complition))
        self.present(alert, animated: true, completion: nil)
    }
    
    func popupAlert(topic: String? = nil, message: String? = nil){
        let alert = UIAlertController(title: topic, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
