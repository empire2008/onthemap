//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Nuttapong Nateetaweesak on 3/8/2562 BE.
//  Copyright © 2562 Nuttapong Nateetaweesak. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var mapView: MKMapView!
    
    var annotationView: MKAnnotationView?
    var annotations: [MKAnnotation] = []
    var selectLink = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UdacityClient.getLocations(url: UdacityClient.EndPoint.getLimitLocations(100).url, completion: handleLocationsResponse(data:error:))
    }
    
    func handleLocationsResponse(data: LocationsResponse?, error: Error?){
        if let data = data{
            UdacityClient.Auth.userList.removeAll()
            for user in data.results{
                UdacityClient.Auth.userList.append(user)
            }
            self.loadAllAnnotations()
            self.mapView.addAnnotations(self.annotations)
        }
        else{
            self.popupAlert(topic: "Download Failed", message: error?.localizedDescription ?? "")
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        UdacityClient.Auth.key = ""
        UdacityClient.Auth.sessionId = ""
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        mapView.removeAnnotations(annotations)
        annotations.removeAll()
        UdacityClient.Auth.userList.removeAll()
        UdacityClient.getLocations(url: UdacityClient.EndPoint.getLimitLocations(100).url, completion: handleLocationsResponse(data:error:))
    }
    
    @IBAction func addButton(_ sender: Any) {
        self.performSegue(withIdentifier: "AddLocation", sender: self)
    }
}

// Mark: Annotations //
extension MapViewController{
    func loadAllAnnotations(){
        for location in UdacityClient.Auth.userList{
            let annotation = MKPointAnnotation()
            annotation.title = "\(location.firstName) \(location.lastName)"
            annotation.subtitle = location.mediaURL
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            annotations.append(annotation)
        }
    }
    
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
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(openSafari(_:)))
        selectLink = (view.annotation?.subtitle)! ?? ""
        view.addGestureRecognizer(gesture)
    }
    
    @objc func openSafari(_ sender: UITapGestureRecognizer){
        guard let url = URL(string: selectLink) else { return }
        UIApplication.shared.open(url)
    }
}
