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

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var textViewTip: UITextView!
    @IBOutlet weak var imgPhoto: UIImageView!
    
    var venueModel = VenueModel()
    var detailModel = DetailModel()
    var arrayVenue: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsPointsOfInterest = false
        mapView.showsUserLocation = true
        viewInfo.isHidden = true;
        self.loadDetailVenue()
        self.loadDataRecommend()
    }
    
    func loadDataRecommend() {
        FoursquareManager.sharedManager().searchVenuesRecommend(CLLocationCoordinate2DMake((venueModel.location?.latitude)!, (venueModel.location?.longitude)!), limit: "10", completion: {
            [weak self] recommend, error in
            self?.arrayVenue = (recommend?.items)!
            self?.loadVenueRecommend()
        })
    }
    
    func loadDetailVenue() {
        FoursquareManager.sharedManager().getDetailVenue(venueModel.idVenue, completion: {
            [weak self] detail, error in
            self?.detailModel = detail!
            self?.displayMarkersWithModel(detail!)
        })
    }
    
    func focusMapView(_ detailVenue: DetailModel) {
        let mapCenter = CLLocationCoordinate2DMake((detailVenue.location?.latitude)!, (detailVenue.location?.longitude)!)
        let span = MKCoordinateSpanMake(0.1, 0.1)
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
        
        let textTitle = detailVenue.name
        var textSub = ""
        let phone = detailVenue.contact?.phone
        let address = detailVenue.location?.address
        let rating = detailVenue.rating
        let beenHere = detailVenue.beenHere?.count
        if let address = address, !address.isEmpty {
            textSub += "\(address)"
        }
        if let phone = phone, !phone.isEmpty {
            textSub += phone
        }
        if let rating = rating, rating > 0 {
            textSub += ",rating:\(rating)"
        }
        if let beenHere = beenHere, beenHere > 0 {
            textSub += ",been there:\(beenHere)"
        }
        annotation.title = textTitle
        annotation.subtitle = textSub

        mapView.addAnnotation(annotation)
        self.focusMapView(detailVenue)
    }
    
    @IBAction func didTapCloseButton(_ sender: AnyObject) {
        viewInfo.isHidden = true;
    }
    
    // MARK: - MapView delegate
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            viewInfo.isHidden = false;
            var textTips = ""
            for venue in self.arrayVenue {
                if venue.venue?.name == (view.annotation?.title)! {
                    // load TIP
                    var arrayTip: [ItemTip] = []
                    arrayTip = venue.tips!
                    for tip in arrayTip {
                        let textTip = tip.text
                        if let textTip = textTip, !textTip.isEmpty  {
                            textTips += textTip
                        }
                        
                    }
                    
                    // load PHOTO
                    imgPhoto?.sd_cancelCurrentAnimationImagesLoad()
                    var imgURL: URL? = nil
                    if let group = venue.venue?.photos?.groups![0] {
                        if let item = group.items {
                            if !item.isEmpty {
                                imgURL = URL(string: (item[0].photoUrl))
                            }
                        }
                        imgPhoto?.sd_setImage(with: imgURL, placeholderImage: UIImage(named: "none"))
                    }
                }
            }
            textViewTip.text = textTips
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
}
