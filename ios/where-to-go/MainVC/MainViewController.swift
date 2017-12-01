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
                    self.currentLocationLabel.text = place.formattedAddress
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
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func segueToStackedBarVC(_ sender: UIButton) {
        performSegue(withIdentifier: "StackedBarVC", sender: self)
    }
    
    
////////////    END => Google Places Controller delegate ////////////
    
//////////// START => Segues ////////////
    
    
//    @IBAction func segueToBarVC(_ sender: UIButton) {
//        let getSentimentURL: String = "\(myURL)/analysis/sentiment"
//        let parameter = ["pids": places.map({
//            (place: GMSPlace) -> String in
//            return place.placeID
//        })]
//        
//        Alamofire.request(getSentimentURL, method: .post, parameters: parameter).responseJSON(completionHandler: {
//            response in
//            if let result = response.result.value {
//                let sentimentData = JSON(result).dictionaryValue
//                print(sentimentData)
//                for place in places{
//                    let pid = place.placeID
//                    let title = place.name
//                    let score = sentimentData[pid]?.dictionaryValue["score"]!.doubleValue.rounded(toPlaces: 4)
//                    let magnitude = sentimentData[pid]?.dictionaryValue["magnitude"]!.doubleValue.rounded(toPlaces: 4)
//                    print(title)
//                    print(score!)
//                    print(magnitude as Any)
//                    var quantity: [Double] = Array.init(repeating: 0, count: 6)
//                    var index = 0
//                    if score! < -0.66 {
//                        index = 0
//                    } else if score! < -0.33 {
//                        index = 1
//                    } else if score! < 0 {
//                        index = 2
//                    } else if score! < 0.33 {
//                        index = 3
//                    } else if score! < 0.66 {
//                        index = 4
//                    } else {
//                        index = 5
//                    }
//                    quantity.insert(magnitude!, at: index)
//                    groupsData.append((title, [(0, quantity)]))
//                }
//                print("start", Date())
//                self.performSegue(withIdentifier: "StackedBarVC", sender: self)
//            }
//        }
//        )
//    }
    
//////////// END => Segues ////////////
    
    
}



