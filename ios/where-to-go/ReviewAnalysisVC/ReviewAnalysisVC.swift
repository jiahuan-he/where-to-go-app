//
//  ReviewanalysisVC.swift
//  where-to-go
//
//  Created by LMAO on 29/11/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//



import UIKit
import Alamofire
import GooglePlaces
import SwiftyJSON


class ReviewAnalysisVC: UIViewController {
    var place: GMSPlace?
    var currentYPosition = CGFloat(20)
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let getReviewsURL: String = "\(myURL)/\(place!.placeID)/reviews"
        Alamofire.request(getReviewsURL).responseJSON(completionHandler: {
            response in
            if let result = response.result.value {
                let reviews = JSON(result)
//                print(reviews)
                self.addHeaderView(title: "REVIEWS")
                for review in reviews["reviews"].arrayValue{
                    let rating = review["rating"].stringValue
                    let author = review["author_name"].stringValue
                    let reviewContent = review["text"].stringValue
                    let time = review["relative_time_description"].stringValue
                    self.addReviewView(text: reviewContent, rating: rating, author: author, time: time)
                }
            }
            
            let getEntitiesURL: String = "\(myURL)/analysis/entities"
            let parameters: Parameters = ["pid": self.place!.placeID]
            Alamofire.request(getEntitiesURL, parameters: parameters).responseJSON(completionHandler: { (response) in
                if let result = response.result.value {
                    let entities = JSON(result)
                    self.addHeaderView(title: "ENTITIES' SENTIMENT")
                    for entity in entities.arrayValue{
                        let name = entity["name"].stringValue
                        let magnitude = entity["magnitude"].stringValue.prefix(4)
                        let score = entity["score"].stringValue.prefix(4)
                        self.addSentimentView(text: name, score: String(score), magnitude: String(magnitude))
                    }
                }
            })
        })        
    }
    
    func addSentimentView(text: String, score: String, magnitude: String){
        let newView = SentimentView()
        newView.frame.origin.y = currentYPosition
        newView.setValues(score: score, magnitude: magnitude)
        let newViewHeight =  newView.setText(text: text)
        currentYPosition = currentYPosition + newViewHeight
        scrollView.addSubview(newView)
        scrollView.contentSize.height = currentYPosition * 1.05
    }
    
    func addReviewView(text: String, rating: String, author: String, time: String){
        let newView = ReviewView()
        newView.frame.origin.y = currentYPosition
        let newViewHeight = newView.setText(text: text, author: author, rating: rating, time: time)
        currentYPosition = currentYPosition + newViewHeight
        scrollView.addSubview(newView)
        scrollView.contentSize.height = currentYPosition * 1.05
    }
    
    func addHeaderView(title: String){
        let newView = HeaderView()
        newView.frame.origin.y = currentYPosition
        let newViewHeight = newView.setTitle(title: title)
        currentYPosition = currentYPosition + newViewHeight
        scrollView.addSubview(newView)
        scrollView.contentSize.height = currentYPosition * 1.05
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


class HeaderView: UIView{
    
    var titleLabel: UILabel?
    
    
    let titleHeight = CGFloat(30)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel = UILabel()
        self.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        addSubview(titleLabel!)
    }
    
    func setTitle(title: String) -> CGFloat{
        titleLabel?.text = title
        titleLabel?.sizeToFit()
        self.sizeToFit()
        return titleHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
