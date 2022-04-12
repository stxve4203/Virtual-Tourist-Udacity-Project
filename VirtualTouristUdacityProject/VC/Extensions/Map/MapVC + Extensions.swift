//
//  MapVC + Extensions.swift
//  Virtual-Tourist-Udacity
//
//  Created by Stefan Weiss on 08.04.22.
//

import Foundation
import MapKit
import CoreData

extension MapVC: MKMapViewDelegate, NSFetchedResultsControllerDelegate {
    
    func refreshMapData() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        let request: NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        dataController.viewContext.perform {
            do {
                let pins = try self.dataController.viewContext.fetch(request)
                self.mapView.addAnnotations(pins.map { pin in AnnotationPin(pin: pin) })
            } catch {
                // show error alert
                print("Error fetching pins. ")
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: pinId) as? MKPinAnnotationView
        
        let pinAnnotation = annotation as! AnnotationPin
        pinAnnotation.title = pinAnnotation.pin.locationName
        pinAnnotation.subtitle = pinAnnotation.pin.country

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinId)
            pinView!.pinTintColor = .blue
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func saveMapLocation() {
        let mapLocation = [
            "latitude" : mapView.region.center.latitude,
            "longitude" : mapView.region.center.longitude,
            "latitudeDelta" : mapView.region.span.latitudeDelta,
            "longitudeDelta" : mapView.region.span.longitudeDelta
        ]
        UserDefaults.standard.set(mapLocation, forKey: Constants.LOCATION_KEY)
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        self.saveMapLocation()
    }
    
    func loadPersistedLocation() {
        if let mapLocation = UserDefaults.standard.dictionary(forKey: Constants.LOCATION_KEY) {
            let location = mapLocation as! [String: CLLocationDegrees]
            let center = CLLocationCoordinate2D(latitude: location["latitude"]!, longitude: location["longitude"]!)
            let span = MKCoordinateSpan(latitudeDelta: location["latitudeDelta"]!, longitudeDelta: location["longitudeDelta"]!)
            
            mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard view.annotation  is AnnotationPin else {
            return
        }
        performSegue(withIdentifier: SegueIdentifiers.SHOW_PHOTO_ALBUM_DISPLAYER, sender: self)
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        guard let views = view.annotation else {
            print("error finding view to pin")
            return
        }
        if let annotation = view.annotation {
            do {
                let predicate = NSPredicate(format: "longitude = %@ AND latitude = %@", argumentArray: [annotation.coordinate.longitude, annotation.coordinate.latitude])
                let pinData = try dataController.fetchLocation(predicate)!
                let annotationPin = AnnotationPin(pin: pinData)
                self.performSegue(withIdentifier: SegueIdentifiers.SHOW_PHOTO_ALBUM_DISPLAYER, sender: annotationPin)
            } catch {
                print("There was an error finding photos for this location,")
            }
        }
    }
    
}
