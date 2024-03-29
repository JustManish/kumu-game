//
//  Drawing.swift
//  SwiftFortuneWheel
//
//  Created by Sherzod Khashimov on 6/4/20.
// 
//

import Foundation
import CoreGraphics

#if os(macOS)
import AppKit
#else
import UIKit
#endif

/// Slice drawing protocol
protocol SliceDrawing: WheelMathCalculating, SliceCalculating, TextDrawing, ImageDrawing, ShapeDrawing {}

extension SliceDrawing {
    
    /// Circular segment height
    var circularSegmentHeight: CGFloat {
        self.circularSegmentHeight(from: sliceDegree)
    }
    
    /// Content margins
    var margins: SFWConfiguration.Margins {
        var margins = self.preferences?.contentMargins ?? SFWConfiguration.Margins()
        margins.top = margins.top + (self.preferences?.circlePreferences.strokeWidth ?? 0) / 2
        margins.left = margins.left + (self.preferences?.circlePreferences.strokeWidth ?? 0)
        margins.right = margins.right + (self.preferences?.circlePreferences.strokeWidth ?? 0)
        margins.bottom = margins.bottom + (self.preferences?.circlePreferences.strokeWidth ?? 0) / 2
        return margins
    }
    
    
    /// Context position correction offset degree
    var contextPositionCorrectionOffsetDegree: CGFloat {
        return -90
    }
}

extension SliceDrawing {
    
    /// Draw slice with content
    /// - Parameters:
    ///   - index: index
    ///   - context: context where to draw
    ///   - slice: slice content object
    ///   - rotation: rotation degree
    ///   - start: start degree
    ///   - end: end degree
    func drawSlice(withIndex index:Int, in context:CGContext, forSlice slice: Slice, rotation:CGFloat, start: CGFloat, end: CGFloat, rect: CGRect, layer: CALayer) {
        
        //// Context setup
        context.saveGState()
        // Coordinate now start from center
        context.translateBy(x: rotationOffset, y: rotationOffset)
        
        //         Draws slice path and background
        self.drawPath(in: context,
                      backgroundColor: slice.backgroundColor,
                      backgroundColors: slice.backgroundColors,
                      backgroundImage: slice.backgroundImage,
                      start: start,
                      and: end,
                      rotation: rotation,
                      index: index, rect: rect, layer: layer)
        
        var topOffset: CGFloat = 0
        
        // Draws slice content
        slice.contents.enumerated().forEach { (contentIndex, element) in
            switch element {
            case .text(let text, let preferences):
                topOffset += prepareDraw(text: text,
                                         in: context,
                                         preferences: preferences,
                                         rotation: rotation,
                                         index: index,
                                         topOffset: topOffset)
            case .assetImage(let imageName, let preferences):
                guard imageName != "", let image = SFWImage(named: imageName) else {
                    topOffset += preferences.preferredSize.height + preferences.verticalOffset
                    break
                }
                self.drawImage(in: context,
                               image: image,
                               preferences: preferences,
                               rotation: rotation,
                               index: index,
                               topOffset: topOffset,
                               radius: radius,
                               margins: margins)
                topOffset += preferences.preferredSize.height + preferences.verticalOffset
            case .image(let image, let preferences):
                self.drawImage(in: context,
                               image: image,
                               preferences: preferences,
                               rotation: rotation,
                               index: index,
                               topOffset: topOffset,
                               radius: radius,
                               margins: margins)
                topOffset += preferences.preferredSize.height + preferences.verticalOffset
            case .line(let preferences):
                self.drawLine(in: context,
                              preferences: preferences,
                              start: start,
                              and: end,
                              rotation: rotation,
                              index: index,
                              topOffset: topOffset,
                              radius: radius,
                              margins: margins,
                              contextPositionCorrectionOffsetDegree: contextPositionCorrectionOffsetDegree)
                topOffset += preferences.height
            }
        }
        
        context.restoreGState()
    }
    
    func gradientImage(bounds: CGRect, colors: [CGColor], angle: CGFloat) -> UIImage!
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
            //[UIColor.hexStringToUIColor(hex: "#773EE4").cgColor, UIColor.hexStringToUIColor(hex: "#00C7FF").cgColor]
        gradientLayer.bounds = bounds
       
//
//
//        var locations = [NSNumber]()
//
//        for i in 0 ... colors.count-1 {
////            colorsRef.append(colors[i].CGColor as CGColorRef)
//            locations.append(NSNumber(value: Float(i)/Float(colors.count-1)))
//        }

