//
//  UIColor+Hex.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 28/11/25.
//

import Foundation
import UIKit

extension UIColor {

    /// Create UIColor from hex string like "#FFAA33" or "FFAA33"
    convenience init?(hex: String) {
        var cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        // Remove leading "#" if present
        if cleaned.hasPrefix("#") {
            cleaned.removeFirst()
        }

        // We support only 6-character RGB (no alpha) for now
        guard cleaned.count == 6 else {
            return nil
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&rgbValue)

        let r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
