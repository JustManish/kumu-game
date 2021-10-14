//
//  SelectWheelTypeController.swift
//  KumuApp
//
//  Created by Jyoti on 19/05/21.
//

import UIKit

class SelectWheelTypeController: UIViewController {

    @IBOutlet weak var viewBg: UIView! {
        
        didSet {
            viewBg.layer.cornerRadius = 10
            viewBg.layer.masksToBounds = true
        }
    }
    
    
    @IBOutlet weak var collectionPreviousWheels: UICollectionView!
    @IBOutlet weak var collectionViewSelectWheel: UICollectionView!
    let spinWheelCreateVM = SpinWheelCreateViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionClose(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let spinWheel = sender as? SpinWheel {
            if let controller = segue.destination as? SpinWheelCreatorViewController {
                controller.spinWheel = spinWheel
            }
        }
       
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
extension SelectWheelTypeController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (collectionView == collectionPreviousWheels) ? spinWheelCreateVM.historyWheel.count : spinWheelCreateVM.wheelTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WheelTypeViewCell", for: indexPath) as? WheelTypeViewCell
        cell?.spinWheel = (collectionView == collectionPreviousWheels) ? spinWheelCreateVM.historyWheel[indexPath.row] : spinWheelCreateVM.wheelTypes[indexPath.row]
        return cell!
     }
    
    
}

extension SelectWheelTypeController : UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let spinWheel = (collectionView == collectionPreviousWheels) ? spinWheelCreateVM.historyWheel[indexPath.row] : spinWheelCreateVM.wheelTypes[indexPath.row]
        
        self.performSegue(withIdentifier: "SelectToCreateWheel", sender: spinWheel)
    }

}

extension SelectWheelTypeController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        return (collectionView == collectionPreviousWheels) ? CGSize(width: 65 , height: 65) : CGSize(width: 90 , height: 90)
    }
}