      //  gradientLayer.locations = [0.0, 1.0]
//        let x: Double! = Double(angle) / 360.0
//           let a = pow(sinf(Float(2.0 * Double.pi * ((x + 0.75) / 2.0))),2.0);
//           let b = pow(sinf(Float(2*Double.pi*((x+0.0)/2))),2);
//           let c = pow(sinf(Float(2*Double.pi*((x+0.25)/2))),2);
//           let d = pow(sinf(Float(2*Double.pi*((x+0.5)/2))),2);
//
//             let  endPoint = CGPoint(x: CGFloat(c),y: CGFloat(d))
//            let startPoint = CGPoint(x: CGFloat(a),y:CGFloat(b))
////
//        gradientLayer.startPoint = startPoint
////
//        gradientLayer.endPoint = endPoint
        UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, true, 0.0)
        let context = UIGraphicsGetCurrentContext()
        gradientLayer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func gradientLayer(bounds: CGRect, colors: [CGColor], start: CGPoint, endPoint: CGPoint) -> CAGradientLayer
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
            //[UIColor.hexStringToUIColor(hex: "#773EE4").cgColor, UIColor.hexStringToUIColor(hex: "#00C7FF").cgColor]
        gradientLayer.bounds = bounds
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = start
//
        gradientLayer.endPoint = endPoint
