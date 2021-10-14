//
//  SpineWheelCreateViewModel.swift
//  KumuApp
//
//  Created by Jyoti on 19/05/21.
//

import Foundation
struct SpinWheelCreateViewModel {
 
    var historyWheel: [SpinWheel]! {
        get {
            return self.mocHistoryWheelType()
        }
    }
    var wheelTypes: [SpinWheel]! {
        get {
            return self.mocWheelType()
        }
    }
    private func mocWheelType() -> [SpinWheel]{
        
        return [SpinWheel(imageWheel: "six_wheel", wheelType: .sixWheel), SpinWheel(imageWheel: "four_wheel", wheelType: .fourWheel), SpinWheel(imageWheel: "twelve_wheel", wheelType: .twelveWheel), SpinWheel(imageWheel: "ten_wheel", wheelType: .tenwheel), SpinWheel(imageWheel: "twi_wheel", wheelType: .twoWheel), SpinWheel(imageWheel: "eigth_wheel_2", wheelType: .eight)]
        
    }
    
    private func mocHistoryWheelType() -> [SpinWheel]{
        
        return [SpinWheel(imageWheel: "six_wheel", wheelType: .sixWheel), SpinWheel(imageWheel: "four_wheel", wheelType: .fourWheel)]
        
    }
}
