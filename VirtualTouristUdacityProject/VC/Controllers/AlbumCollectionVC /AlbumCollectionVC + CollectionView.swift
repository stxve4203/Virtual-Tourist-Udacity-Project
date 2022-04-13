//
//  AlbumCollectionVC + Extensions.swift
//  Virtual-Tourist-Udacity
//
//  Created by Stefan Weiss on 08.04.22.
//

import Foundation
import CoreData
import UIKit

extension AlbumCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.PHOTO_COLLECTION_VIEW_CELL, for: indexPath) as! PhotoCell
            
            // If there are some persisted images, use them as datasource.
             let photo = allPhotos[indexPath.row]
        if (photo.imageData == nil) {
            cell.activityIndicator.startAnimating()
            downloadPhotos()
            DispatchQueue.main.async {
                let image = UIImage(data: photo.imageData!)
                cell.photoImageView.image = image
                cell.activityIndicator.stopAnimating()
            }
            
        } else {
            let image = UIImage(data: photo.imageData!)
            cell.photoImageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = allPhotos[indexPath.row]
        dataController.viewContext.delete(photo)
        try! dataController.viewContext.save()
        reloadPhotos()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoViewSegue" {
            if let detailsVC = segue.destination as? DetailsVC {
                if let sendPhoto = sender as? Photo {
                    detailsVC.photo = sendPhoto
                }
                
                detailsVC.flickrClient = flickrClient
            }

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 3

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }
}

