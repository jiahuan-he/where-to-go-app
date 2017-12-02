//
//  DetailViewController.swift
//  where-to-go
//
//  Created by LMAO on 27/11/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit
import GooglePlaces
import Alamofire

let myURL = "http://localhost:8081"

class DetailViewController: UIViewController {
    @IBOutlet weak var imageScrollView: UIScrollView!
    var imageArray = [UIImage]()
//    var pID = "ChIJc25VPTfxBFMRtGozJ2FokKQ"
    var place : GMSPlace?
    @IBOutlet weak var placeNameLabel: UILabel!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    /// Return the appropriate text string for the specified |GMSPlacesOpenNowStatus|.
    private func text(for status: GMSPlacesOpenNowStatus) -> String {
        switch status {
        case .no: return "Closed"
        case .yes: return "Open"
        case .unknown: return "Unknown"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        phoneButton.setImage(UIImage(named:#imageLiteral(resourceName: "phone-icon")), for: UIControlState.normal)
        self.place = currentPlace
        phoneButton.setImage(#imageLiteral(resourceName: "phone-icon"), for: UIControlState.normal)
        phoneButton.tintColor = UIColor.white
        websiteButton.setImage(#imageLiteral(resourceName: "web-icon"), for: UIControlState.normal)
        websiteButton.tintColor = UIColor.white
        
        phoneButton.addTarget(self, action: #selector(self.phoneButtonClicked), for: .touchUpInside)
        websiteButton.addTarget(self, action: #selector(self.websiteButtonClicked), for: .touchUpInside)
        // Do any additional setup after loading the view.
        loadFirstPhotoForPlace(placeID: (self.place?.placeID)!)
        placeNameLabel.text = place?.name
        
        let addressArray = place?.formattedAddress?.components(separatedBy: ",")
        let address = addressArray![0] + ", "+addressArray![1]
        addressLabel.text = address
        ratingLabel.text = String(describing: round(Double((100*(place?.rating)!)))/100)
        Alamofire.request(myURL).responseString(completionHandler: { response in
            print(response)
        })
    }
    @objc func websiteButtonClicked(){
        //        let trimmedNumber = self.place!.phoneNumber?.trimmingCharacters(in: .whitespaces)
        if let url = self.place!.website, UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                print("calling")
                UIApplication.shared.open(url)
            } else {
                print("calling")
                UIApplication.shared.openURL(url)
            }
        } else {
            let alert = UIAlertController(title: "Oops", message: "This place dosen't have a website", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func phoneButtonClicked(){
        if self.place!.phoneNumber == nil{
            let alert = UIAlertController(title: "Oops", message: "This place dosen't have phone number", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
//        let trimmedNumber = self.place!.phoneNumber?.trimmingCharacters(in: .whitespaces)
        let phoneNumber = self.place!.phoneNumber!.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression, range: nil)
        if let url = URL(string: "tel://\(String(describing: phoneNumber))"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                print("calling")
                UIApplication.shared.open(url)
            } else {
                    print("calling")
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func loadFirstPhotoForPlace(placeID: String) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
//                if let firstPhoto = photos?.results.first {
//                    self.loadImageForMetadata(photoMetadata: firstPhoto)
//                }
                if let photos = photos?.results{
                    for photo in photos{
                        self.loadImageForMetadata(photoMetadata: photo)
                    }
                }
            }
        }
    }
    
    var photoCount = 0
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata){
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
//                print("appending photo")
                self.imageArray.append(photo!)
                
                let imageView = UIImageView()
                imageView.image = photo
                let xPosition = self.view.frame.width * CGFloat(self.photoCount)
                imageView.frame = CGRect(x: xPosition, y:0, width: self.imageScrollView.frame.width, height: self.imageScrollView.frame.height)
                self.imageScrollView.contentSize.width = self.imageScrollView.frame.width * CGFloat(self.photoCount+1)
                self.imageScrollView.addSubview(imageView)
                self.photoCount = self.photoCount + 1
                
                // Limit number of photos to 6
                if self.photoCount >= 6 {
                    return
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if(segue.identifier == "reviewAnalysisVC"){
//            let vc = segue.destination as! ReviewAnalysisVC
//            vc.place = self.place!
//        }
//    }
 

}
