//
//  UIView+extensions.swift
//  Sudoku
//
//  Created by Illia Suvorov on 22.04.2025.
//

import UIKit

extension UIView {
  
    // Rounded corner raius
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    // Shadow color
    @IBInspectable var shadowColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue.cgColor
        }
    }
    
    // Shadow offsets
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    // Shadow opacity
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    // Shadow radius
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }
    
    // Border width
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    // Border color
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    // Background color
    @IBInspectable var layerBackgroundColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.backgroundColor!)
        }
        set {
            self.backgroundColor = nil
            self.layer.backgroundColor = newValue.cgColor
        }
    }
  
    // Create bezier path of shadow for rasterize
    @IBInspectable var enableBezierPath: Bool {
        get {
            return self.layer.shadowPath != nil
        }
        set {
            if newValue {
                self.layer.shadowPath = UIBezierPath(roundedRect: self.layer.bounds, cornerRadius: self.layer.cornerRadius).cgPath
            } else {
                self.layer.shadowPath = nil
            }
        }
    }
    
    // Mask to bounds controll
    @IBInspectable var maskToBounds: Bool {
        get{
            return self.layer.masksToBounds
        }
        set {
            self.layer.masksToBounds = newValue
        }
    }
    
    // Rasterize option
    @IBInspectable var rasterize: Bool {
        get {
            return self.layer.shouldRasterize
        }
        set {
            self.layer.shouldRasterize = newValue
            self.layer.rasterizationScale = UIScreen.main.scale
        }
    }
}
