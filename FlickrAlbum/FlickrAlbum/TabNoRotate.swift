//
//  TabNoRotate.swift
//  FlickrAlbum
//
//  Created by Student on 11/2/16.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation
import UIKit

class TabNoRotate:UITabBarController {
    
    override func shouldAutorotate() -> Bool {
        
        return false
        
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        return [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.PortraitUpsideDown]
        
    }
    
}