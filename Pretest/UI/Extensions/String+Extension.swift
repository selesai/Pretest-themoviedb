//
//  String+Extension.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import UIKit

let kFontResizingProportion: CGFloat = 0.4
let kColorMinComponent: Int = 30
let kColorMaxComponent: Int = 214

public typealias GradientColors = (top: UIColor, bottom: UIColor)

typealias HSVOffset = (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)
let kGradientTopOffset: HSVOffset = (hue: -0.025, saturation: 0.05, brightness: 0, alpha: 0)
let kGradientBotomOffset: HSVOffset = (hue: 0.025, saturation: -0.05, brightness: 0, alpha: 0)

extension String {
    
    func toUIImage() -> UIImage?{
        let replace = self.replacingOccurrences(of: "data:image/png;base64,", with: "").replacingOccurrences(of: "\n", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let url = URL(string: "data:image/png;base64,\(replace)") {
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                return image
            }catch let error {
                print(error)
                return nil
            }
        }
        return nil
    }
    
    
    func generateImage(backgroundColor: UIColor? = .clear, resize: Bool = false, circular: Bool = false, textAttributes: [NSAttributedString.Key: AnyObject] = [:], gradient: Bool = false, gradientColors: GradientColors? = nil, size: CGSize, isInitial: Bool = false) -> UIImage {
        
        let initials: String = initialsFromString(string: self)
        let color: UIColor = (backgroundColor != nil) ? backgroundColor! : randomColor(for: self)
        let gradientColors = gradientColors ?? topAndBottomColors(for: color)
        var attributes: [NSAttributedString.Key: AnyObject] = textAttributes
        attributes[NSAttributedString.Key.font] = fontForFontName(size: size)
        
        if resize {
            return imageSnapshot(text: isInitial ? initials : self, backgroundColor: color, circular: circular, textAttributes: attributes, gradient: gradient, gradientColors: gradientColors, size: size)
        } else {
            return imageSnapshot(text: isInitial ? initials : self, backgroundColor: color, circular: circular, textAttributes: attributes, gradient: gradient, gradientColors: gradientColors)
        }
    }
    
    func fontForFontName(size: CGSize) -> UIFont {
        let fontSize = size.width * kFontResizingProportion
        return .systemFont(ofSize: fontSize)
    }
    
    private func imageSnapshot(text imageText: String, backgroundColor: UIColor, circular: Bool, textAttributes: [NSAttributedString.Key : AnyObject], gradient: Bool, gradientColors: GradientColors, size: CGSize) -> UIImage {
        
        let scale: CGFloat = UIScreen.main.scale
        var size = size
        let bounds: CGRect = CGRect(origin: .zero, size: size)
        size.width = (size.width * scale) / scale
        size.height = (size.height * scale) / scale
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return UIImage() }
        
        if circular {
            // Clip context to a circle
            let path: CGPath = CGPath(ellipseIn: CGRect(origin: .zero, size: size), transform: nil)
            context.addPath(path)
            context.clip()
        }
        
