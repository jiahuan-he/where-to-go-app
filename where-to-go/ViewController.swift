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

class ViewController: UIViewController{

    var placesClient: GMSPlacesClient!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    let localisationManager = CLLocationManager()    // <-- scope to class
    
    
    
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}
    



