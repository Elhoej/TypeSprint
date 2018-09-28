//
//  UIColor+Theme.swift
//  Typist
//
//  Created by Simon Elhoej Steinmejer on 25/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

extension UIColor
{
    static let darkColor = UIColor.rgb(red: 0, green: 52, blue: 89)
    static let darkBlue = UIColor.rgb(red: 0, green: 52, blue: 89)
    static let lightBlue = UIColor.rgb(red: 0, green: 168, blue: 232)
    static let lightPurple = UIColor.rgb(red: 59, green: 206, blue: 172)
    static let correctGreen = UIColor.rgb(red: 76, green: 185, blue: 68)
    static let incorrectRed = UIColor.rgb(red: 254, green: 95, blue: 85)
    static let goldColor = UIColor.rgb(red: 255, green: 218, blue: 33)
    static let silver = UIColor.rgb(red: 220, green: 220, blue: 221)
    static let bronze = UIColor.rgb(red: 161, green: 105, blue: 40)
}

enum Appearance
{
    static func titleFont(with size: CGFloat) -> UIFont
    {
        return UIFont(name: "Montserrat-SemiBold", size: size)!
    }
}
