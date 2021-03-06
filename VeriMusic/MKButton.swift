//
//  MKButton.swift
//  Ertir
//
//  Created by Atakishiyev Orazdurdy on 2/13/15.
//  Copyright (c) 2015 Atakishiyev Orazdurdy. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class MKButton : UIButton
{
    @IBInspectable var maskEnabled: Bool = true {
        didSet {
            mkLayer.enableMask(enable: maskEnabled)
        }
    }
    @IBInspectable var rippleLocation: MKRippleLocation = .TapLocation {
        didSet {
            mkLayer.rippleLocation = rippleLocation
        }
    }
    @IBInspectable var circleGrowRatioMax: Float = 0.9 {
        didSet {
            mkLayer.circleGrowRatioMax = circleGrowRatioMax
        }
    }
    @IBInspectable var backgroundLayerCornerRadius: CGFloat = 0.0 {
        didSet {
            mkLayer.setBackgroundLayerCornerRadius(backgroundLayerCornerRadius)
        }
    }
    // animations
    @IBInspectable var shadowAniEnabled: Bool = true
    @IBInspectable var backgroundAniEnabled: Bool = true {
        didSet {
            if !backgroundAniEnabled {
                mkLayer.enableOnlyCircleLayer()
            }
        }
    }
    @IBInspectable var aniDuration: Float = 0.65
    @IBInspectable var circleAniTimingFunction: MKTimingFunction = .Linear
    @IBInspectable var backgroundAniTimingFunction: MKTimingFunction = .Linear
    @IBInspectable var shadowAniTimingFunction: MKTimingFunction = .EaseOut
    
    @IBInspectable var cornerRadius: CGFloat = 2.5 {
        didSet {
            layer.cornerRadius = cornerRadius
            mkLayer.setMaskLayerCornerRadius(cornerRadius)
        }
    }
    // color
    @IBInspectable var backgroundLayerColor: UIColor = UIColor(white: 0.75, alpha: 0.25) {
        didSet {
            mkLayer.setBackgroundLayerColor(backgroundLayerColor)
        }
    }
    override var bounds: CGRect {
        didSet {
            mkLayer.superLayerDidResize()
        }
    }
    
    private lazy var mkLayer: MKLayer = MKLayer(superLayer: self.layer)
    
    // MARK - initilization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
    }
    
    // MARK - setup methods
    private func setupLayer() {
        adjustsImageWhenHighlighted = false
        self.cornerRadius = 2.5
        mkLayer.setBackgroundLayerColor(backgroundLayerColor)
    }
    
    // MARK - location tracking methods
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        if rippleLocation == .TapLocation {
            mkLayer.didChangeTapLocation(touch.locationInView(self))
        }
        
        // circleLayer animation
        mkLayer.animateScaleForCircleLayer(0.45, toScale: 1.0, timingFunction: circleAniTimingFunction, duration: CFTimeInterval(aniDuration))
        
        // backgroundLayer animation
        if backgroundAniEnabled {
            mkLayer.animateAlphaForBackgroundLayer(backgroundAniTimingFunction, duration: CFTimeInterval(aniDuration))
        }
        
        // shadow animation for self
        if shadowAniEnabled {
            let shadowRadius = self.layer.shadowRadius
            let shadowOpacity = self.layer.shadowOpacity
            
            //if mkType == .Flat {
            //    mkLayer.animateMaskLayerShadow()
            //} else {
            mkLayer.animateSuperLayerShadow(10, toRadius: shadowRadius, fromOpacity: 0, toOpacity: shadowOpacity, timingFunction: shadowAniTimingFunction, duration: CFTimeInterval(aniDuration))
            //}
        }
        
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }
}