        if gradient {
            // Draw a gradient from the top to the bottom
            let baseSpace = CGColorSpaceCreateDeviceRGB()
            let colors = [gradientColors.top.cgColor, gradientColors.bottom.cgColor]
            
            if let gradient = CGGradient(colorsSpace: baseSpace, colors: colors as CFArray, locations: nil) {
                let startPoint = CGPoint(x: bounds.midX, y: bounds.minY)
                let endPoint = CGPoint(x: bounds.midX, y: bounds.maxY)
                
                context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
            }
        } else {
            // Fill background of context
            context.setFillColor(backgroundColor.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        // Draw text in the context
        let textSize: CGSize = imageText.size(withAttributes: textAttributes)
        
        imageText.draw(in: CGRect(x: bounds.midX - textSize.width / 2,
                                  y: bounds.midY - textSize.height / 2,
                                  width: textSize.width,
                                  height: textSize.height),
                       withAttributes: textAttributes)
        
        guard let snapshot: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        
        return snapshot
    }
    
    private func imageSnapshot(text imageText: String, backgroundColor: UIColor, circular: Bool, textAttributes: [NSAttributedString.Key : AnyObject], gradient: Bool, gradientColors: GradientColors) -> UIImage {
        
        let scale: CGFloat = UIScreen.main.scale
        var size: CGSize = imageText.size(withAttributes: textAttributes)
        size.width = (size.width * scale) / scale
        size.height = (size.height * scale) / scale
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return UIImage() }
        let bounds = CGRect(origin: .zero, size: size)
        
        if circular {
            // Clip context to a circle
            let path: CGPath = CGPath(ellipseIn: CGRect(origin: .zero, size: size), transform: nil)
            context.addPath(path)
            context.clip()
        }
        
        if gradient {
            // Draw a gradient from the top to the bottom
            let baseSpace = CGColorSpaceCreateDeviceRGB()
            let colors = [gradientColors.top.cgColor, gradientColors.bottom.cgColor]
            
            if let gradient = CGGradient(colorsSpace: baseSpace, colors: colors as CFArray, locations: nil) {
                let startPoint = CGPoint(x: bounds.midX, y: bounds.minY)
                let endPoint = CGPoint(x: bounds.midX, y: bounds.maxY)
                
                context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
            }
        } else {
            // Fill background of context
            context.setFillColor(backgroundColor.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        // Draw text in the context
        imageText.draw(in: CGRect(x: bounds.midX - size.width / 2,
                                  y: bounds.midY - size.height / 2,
                                  width: size.width,
                                  height: size.height),
                       withAttributes: textAttributes)
        
        guard let snapshot: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        
        return snapshot
    }
}

func initialsFromString(string: String) -> String {
    var nameComponents = string.uppercased().components(separatedBy: CharacterSet.letters.inverted)
    nameComponents.removeAll(where: {$0.isEmpty})
    
    let firstInitial = nameComponents.first?.first
    let lastInitial  = nameComponents.count > 1 ? nameComponents.last?.first : nil
    return (firstInitial != nil ? "\(firstInitial!)" : "") + (lastInitial != nil ? "\(lastInitial!)" : "")
}

private func randomColorComponent() -> Int {
    let limit = kColorMaxComponent - kColorMinComponent
    return kColorMinComponent + Int(drand48() * Double(limit))
}

private func randomColor(for string: String) -> UIColor {
    srand48(string.hashValue)
    
    let red = CGFloat(randomColorComponent()) / 255.0
    let green = CGFloat(randomColorComponent()) / 255.0
    let blue = CGFloat(randomColorComponent()) / 255.0
    
    return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
}

private func clampColorComponent(_ value: CGFloat) -> CGFloat {
    return min(max(value, 0), 1)
}

private func correctColorComponents(of color: UIColor, withHSVOffset offset: HSVOffset) -> UIColor {
    
    var hue = CGFloat(0)
    var saturation = CGFloat(0)
    var brightness = CGFloat(0)
    var alpha = CGFloat(0)
    if color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
        hue = clampColorComponent(hue + offset.hue)
        saturation = clampColorComponent(saturation + offset.saturation)
        brightness = clampColorComponent(brightness + offset.brightness)
        alpha = clampColorComponent(alpha + offset.alpha)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    return color
}

private func topAndBottomColors(for color: UIColor, withTopHSVOffset topHSVOffset: HSVOffset = kGradientTopOffset, withBottomHSVOffset bottomHSVOffset: HSVOffset = kGradientBotomOffset) -> GradientColors {
    let topColor = correctColorComponents(of: color, withHSVOffset: topHSVOffset)
    let bottomColor = correctColorComponents(of: color, withHSVOffset: bottomHSVOffset)
    return (top: topColor, bottom: bottomColor)
}
