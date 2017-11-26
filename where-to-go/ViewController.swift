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
import Charts


//
//func isLocationPermissionGranted() -> Bool
//{
//    guard CLLocationManager.locationServicesEnabled() else { return false }
//    return [.authorizedAlways, .authorizedWhenInUse].contains(CLLocationManager.authorizationStatus())
//}

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

class ViewController: UIViewController, GMSAutocompleteViewControllerDelegate{
    
    var placesClient: GMSPlacesClient!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    let localisationManager = CLLocationManager()
    
    //Present the Autocomplete view controller
    @IBAction func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
  
    func requestAuthorization() {
        localisationManager.requestWhenInUseAuthorization()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        placesClient = GMSPlacesClient.shared()
        if !isLocationAllowed() {
            requestAuthorization()
        }
    }
    
    @IBAction func getCurrentPlace(_ sender: UIButton) {
        // For getting the user permission to use location service when the app is running
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            self.nameLabel.text = "No current place"
            self.addressLabel.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.nameLabel.text = place.name
                    self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: "\n")
                }
            }
        })
    }
    
    
    
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
//
//extension ViewController: GMSAutocompleteViewControllerDelegate {
//    
//    // Handle the user's selection.
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        print("Place name: \(place.name)")
//        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
//        dismiss(animated: true, completion: nil)
//    }
//    
//    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
//        // TODO: handle the error.
//        print("Error: ", error.localizedDescription)
//    }
//    
//    // User canceled the operation.
//    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//        dismiss(animated: true, completion: nil)
//    }
//    
//    // Turn the network activity indicator on and off again.
//    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    }
//    
//    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//    }
//    
//}



