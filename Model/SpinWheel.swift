//
//  SpineWheel.swift
//  KumuApp
//
//  Created by Jyoti on 19/05/21.
//

import Foundation

enum WheelType: Int {
    case sixWheel = 6
    case fourWheel = 4
    case twelveWheel = 12
    case tenwheel = 10
    case twoWheel = 2
    case eight = 8
   
}

struct SpinWheel {
    let imageWheel: String
    let wheelType: WheelType
}
