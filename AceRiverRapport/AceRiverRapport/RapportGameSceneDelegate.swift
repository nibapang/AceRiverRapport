//
//  GameSceneDelegate.swift
//  AceRiverRapport
//
//  Created by Ace River Rapport on 2025/3/13.
//


import Foundation

//MARK: Protocol

protocol RapportGameSceneDelegate: AnyObject {
    func didUpdateScore(_ score: Int)
    func didUpdateLevel(_ level: Int)
}
