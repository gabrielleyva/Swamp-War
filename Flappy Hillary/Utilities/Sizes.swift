//
//  Sizes.swift
//  Flappy Hillary
//
//  Created by Gabriel I Leyva Merino on 12/31/17.
//  Copyright © 2017 Will Clark. All rights reserved.
//

import UIKit
import SpriteKit

func getSizeBasedOnDevice(view: UIView, normalSize: Float) -> CGFloat{
    let proportion = 667 / normalSize
    let newSize = view.frame.size.height / CGFloat(proportion)

    return CGFloat(newSize)
}

func getSizeBasedOnDevice(height: CGFloat, normalSize: Float) -> CGFloat{
    let proportion = 667 / normalSize
    let newSize = height / CGFloat(proportion)
    
    return CGFloat(newSize)
}

func getSizeBasedOnDevice(view: SKView, normalSize: Float) -> CGFloat{
    let proportion = 667 / normalSize
    let newSize = view.frame.size.height / CGFloat(proportion)
    
    return CGFloat(newSize)
}


