//
//  ViewMainViewController.swift
//  KumuApp
//
//  Created by Jyoti on 24/06/21.
//

import UIKit

class ViewMainViewController: UIViewController {

    var spinItem: [Slice] = []
    
    var items : Items?
    
    //ViewerGameView
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ViewerGameView" {
            if let controller = segue.destination as? ViewerGameViewController {
                //controller.delegate = self
                controller.spinItem = self.spinItem
                controller.items = self.items
            }
        }
    }
    

}
