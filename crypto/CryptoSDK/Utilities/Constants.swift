//
//  Constants.swift
//  crypto
//
//  Created by Mark Christian Buot on 23/12/22.
//

import Foundation
import SwiftUI
import CoreGraphics

public struct Colors {
    public static let gray = Color(cgColor: CGColor(red: 233/255, green: 233/255, blue: 234/255, alpha: 1.0))
    public static let subtitleGray = Color(cgColor: CGColor(red: 139/255, green: 140/255, blue: 142/255, alpha: 1.0))
}

public struct Fonts {
    
    public static let header = Font.custom("Helvetica-Bold", size: 16)
    public static let subHeader = Font.custom("Helvetica-Bold", size: 12)
    public static let description = Font.custom("HelveticaNeue-Medium", size: 12)
}
