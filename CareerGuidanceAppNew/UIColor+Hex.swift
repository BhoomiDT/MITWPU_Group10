
import UIKit

extension UIColor {
    
    // Helper initializer to create UIColor from a Hex string
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0

        let length = hexSanitized.count
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            let a = CGFloat(rgb & 0x000000FF) / 255.0
            self.init(red: r, green: g, blue: b, alpha: a)
            return
        }

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }

    //Static property for the main background color (#F2F2F7)
    static let appBackground = UIColor(hex: "F2F2F7")
    
    // Static property for the main teal color (1FA5A1)
    static let appTeal = UIColor(hex: "1FA5A1")
    
    // Static property for the light background circle color
    static let appTealLightBackground = UIColor(red: 0.88, green: 0.95, blue: 0.95, alpha: 1.0)
        
    // Realistic (R) - 43B6E4 (Blue)
    static let riasecRealistic = UIColor(hex: "43B6E4")
    
    // Investigative (I) - E2E75E (Yellow/Lime)
    static let riasecInvestigative = UIColor(hex: "E2E75E")
    
    // Artistic (A) - 38CC62 (Green)
    static let riasecArtistic = UIColor(hex: "38CC62")
    
    // Social (S) - DD5DF4 (Purple/Pink)
    static let riasecSocial = UIColor(hex: "DD5DF4")
    
    // Enterprising (E) - F45D5D (Red)
    static let riasecEnterprising = UIColor(hex: "F45D5D")
    
    // Conventional (C) - 0C4FAB (Dark Blue/Indigo)
    static let riasecConventional = UIColor(hex: "0C4FAB")
    
    // MARK: - Dynamic Theme Colors
    
    /// Screen background: pure black in dark, f2f2f7 in light
    static let themeBg = UIColor { tc in
        tc.userInterfaceStyle == .dark ? .black : UIColor(hex: "F2F2F7")
    }
    
    /// Card background
    static let cardBg = UIColor { tc in
        tc.userInterfaceStyle == .dark
            ? UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1)
            : .white
    }
    
    /// Card border
    static let cardBorder = UIColor { tc in
        tc.userInterfaceStyle == .dark
            ? UIColor.white.withAlphaComponent(0.08)
            : UIColor.black.withAlphaComponent(0.06)
    }
    
    /// Primary text: white on dark, near-black on light
    static let textPrimary = UIColor { tc in
        tc.userInterfaceStyle == .dark ? .white : UIColor(hex: "1A1A1A")
    }
    
    /// Secondary text
    static let textSecondary = UIColor { tc in
        tc.userInterfaceStyle == .dark
            ? UIColor.white.withAlphaComponent(0.45)
            : UIColor.black.withAlphaComponent(0.50)
    }
    
    /// Subtle divider line
    static let dividerColor = UIColor { tc in
        tc.userInterfaceStyle == .dark
            ? UIColor.white.withAlphaComponent(0.07)
            : UIColor.black.withAlphaComponent(0.06)
    }
    
    /// Teal accent line (slightly muted in light)
    static let accentTeal = UIColor(hex: "1FA5A1")
    
    /// Color for links in Auth screen (no teal in dark mode)
    static let authLinkColor = UIColor { tc in
        tc.userInterfaceStyle == .dark ? .white : UIColor(hex: "1FA5A1")
    }
    
    /// Icon bubble background (used for tinted icon backgrounds)
    static func iconBubbleBg(_ color: UIColor) -> UIColor {
        UIColor { tc in
            tc.userInterfaceStyle == .dark
                ? color.withAlphaComponent(0.14)
                : color.withAlphaComponent(0.10)
        }
    }
    
    /// Nav bar background
    static let navBarBg = UIColor { tc in
        tc.userInterfaceStyle == .dark ? .black : UIColor(hex: "F2F2F7")
    }
    
    /// Button primary: white text on dark, black text on light
    static let btnPrimaryBg = UIColor { tc in
        tc.userInterfaceStyle == .dark ? .white : UIColor(hex: "1A1A1A")
    }
    static let btnPrimaryText = UIColor { tc in
        tc.userInterfaceStyle == .dark ? .black : .white
    }
    
    /// Track background for progress bars
    static let progressTrackBg = UIColor { tc in
        tc.userInterfaceStyle == .dark
            ? UIColor.white.withAlphaComponent(0.08)
            : UIColor.black.withAlphaComponent(0.06)
    }
}

// MARK: - Layout Helpers
extension UIView {
    /// Pins all edges of this view to another view using Auto Layout.
    func pin(to view: UIView, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right),
        ])
    }
}
