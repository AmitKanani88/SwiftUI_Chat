//
//  TimeInMs.swift
//  SwiftUIChat
//
//  Created by iMac on 02/07/23.
//

import Foundation

func timeInMs() -> Double {
    return Double(DispatchTime.now().rawValue)/1000000
}
