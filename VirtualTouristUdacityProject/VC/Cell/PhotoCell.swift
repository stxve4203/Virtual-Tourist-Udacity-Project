//
//  PhotoCell.swift
//  Virtual-Tourist-Udacity
//
//  Created by Stefan Weiss on 08.04.22.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    func setUpImageView(imageView: UIImage) {
        photoImageView.image = imageView
    }
}
