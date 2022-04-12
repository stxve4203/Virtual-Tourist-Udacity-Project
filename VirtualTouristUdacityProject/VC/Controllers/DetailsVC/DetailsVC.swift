//
//  DetailsVC.swift
//  VirtualTouristUdacityProject
//
//  Created by Stefan Weiss on 12.04.22.
//

import UIKit

class DetailsVC: UIViewController {

    var flickrClient: FlickrClient!
    var photo: Photo!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let source = photo.imageURL {
            flickrClient.downloadImage(img: source) { data, error in
                if let data = data {
                    DispatchQueue.main.async {
                        self.imageView.image = data
                    }
    }


}
        }
    }
}
