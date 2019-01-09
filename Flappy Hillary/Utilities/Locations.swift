//
//  Locations.swift
//  Flappy Hillary
//
//  Created by Gabriel I Leyva Merino on 12/31/17.
//  Copyright © 2017 Will Clark. All rights reserved.
//
import UIKit
import SpriteKit

func getPositionBasedOnDevice(view: UIView, position: Float) -> CGFloat{
    let proportion = 667 / position
    let newPos = view.frame.size.height / CGFloat(proportion)
    
    return CGFloat(newPos)
}

func getPositionBasedOnDevice(height: CGFloat, position: Float) -> CGFloat{
    let proportion = 667 / position
    let newPos = height / CGFloat(proportion)
    
    return CGFloat(newPos)
}

func getPositionBasedOnDevice(view: SKView, position: Float) -> CGFloat{
    let proportion = 667 / position
    let newPos = view.frame.size.height / CGFloat(proportion)
    
    return CGFloat(newPos)
}
