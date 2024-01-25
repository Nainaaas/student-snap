//
//  Utility.swift
//  StudentSnap
//
//  Created by Shahina Kassim on 30/11/23.
//

import Foundation
import UIKit
struct Utility{
    
    static func alert(with title:String, message: String, controller: UIViewController, completion: (() -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle:.alert)
       let action = UIAlertAction(title: Constants.ok, style: .default)
        alert.addAction(action)
       controller.present(alert, animated: false)
        completion?()
        
    }
}
