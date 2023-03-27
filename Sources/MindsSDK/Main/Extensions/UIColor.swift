//
//  File.swift
//  
//
//  Created by Liviu Bosbiciu on 11.04.2022.
//

import Foundation
import UIKit

extension UIColor {

    convenience init(hex string: String) {
        var string: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if string.hasPrefix("#") {
            _ = string.removeFirst()
        }

        // Double the last value if incomplete hex
        if !string.count.isMultiple(of: 2), let last = string.last {
            string.append(last)
        }

        // Fix invalid values
        if string.count > 8 {
            string = String(string.prefix(8))
        }

        // Scanner creation
        let scanner = Scanner(string: string)

        var color: UInt64 = 0
        scanner.scanHexInt64(&color)

        if string.count == 2 {
            let mask = 0xFF

            let g = Int(color) & mask

            let gray = Double(g) / 255.0

            self.init(red: gray, green: gray, blue: gray, alpha: 1)

        } else if string.count == 4 {
            let mask = 0x00FF

            let g = Int(color >> 8) & mask
            let a = Int(color) & mask

            let gray = Double(g) / 255.0
            let alpha = Double(a) / 255.0

            self.init(red: gray, green: gray, blue: gray, alpha: alpha)

        } else if string.count == 6 {
            let mask = 0x0000FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0

            self.init(red: red, green: green, blue: blue, alpha: 1)

        } else if string.count == 8 {
            let mask = 0x000000FF
            let r = Int(color >> 24) & mask
            let g = Int(color >> 16) & mask
            let b = Int(color >> 8) & mask
            let a = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0
            let alpha = Double(a) / 255.0

            self.init(red: red, green: green, blue: blue, alpha: alpha)

        } else {
            self.init(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }

    static var baselinePrimary: UIColor {
        return UIColor(hex: "00DDB8")
    }
    
    static func hexToRGB(_ hex: String) -> (red: Int, green: Int, blue: Int)? {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }

        if hexSanitized.count != 6 && hexSanitized.count != 8 {
            return nil
        }

        if hexSanitized.count == 8 {
            hexSanitized.remove(at: hexSanitized.startIndex)
            hexSanitized.remove(at: hexSanitized.startIndex)
        }

        var rgb: UInt32 = 0
        Scanner(string: hexSanitized).scanHexInt32(&rgb)

        let red = Int((rgb & 0xFF0000) >> 16)
        let green = Int((rgb & 0x00FF00) >> 8)
        let blue = Int(rgb & 0x0000FF)

        return (red, green, blue)
    }
}
