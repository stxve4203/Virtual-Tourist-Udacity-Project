//
//  AlbumCollectionVC.swift
//  Virtual-Tourist-Udacity
//
//  Created by Stefan Weiss on 08.04.22.
//

import UIKit
import CoreData

class AlbumCollectionVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    var flickrClient: FlickrClient!
    
    var pin: Pin!
    
    var dataController: DataController!
    
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    
    var mapToInset: CGFloat!
    
    var photo: Photo!
    
    lazy var allPhotos = pin.photos?.allObjects as! [Photo]
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var placeName: String! = pin.locationName
        if placeName == nil {
            placeName = "Unknown"
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        title = placeName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //configureFlowLayout()
        setupFetchedResultsController()
        downloadPhotos()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController = nil
    }
    
    func reloadPhotos() {
        allPhotos = pin.photos!.allObjects as! [Photo]
        collectionView.reloadData()
    }
    
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        reloadPhotos()
    }
    
    
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        
            let predicate = NSPredicate(format: "pin == %@", pin)
            fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "photo")
        
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("failed fetching photos.")
        }
    }
    
    func downloadPhotos() {

        if pin.photos!.count > 0 {
            // load from core data
            self.reloadPhotos()
        } else {
            
        pin.photos = []
        
        flickrClient.getImagesFromFlickrURL(latitude: pin.latitude, longitude: pin.longitude) { response, error in

            for image in response {
                let totalPhotos = response.count
                let newPhoto = Photo(context: self.dataController.viewContext)
                newPhoto.imageID = image.id
                newPhoto.imageURL = URL(string: image.url_m!)!
                self.pin.addToPhotos(newPhoto)
                try? self.dataController.viewContext.save()
                self.reloadPhotos()
                }
            }
        }
        }
    
    func entityIsEmpty() -> Bool
    {
        var error: ErrorPointer!
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        var results: [Photo] =  try! self.dataController.viewContext.fetch(fetchRequest)

        var count = try! dataController.viewContext.count(for: fetchRequest)
print(count)
        
        if error != nil
        {
            print("Error: \(error.debugDescription)")
            return true
        }
        else
        {
            if count == 0
            {
                return true
            }
            else
            {
                return false
            }

        }


    }
    }


