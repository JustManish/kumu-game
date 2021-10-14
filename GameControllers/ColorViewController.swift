//
//  ColorViewController.swift
//  KumuApp
//
//  Created by Jyoti on 26/05/21.
//

import UIKit
import AMColorPicker
class ColorViewController: UIViewController, AMColorPicker {
    public var selectedColor: UIColor = .white
    weak public var delegate: AMColorPickerDelegate?

    @IBOutlet weak var wheelColor: AMColorPickerWheelView!
    @IBOutlet weak var viewColors: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        wheelColor.delegate = self
        wheelColor.selectedColor = selectedColor

    }
    

    @IBAction func actionClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension ColorViewController: AMColorPickerDelegate {
    func colorPicker(_ colorPicker: AMColorPicker, didSelect color: UIColor) {
        wheelColor.selectedColor = color
        delegate?.colorPicker(self, didSelect: color)
    }
    
    
}