//        UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, true, 0.0)
//        let context = UIGraphicsGetCurrentContext()
//        gradientLayer.render(in: context!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        return gradientLayer
    }
    
    /// Draws slice path and background
    /// - Parameters:
    ///   - context: context where to draw
    ///   - start: start degree
    ///   - end: end degree
    ///   - rotation: rotation degree
    ///   - index: index
    private func drawPath(in context: CGContext, backgroundColor: SFWColor?, backgroundColors: [SFWColor]?, backgroundImage: SFWImage?, start: CGFloat, and end: CGFloat, rotation:CGFloat, index: Int,  rect: CGRect, layer: CALayer) {
        var image: UIImage? = nil
        context.saveGState()
        context.rotate(by: (rotation + contextPositionCorrectionOffsetDegree) * CGFloat.pi/180)
        
        var pathBackgroundColor = backgroundColor
        
        if pathBackgroundColor == nil && backgroundColors == nil {
            switch preferences?.slicePreferences.backgroundColorType {
            case .some(.evenOddColors(let evenColor, let oddColor)):
                pathBackgroundColor = index % 2 == 0 ? evenColor : oddColor
            case .customPatternColors(let colors, let defaultColor):
                pathBackgroundColor = colors?[index, default: defaultColor] ?? defaultColor
            case .none:
                break
            }
        }
        
        let strokeColor = preferences?.slicePreferences.strokeColor
        let strokeWidth = preferences?.slicePreferences.strokeWidth
        
        let path = CGMutablePath()
        let center = CGPoint(x: 0, y: 0)
        path.move(to: center)
        
        path.addArc(center: center, radius: radius, startAngle: start.torad, endAngle: end.torad, clockwise: false)
        path.closeSubpath()
        
        
     //   let rectNew = CGRect(x: path.currentPoint.x, y: path.currentPoint.y, width: path.boundingBox.width, height: path.boundingBox.height)
        
        let rectNew = CGRect(x: 0, y: 0, width: context.width, height: context.height)
        //context.setFillColor(pathBackgroundColor!.cgColor)
        if let pathBackgroundColor = pathBackgroundColor
        {
            context.setFillColor(pathBackgroundColor.cgColor)
            
        }else if let backgroundColors = backgroundColors {
            let cgcolors = backgroundColors.map { color in
                return color.cgColor
            }
//            let startPoint = CGPoint(x: (radius * (cos((end)*(CGFloat.pi/180)))), y: (radius * (sin((start)*(CGFloat.pi/180)))))
//            let endPoint = CGPoint(x: (radius * (cos((start)*(CGFloat.pi/180)))), y: (radius * (sin((end)*(CGFloat.pi/180)))))
          //  layer.addSublayer(self.gradientLayer(bounds: rectNew, colors: cgcolors, start: startPoint, endPoint: endPoint))
            //insertSublayer(self.gradientLayer(bounds: rectNew, colors: cgcolors, start: startPoint, endPoint: endPoint), at: UInt32(index))
            image = gradientImage(bounds: rectNew, colors: cgcolors, angle: rotation)
           // context.setFillColor(UIColor(patternImage: gradientImage(bounds: rectNew, colors: cgcolors, angle: rotation)).cgColor)
        }
        context.addPath(path)
        context.drawPath(using: .fill)
        
        if let backgroundImage = backgroundImage {
            self.draw(backgroundImage: backgroundImage, in: context, clipPath: path)
        }
        if let img = image {
            self.draw(backgroundImage: img, in: context, clipPath: path)
        }
        
        if rotation != end {
            let startPoint = CGPoint(x: (radius * (cos((end)*(CGFloat.pi/180)))), y: (radius * (sin((start)*(CGFloat.pi/180)))))
            let endPoint = CGPoint(x: (radius * (cos((start)*(CGFloat.pi/180)))), y: (radius * (sin((end)*(CGFloat.pi/180)))))
            
            let line = UIBezierPath()
            line.move(to: center)
            line.addLine(to: startPoint)
            strokeColor?.setStroke()
            line.lineWidth = strokeWidth ?? 0
            line.stroke()
            
            let line2 = UIBezierPath()
            line2.move(to: center)
            line2.addLine(to: endPoint)
            strokeColor?.setStroke()
            line2.lineWidth = strokeWidth ?? 0
            line2.stroke()
        }
        
        context.restoreGState()
    }
    
    /// Draws background image for slice
    /// - Parameters:
    ///   - backgroundImage: Background Image
    ///   - context: Context
    private func draw(backgroundImage: SFWImage, in context: CGContext, clipPath: CGPath) {

        context.saveGState()
        context.addPath(clipPath)
        context.clip()
        context.rotate(by: -contextPositionCorrectionOffsetDegree * CGFloat.pi/180)
        
        let aspectFillSize = CGSize.aspectFill(aspectRatio: backgroundImage.size, minimumSize: CGSize(width: radius, height: circularSegmentHeight))
        
        let position = CGPoint(x: -aspectFillSize.width / 2, y: -aspectFillSize.height)
        let rectangle = CGRect(x: position.x, y: position.y, width: aspectFillSize.width, height: aspectFillSize.height)
        
        switch preferences?.slicePreferences.backgroundImageContentMode {
        case .some(.bottom):
            #if os(macOS)
            backgroundImage.draw(at: position, from: NSRect(x: 0, y: 0, width: rectangle.width, height: rectangle.height), operation: .copy, fraction: 1)
            #else
            backgroundImage.draw(at: position)
            #endif
        default:
            backgroundImage.draw(in: rectangle)
        }
        
        context.restoreGState()
    }
    
    /// Prepare to draw text
    /// - Parameters:
    ///   - text: text
    ///   - context: context where to draw
    ///   - preferences: text preferences
    ///   - rotation: rotation degree
    ///   - index: index
    ///   - topOffset: top offset
    /// - Returns: height of the drawn text
    func prepareDraw(text: String, in context: CGContext, preferences: TextPreferences, rotation: CGFloat, index: Int, topOffset: CGFloat) -> CGFloat {
        switch preferences.orientation {
        case .horizontal:
            if preferences.isCurved {
                return self.drawCurved(text: text,
                                       in: context,
                                       preferences: preferences,
                                       rotation: rotation,
                                       index: index,
                                       topOffset: topOffset,
                                       radius: radius,
                                       sliceDegree: sliceDegree,
                                       contextPositionCorrectionOffsetDegree: contextPositionCorrectionOffsetDegree,
                                       margins: margins)
            } else {
                return self.drawHorizontal(text: text,
                                           in: context,
                                           preferences: preferences,
                                           rotation: rotation,
                                           index: index,
                                           topOffset: topOffset,
                                           radius: radius,
                                           sliceDegree: sliceDegree,
                                           margins: margins)
            }
        case .vertical:
            return self.drawVertical(text: text,
                                     in: context,
                                     preferences: preferences,
                                     rotation: rotation,
                                     index: index,
                                     topOffset: topOffset,
                                     radius: radius,
                                     sliceDegree: sliceDegree,
                                     margins: margins)
        }
    }
}
