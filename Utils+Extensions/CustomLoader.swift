//
//  CustomLoader.swift
//  KumuApp
//
//  Created by mac on 02/07/21.
//

import Foundation
import UIKit

private var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
private var container: UIView = UIView()
private var loadingView: UIView = UIView()
extension UIView
{
    
    
    func startLoader()
    {
        container.frame = UIScreen.main.bounds
        container.center = self.center
        container.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 100, height: 100)
        loadingView.center = self.center
        loadingView.backgroundColor = UIColor.black
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40, height: 40)
        actInd.style =
        UIActivityIndicatorView.Style.large
        actInd.color = UIColor.white
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        self.addSubview(container)
        actInd.startAnimating()
        
    }
    
    func stopLoader()
    {
        DispatchQueue.main.async {
            container.removeFromSuperview();
            loadingView.removeFromSuperview();
            actInd.stopAnimating()
            actInd.removeFromSuperview();
        }
    }
}
