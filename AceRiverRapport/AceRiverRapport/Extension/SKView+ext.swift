//
//  SKView+ext.swift
//  AceRiverRapport
//
//  Created by jin fu on 2025/3/13.
//


import Foundation
import SpriteKit

extension SKView {
    func takeSnapshot() -> UIImage? {
        guard let snapshot = self.texture(from: self.scene!) else { return nil }
        let image = UIImage(cgImage: snapshot.cgImage())
        return image
    }
}