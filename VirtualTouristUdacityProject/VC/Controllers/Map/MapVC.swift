//
//  MapVC.swift
//  Virtual-Tourist-Udacity
//
//  Created by Stefan Weiss on 08.04.22.
//

import UIKit
import CoreData
import MapKit

class MapVC: UIViewController {
    
    var flickrClient: FlickrClient!
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Pin>!
    var pinMO: Pin?
    var photo: Photo?
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshMapData()
        
    }
    
    //MARK: IBActions
 
    @IBAction func deletePins(_ sender: Any) {
        let annotationsToRemove = mapView.annotations.filter
        {
            $0 !==  mapView.userLocation
        }
        mapView.removeAnnotations( annotationsToRemove )
        deletePinsFromCoreData()
    }
    
    @IBAction func pressedOnMap (_ sender: UILongPressGestureRecognizer) {
        
        if sender.state != .began {
            let locationCoordinate = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
            saveGeoCoordination(from: locationCoordinate)
            return
        }
    }
    
    //MARK: saving locations and removing
    func saveLocation(_ annotation: MKPointAnnotation) {
        let location = Pin(context: dataController.viewContext)
        location.creationDate = Date()
        location.country = annotation.subtitle
        location.latitude = annotation.coordinate.latitude
        location.locationName = annotation.title
        location.longitude = annotation.coordinate.longitude
        
        try? dataController.viewContext.save()
        let annotationPin = AnnotationPin(pin: location)
        
        self.mapView.addAnnotations([annotationPin])
    }
    
    func saveGeoCoordination(from coordinate: CLLocationCoordinate2D) {
        let geoPosition = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let annotation = MKPointAnnotation()
        CLGeocoder().reverseGeocodeLocation(geoPosition) { placemarks, error in
            guard let placemark = placemarks?.first else { return }
            annotation.title = placemark.name ?? "Unknown"
            annotation.subtitle = placemark.country
            annotation.coordinate = coordinate
            self.saveLocation(annotation)
        }
    }
    
    private func deletePinsFromCoreData() {
        do{
            let request: NSFetchRequest<Pin> = Pin.fetchRequest()
            request.sortDescriptors = [ NSSortDescriptor(key:"creationDate", ascending: false) ]
            
            let locations = try dataController.viewContext.fetch(request)
            for location in locations{
                dataController.viewContext.delete(location)
                print("pinDeleted")
            }
        } catch {
            print("Failed \(error)")
        }
        do {
            try dataController.viewContext.save()
        } catch {
            print("Failed saving  \(error)")
        }
        
    }
    
    //MARK: Prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == SegueIdentifiers.SHOW_PHOTO_ALBUM_DISPLAYER {
        guard let selectedPinAnnotation = mapView.selectedAnnotations.first as? AnnotationPin,
              let photoDisplayVC = segue.destination as? AlbumCollectionVC else {
            assertionFailure()
            return
        }
        let selectedPin = selectedPinAnnotation.pin
        photoDisplayVC.pin = selectedPin
        photoDisplayVC.dataController = dataController
        photoDisplayVC.flickrClient = flickrClient
        photoDisplayVC.photo = photo
    }
}
}
