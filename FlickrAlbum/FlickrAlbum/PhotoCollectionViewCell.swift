//
//  PhotoCollectionViewCell.swift
//  FlickrAlbum
//
//  Created by Student on 5/2/16.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation
import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet private weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var caption: UILabel!
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        if let attributes = layoutAttributes as? CellLayoutAttributes {
            imageViewHeightLayoutConstraint.constant = attributes.photoHeight
    }
}
}
