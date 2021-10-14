//
//  SpinGameResultViewController.swift
//  KumuApp
//
//  Created by Jyoti on 24/05/21.
//

import UIKit

protocol SpinGameResultDelegate: ControllerDelegate {

}
class SpinGameResultViewController: UIViewController {

    var userList = [UserList]()
    var delegate: SpinGameResultDelegate?
    @IBOutlet weak var btnClose: UIButton! {
        didSet {
            btnClose.layer.cornerRadius = btnClose.frame.height / 2
            btnClose.layer.masksToBounds = true
            btnClose.layer.borderWidth = 1
            btnClose.layer.borderColor = UIColor.hexStringToUIColor(hex: "#773EE4").cgColor
        }
    }
    @IBOutlet weak var btnStopGame: UIButton! {
        didSet {
            btnStopGame.layer.cornerRadius = 10
            btnStopGame.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var tableGameResult: UITableView!
    @IBOutlet weak var viewBg: CardView!
    var gameId: Int? = 0
    var gameScores : GameScores?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.getResult()
    }
    
    private func getResult() {
        let params : [String : Any] = ["game_id": UserDefaults.standard.integer(forKey: "gameId")]
        NetworkClient.shared.getResultList(params: params, vc: self) { message, results in
            if let result = results, let data = results?.results {
                self.userList = data
                self.tableGameResult.reloadData()
            }else {
            }
        }
    }
    

    @IBAction func actionClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.onDismiss()
    }
}

extension SpinGameResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            //Code I want to do here
            // API call for Deleting Score
            let params : [String : Any] = [
                "user_id": self.userList[indexPath.row].user_id ?? "",
                "score_id": self.userList[indexPath.row].id ?? ""
            ]
            
            print("params : \(params)")
            
            NetworkClient.shared.deleteScore(params: params, vc: self) { (message) -> (Void) in
                self.getResult()
            }
            
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
}

extension SpinGameResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpinResultViewCell", for: indexPath) as! SpinResultViewCell
        let userResult = self.userList[indexPath.row]
        cell.lblName.text = userResult.username
        cell.lblGameLabel.text = userResult.emoji
        cell.lblRanking.text = userResult.section_text
        return cell
    }
    
    
}
