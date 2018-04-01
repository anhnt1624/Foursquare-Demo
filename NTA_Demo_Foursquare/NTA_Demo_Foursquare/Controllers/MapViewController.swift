//
//  MapViewController.swift
//  NTA_Demo_Foursquare
//
//  Created by AnhNguyen on 3/24/18.
//  Copyright © 2018 ATA_Studio. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


extension CLLocationCoordinate2D {
    func isEqual(_ coord: CLLocationCoordinate2D) -> Bool {
        return (fabs(self.latitude - coord.latitude) < 0.01) && (fabs(self.longitude - coord.longitude) < 0.01)
    }
}

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var btnMore: UIButton!
    
    @IBOutlet weak var lblNameVenue: UILabel!
    @IBOutlet weak var lblAddressVenue: UILabel!
    @IBOutlet weak var lblRatingVenue: UILabel!
    @IBOutlet weak var lblPhoneVenue: UILabel!
    @IBOutlet weak var lblBeenHereVenue: UILabel!
    
    var currentLocation: CLLocationCoordinate2D?
    var venueModel = VenueModel()
    var detailModel = DetailModel()
    var itemVenue = Item()
    var arrayVenue: [Item] = []
    
    let detailVenueSegueIdentifier = "DetailView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Venue"
        mapView.delegate = self
        mapView.showsPointsOfInterest = false
        mapView.showsUserLocation = true
        viewInfo.isHidden = true;
        self.loadDetailVenue(venueModel.idVenue)
        self.currentLocation = (CLLocationCoordinate2DMake((venueModel.location?.latitude)!, (venueModel.location?.longitude)!))
        self.loadDataRecommend(currentLocation!)
    }
    
    func loadDataRecommend(_ coordinate: CLLocationCoordinate2D) {
        FoursquareManager.sharedManager().searchVenuesRecommend(coordinate, limit: "10", completion: {
            [weak self] recommend, error in
            if recommend != nil {
                self?.arrayVenue = (recommend?.items)!
                self?.loadVenueRecommend()
            }
        })
    }
    
    func loadDetailVenue(_ idVenue: String) {
        FoursquareManager.sharedManager().getDetailVenue(idVenue, completion: {
            [weak self] detail, error in
            if let obj = detail {
                self?.displayMarkersWithModel(obj)
                self?.focusMapView(obj)
            }
        })
    }
    
    func focusMapView(_ detailVenue: DetailModel) {
        let mapCenter = CLLocationCoordinate2DMake((detailVenue.location?.latitude)!, (detailVenue.location?.longitude)!)
        let span = MKCoordinateSpanMake(0.15, 0.15)
        let region = MKCoordinateRegionMake(mapCenter, span)
        mapView.region = region
    }
    
    func loadVenueRecommend() {
        for venue in self.arrayVenue {
            self.displayMarkersWithModel(venue.venue!)
        }
    }
    
    func displayMarkersWithModel(_ detailVenue: DetailModel) {
        let annotationView = MKAnnotationView()
        let detailButton: UIButton = UIButton(type: UIButtonType.detailDisclosure) as UIButton
        annotationView.rightCalloutAccessoryView = detailButton
        
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: (detailVenue.location?.latitude)!, longitude:(detailVenue.location?.longitude)!)
        annotation.coordinate = centerCoordinate
        annotation.title = detailVenue.name
        annotation.subtitle = detailVenue.location?.address

        mapView.addAnnotation(annotation)
    }
    
    // MARK: - MapView delegate
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            viewInfo.isHidden = false
            btnMore.isEnabled = false
            for venue in self.arrayVenue {
                if venue.venue?.name == (view.annotation?.title)! {
                    let textTitle = venue.venue?.name
                    if let textTitle = textTitle, !textTitle.isEmpty {
                        self.lblNameVenue.text = textTitle
                    }
                    let address = venue.venue?.location?.address
                    if let address = address, !address.isEmpty {
                        self.lblAddressVenue.text = address
                    } else {
                        self.lblAddressVenue.text = ""
                    }
                    FoursquareManager.sharedManager().getDetailVenue((venue.venue?.idVenue)!, completion: {
                        [weak self] detail, error in
                        self?.btnMore.isEnabled = true
                        let phone = detail?.contact?.phone
                        if let phone = phone, !phone.isEmpty {
                            self?.lblPhoneVenue.text = "Phone : \(phone)"
                        } else {
                            self?.lblPhoneVenue.text = ""
                        }
                        let rating = detail?.rating
                        if let rating = rating, rating > 0 {
                            self?.lblRatingVenue.text = "Rating : \(rating)"
                        } else {
                            self?.lblRatingVenue.text = ""
                        }
                        let beenHere = detail?.beenHere?.count
                        if let beenHere = beenHere, beenHere > 0 {
                            self?.lblBeenHereVenue.text = "Been there : \(beenHere)"
                        } else {
                            self?.lblBeenHereVenue.text =  ""
                        }
                        self?.itemVenue = venue
                        self?.detailModel = detail!
                    })
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
        }
        
        let button = UIButton(type: UIButtonType.detailDisclosure) as UIButton
        pinView?.rightCalloutAccessoryView = button
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if !(self.currentLocation?.isEqual(self.mapView.centerCoordinate))! {
            self.mapView.removeAnnotations(mapView.annotations)
            self.loadDataRecommend(mapView.centerCoordinate)
            self.currentLocation = mapView.centerCoordinate
        }
    }
    
    @IBAction func didTapCloseButton(_ sender: AnyObject) {
        viewInfo.isHidden = true;
    }
    
    @IBAction func didTapMoreButton(_ sender: Any) {

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == detailVenueSegueIdentifier {
            let destination = segue.destination as? DetailVenueController
            destination?.detailModel = self.detailModel
        }
    }
}
