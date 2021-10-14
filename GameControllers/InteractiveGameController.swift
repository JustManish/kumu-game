//
//  InteractiveGameController.swift
//  KumuApp
//
//  Created by Jyoti on 18/05/21.
//

import UIKit

protocol InteractiveGameSelectDelegate {
    func onSelectGame(game: Games)
}
class InteractiveGameController: UIViewController {

    var delegate: InteractiveGameSelectDelegate?
    var gameListViewModel = GameListViewModel()
    
    @IBOutlet weak var collectionViewGames: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var viewBg: UIView! {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToDismiss))
            tapGesture.numberOfTapsRequired = 1
            viewBg.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func tapToDismiss() {
            self.dismiss(animated: true, completion: nil)
       // delegate?.onDismiss()
      }
}
extension InteractiveGameController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameListViewModel.games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameOptionCell", for: indexPath) as? GameOptionCell
        cell?.game = gameListViewModel.games[indexPath.row]
        return cell!
     }
    
    
}

extension InteractiveGameController : UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let game = gameListViewModel.games[indexPath.row]
        if game.type == .spin {
            self.dismiss(animated: true) {
                self.delegate?.onSelectGame(game: game)
            }
        }
      
    }

}

extension InteractiveGameController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            return CGSize(width: 101 , height: 122)
        }
    
}
