//
//  Slice.swift
//  SwiftFortuneWheel
//
//  Created by Sherzod Khashimov on 6/3/20.
// 
//

import Foundation

#if os(macOS)
import AppKit
#else
import UIKit
#endif

/// Slice object that will be drawn as a custom content
public struct Slice {
    /// Contents in vertical align order
    public var contents: [ContentType]
    
    /// Background color, `optional`
    public var backgroundColor: SFWColor?
    
    /// Background color, `optional`
    public var backgroundColors: [SFWColor]?
    
    /// Background image, `optional`
    public var backgroundImage: SFWImage?
    
    /// Initiates a slice object
    /// - Parameter contents: Contents in vertical align order
    /// - Parameter backgroundColor: Background color, `optional`
    /// - Parameter backgroundImage: Background image, `optional`
    public init(contents: [ContentType],
                backgroundColor: SFWColor? = nil,
                backgroundColors: [SFWColor]? = nil,
                backgroundImage: SFWImage? = nil) {
        self.contents = contents
        self.backgroundColor = backgroundColor
        self.backgroundImage = backgroundImage
        self.backgroundColors = backgroundColors
    }
}

extension Slice {
    /// Slice content type, currently image or text
    public enum ContentType {
        case assetImage(name: String, preferences: ImagePreferences)
        case image(image: SFWImage, preferences: ImagePreferences)
        case text(text: String, preferences: TextPreferences)
        case line(preferences: LinePreferences)
    }
}
