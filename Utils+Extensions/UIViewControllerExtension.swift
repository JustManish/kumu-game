//
//  UIViewControllerExtension.swift
//  KumuApp
//
//  Created by mac on 02/07/21.
//

import Foundation
import UIKit

struct JLActionSheetButton {
    var title: String!
    var type: UIAlertAction.Style!
}

extension UIViewController {
    
    func showLoader() {
        self.view.startLoader()
    }
    
    func hideLoader() {
        self.view.stopLoader()
    }
    
    func presentAlert(withTitle title: String, andMessage message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func presentAlert(withTitle title: String?, message: String?, buttons: [JLActionSheetButton],
                      completion: @escaping ((Int) -> Void)) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            
            // Add Buttons to alert controller
            var i = 0
            for button in buttons {
                let j = i
                let action = UIAlertAction(title: button.title,
                                           style: button.type,
                                           handler:
                    { (action) in
                        completion(j)
                })
                
                alert.addAction(action)
                i += 1
            }
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
