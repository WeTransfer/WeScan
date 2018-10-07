//
//  UIFont+Tellus.swift
//  WeScan
//
//  Created by Alejandro Reyes on 10/7/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation

enum ZLFontWeight {
    /// Equivalent to CSS weight 400.
    case regular
    /// Equivalent to CSS weight 500.
    case medium
    /// Equivalent to CSS weight 700.
    case bold
    /// Equivalent to CSS weight 900.
    case black

    var systemWeight: CGFloat {
        switch self {
        case .regular: return UIFont.Weight.regular.rawValue
        case .medium: return UIFont.Weight.medium.rawValue
        case .bold: return UIFont.Weight.bold.rawValue
        case .black: return UIFont.Weight.black.rawValue
        }
    }
}

@objc enum ZLFontSize : Int, CaseIterable {
    case size10 = 10
    case size12 = 12
    case size14 = 14
    case size17 = 17
    case size19 = 19
    case size24 = 24
    case size32 = 32
    case size40 = 40
    case size48 = 48

    var pointSize: CGFloat { return CGFloat(rawValue) }

    var lineHeight: CGFloat {
        switch self {
        case .size10: return 10
        case .size12: return 12
        case .size14: return 18
        case .size17: return 22
        case .size19: return 24
        case .size24: return 28
        case .size32: return 36
        case .size40: return 40
        case .size48: return 48 + 4 // Slight margin to avoid clipping commas
        }
    }
}

extension UIFont {
    private static func zillyFont(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let fontName: String
        if weight.rawValue <= UIFont.Weight.regular.rawValue {
            fontName = "CircularStd-Book"
        } else if weight.rawValue <= UIFont.Weight.medium.rawValue {
            fontName = "CircularStd-Medium"
        } else if weight.rawValue <= UIFont.Weight.bold.rawValue {
            fontName = "CircularStd-Bold"
        } else {
            fontName = "CircularStd-Black"
        }
        return UIFont(name: fontName, size: size)!
    }

    // Not @objc because it doesn't give a warning when passing the system constants (e.g. UIFontSizeBold)
    class func zillyFont(size: CGFloat, weight: ZLFontWeight = .regular) -> UIFont {
        return zillyFont(size: size, weight: UIFont.Weight(rawValue: weight.systemWeight))
    }

    // Not @objc because it doesn't give a warning when passing the system constants (e.g. UIFontSizeBold)
    class func zillyFont(size: ZLFontSize, weight: ZLFontWeight = .regular) -> UIFont {
        return zillyFont(size: size.pointSize, weight: UIFont.Weight(rawValue: weight.systemWeight))
    }

    class func zillyFont(nonStandardSize: CGFloat, weight: ZLFontWeight = .regular) -> UIFont {
        return zillyFont(size: nonStandardSize, weight: UIFont.Weight(rawValue: weight.systemWeight))
    }

    // Legacy
    @objc class func objc_zillyFont(size: CGFloat) -> UIFont {
        return zillyFont(size: size, weight: UIFont.Weight.regular)
    }

    @objc class func objc_zillyFont(size: CGFloat, weight: CGFloat) -> UIFont {
        return zillyFont(size: size, weight: UIFont.Weight(rawValue: weight))
    }

    /// Tellus fonts by use
    @objc static func zillyLargeBoldTitle() -> UIFont { return UIFont.zillyFont(size: .size32, weight: .bold) }
    @objc static func zillyCellDescription() -> UIFont { return UIFont.zillyFont(size: .size14) }
    @objc static func zillyDetailLabelTitle() -> UIFont { return UIFont.zillyFont(size: .size12) }
    @objc static func zillyMediumDetailLabelTitle() -> UIFont { return UIFont.zillyFont(size: .size12, weight: .medium) }
    @objc static func zillyDefaultFontAndSize() -> UIFont { return UIFont.zillyFont(size: .size17) }
    @objc static func zillyDefaultSemiBoldFontAndSize() -> UIFont { return UIFont.zillyFont(size: .size17, weight: .bold) }
}
