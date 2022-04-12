//
//  DetailsVC.swift
//  VirtualTouristUdacityProject
//
//  Created by Stefan Weiss on 12.04.22.
//

import UIKit

class DetailsVC: UIViewController {

    var strd: UIImage!

    var titles: String!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        strd = imageView.image
     
        print(strd)
        print(titles)
    }


}
