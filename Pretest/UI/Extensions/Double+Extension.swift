//
//  Double+Extension.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    var asString: String {
        return "\(self)"
    }
}
