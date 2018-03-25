//
//  ViewController.swift
//  NTA_Demo_Foursquare
//
//  Created by AnhNguyen on 3/22/18.
//  Copyright © 2018 ATA_Studio. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, UITabBarDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let mapViewSegueIdentifier = "ShowMapview"
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    var isLocationInitialized = false
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        locationManager.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .onDrag
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - SearchBar delegate
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if isLocationInitialized {
            FoursquareManager.sharedManager().searchVenuesWithCoordinate((userLocation?.coordinate)!, query: searchBar.text!, limit: "50", completion: {
                [weak self] (error) in
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                self?.tableView.reloadData()
            })
        }
    }
    
    // MARK: - CLLocationManager delegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last,
            CLLocationCoordinate2DIsValid(newLocation.coordinate) else {
                return
        }
        
        self.userLocation = newLocation
        
        if isLocationInitialized == false {
            isLocationInitialized = true
        }
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FoursquareManager.sharedManager().venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "venueCell", for: indexPath) as UITableViewCell
        let venue = FoursquareManager.sharedManager().venues[(indexPath as NSIndexPath).row]
        
        // Configure the cell...
        cell.textLabel?.text = venue.name
        cell.detailTextLabel?.text = venue.location?.address
        cell.imageView?.sd_cancelCurrentAnimationImagesLoad()
        
        var categoryIconURL: URL? = nil
        if let categories = venue.categories {
            if !categories.isEmpty {
                categoryIconURL = URL(string: (categories[0].icon?.categoryIconUrl)!)
            }
        }
        cell.imageView?.sd_setImage(with: categoryIconURL, placeholderImage: UIImage(named: "none"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: mapViewSegueIdentifier, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == mapViewSegueIdentifier {
            let destination = segue.destination as? MapViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = FoursquareManager.sharedManager().venues[indexPath.row]
                destination?.venueModel = object
            }
        }
    }
}

