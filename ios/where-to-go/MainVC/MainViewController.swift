//
//  ViewController.swift
//  where-to-go
//
//  Created by LMAO on 25/11/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit
import GooglePlaces
import CoreLocation
import Alamofire
import SwiftyJSON

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

func isLocationAllowed() -> Bool{
    if CLLocationManager.locationServicesEnabled() {
        switch(CLLocationManager.authorizationStatus()) {
        case .notDetermined, .restricted, .denied:
            print("No access")
            return false
        case .authorizedAlways, .authorizedWhenInUse:
            print("Access")
            return true
        }
    } else {
        print("Location services are not enabled")
        return false
    }
}

var places = [GMSPlace]()
var currentPlace: GMSPlace?
var sentimentData = [String: [String: Double]]()
class MainViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource, GMSAutocompleteViewControllerDelegate{
    @IBOutlet weak var compareButton: UIButton!
    
    @IBOutlet weak var currentLocationLabel: UILabel!
    var placesClient: GMSPlacesClient!
    let localisationManager = CLLocationManager()
    
    var placeIndex = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews(){
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if places.count == 0 {
            compareButton.isEnabled = false
            compareButton.backgroundColor = compareButton.backgroundColor?.withAlphaComponent(0.3)
        } else {
            compareButton.isEnabled = true
            compareButton.backgroundColor = compareButton.backgroundColor?.withAlphaComponent(1)
        }
        
        placesClient = GMSPlacesClient.shared()
        if !isLocationAllowed() {
            localisationManager.requestWhenInUseAuthorization()
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        // Get user's current place
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                
                for likelihood in placeLikelihoodList.likelihoods {
                    let place = likelihood.place
//                    print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
//                    print("Current Place address \(place.formattedAddress)")
//                    print("Current Place attributions \(place.attributions)")
//                    print("Current PlaceID \(place.placeID)")
                    let addressArray = place.formattedAddress?.components(separatedBy: ",")
                    let address = addressArray![0] + ", "+addressArray![1]
                    self.currentLocationLabel.text = address
                    print(place.placeID)
                    break
                }
            }
        })
    }
    
//////////// START => Tableview data source ////////////
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = places[indexPath.row].name
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor(red: 252, green: 207, blue: 77)
        cell.textLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 18)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    
//////////// END => Tableview data source ////////////
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.placeIndex = indexPath.row
        currentPlace = places[self.placeIndex]
        performSegue(withIdentifier: "detailVC", sender: self)
    }

//////////// START => Google Places Controller delegate ////////////
    //Present the Autocomplete view controller
    @IBAction func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        filter.country = "CA"
        autocompleteController.autocompleteFilter = filter
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place attributions: \(place.placeID)")
        places.append(place)
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
        compareButton.isEnabled = true
        compareButton.backgroundColor = compareButton.backgroundColor?.withAlphaComponent(1)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func segueToStackedBarVC(_ sender: UIButton) {
        groupsData.removeAll()
//        groupsData = [(title: String, bars: [(start: Double, quantities: [Double])])]()
        performSegue(withIdentifier: "StackedBarVC", sender: self)
    }
    
    
////////////    END => Google Places Controller delegate ////////////
    
    
}



