//
//  DetailViewController.swift
//  where-to-go
//
//  Created by LMAO on 27/11/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit
import GooglePlaces

class DetailViewController: UIViewController {
    @IBOutlet weak var imageScrollView: UIScrollView!
    var imageArray = [UIImage]()
//    var pID = "ChIJc25VPTfxBFMRtGozJ2FokKQ"
    var place : GMSPlace?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadFirstPhotoForPlace(placeID: (self.place?.placeID)!)
    }
    
    func loadFirstPhotoForPlace(placeID: String) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            print()
            print("load photos called! ")
            print()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
