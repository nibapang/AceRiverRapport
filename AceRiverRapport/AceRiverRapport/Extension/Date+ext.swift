//
//  Date+ext.swift
//  AceRiverRapport
//
//  Created by jin fu on 2025/3/13.
//


import Foundation

extension Date{
    
    func toString(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    // EEEE, d MMMM yyyy, h:mm a
}