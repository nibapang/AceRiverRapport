//
//  HistoryModel.swift
//  AceRiverRapport
//
//  Created by jin fu on 2025/3/13.
//


import Foundation

var arrHistory: [RapportHistoryModel] = []{
    didSet{
        do{
            let data = try JSONEncoder().encode(arrHistory)
            UserDefaults.standard.setValue(data, forKey: "hist")
        }catch{
            print(error.localizedDescription)
        }
    }
}

struct RapportHistoryModel: Codable{
    let time: Date
    let img: Data
    let score: Int
}
