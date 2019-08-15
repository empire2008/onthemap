//
//  FindLocationViewController.swift
//  OnTheMap
//
//  Created by Nuttapong Nateetaweesak on 8/8/2562 BE.
//  Copyright © 2562 Nuttapong Nateetaweesak. All rights reserved.
//

import UIKit
import MapKit

class FindLocationViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
//    var locationName: String?
//    var website: String?
//    var latitude: Double?
//    var longitude: Double?
    var annotation: MKPointAnnotation?
    var annotationView: MKAnnotationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.setActiveIndicator(isShowed: true)
            self.getLocation()
        }
    }
    
    func updatePostLocation(latitude: Double, longitude: Double){
        UdacityClient.Auth.userPosted.latitude = latitude
        UdacityClient.Auth.userPosted.longitude = longitude
    }
    
    func getLocation(){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(UdacityClient.Auth.userPosted.mapString) { (placemarks, error) in
            self.setActiveIndicator(isShowed: false)
            if error != nil{
                self.actionAlert(topic: "Location not found!", message: nil, complition: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
            }
            else if let placemarks = placemarks{
                if placemarks.count > 0{
                    self.updatePostLocation(latitude: (placemarks[0].location?.coordinate.latitude)!, longitude: (placemarks[0].location?.coordinate.longitude)!)
                    DispatchQueue.main.async {
                        self.pointToLocation()
                    }
                }
                else {
                    self.actionAlert(topic: "Location not found!", message: nil, complition: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    })
                }
            }
            else {
                self.actionAlert(topic: "Location not found!", message: nil, complition: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    func handleLocationResponse(success: Bool, error: Error?){
        if success{
            self.actionAlert(topic: "Successful", message: "Location Added") { (action) in
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
        else{
            self.popupAlert(topic: "Failed", message: "Please try again")
        }
    }
    
    func pointToLocation(){
        annotation = MKPointAnnotation()
        annotation!.coordinate = CLLocationCoordinate2D(latitude: UdacityClient.Auth.userPosted.latitude, longitude: UdacityClient.Auth.userPosted.longitude)
        annotation!.title = UdacityClient.Auth.userPosted.mapString
        annotation!.subtitle = UdacityClient.Auth.userPosted.mediaURL
        mapView.addAnnotation(annotation!)
        
        mapView.setRegion(MKCoordinateRegion(center: annotation!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)), animated: false)
    }
    
    @IBAction func confirmButton(_ sender: Any) {
        UdacityClient.postLocation(completion: handleLocationResponse(success:error:))
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension FindLocationViewController{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "userPins"
        annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        if annotation is MKUserLocation{
            return nil
        }
        annotationView?.canShowCallout = true
        annotationView?.isDraggable = true
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        let location = view.annotation?.coordinate
        UdacityClient.Auth.userPosted.latitude = location!.latitude
        UdacityClient.Auth.userPosted.longitude = location!.longitude
        self.updatePostLocation(latitude: location!.latitude, longitude: location!.longitude)
    }
}

extension FindLocationViewController{
    func setActiveIndicator(isShowed: Bool){
        indicatorView.isHidden = !isShowed
        if isShowed{
            indicatorView.startAnimating()
        }
        else{
            indicatorView.stopAnimating()
        }
    }
}
