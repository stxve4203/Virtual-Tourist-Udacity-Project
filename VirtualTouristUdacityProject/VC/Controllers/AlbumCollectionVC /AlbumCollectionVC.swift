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
    
    var randomPages: Int!
    var maxPages: Int!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
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
        downloadPhotos(page: 1)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController = nil
    }
    
    func reloadPhotos() {
        allPhotos = pin.photos!.allObjects as! [Photo]
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        reloadPhotos()
        let pinPages = pin.maxPages
        let randomPage = Int.random(in: 1...Int(pinPages))
        self.allPhotos.removeAll()
        self.collectionView.reloadData()
        downloadPhotos(page: randomPage)
        print(randomPage)
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
    
    func downloadPhotos(page: Int) {
        
        let photo = allPhotos
        if photo.count > 0 {
            // load from core data
            print("photos are in core data")
        } else {
            pin.photos = []
            DispatchQueue.main.async {
                //  // 1...(total photos returned) / Photos Per Page.
                //
                // (total photos available)/(page size)
                
                self.flickrClient.getImagesFromFlickrURL(latitude: self.pin.latitude, longitude: self.pin.longitude, page: page) { response, page, error  in
                    for image in response {
                        let newPhoto = Photo(context: self.dataController.viewContext)
                        newPhoto.imageID = image.id
                        newPhoto.imageURL = URL(string: image.url_m!)!
                        
                        DispatchQueue.global(qos: .utility).async {
                        let source = URL(string: image.url_m!)
                        self.flickrClient.downloadImage(img: source) { data, error in
                            let imageAsData = data!.jpegData(compressionQuality: 1)
                            newPhoto.imageData = imageAsData
                            self.pin.addToPhotos(newPhoto)
                            try? self.dataController.viewContext.save()
                            self.reloadPhotos()
                        }
                        }
                    }
                }
                
            }
        }
    }
}

