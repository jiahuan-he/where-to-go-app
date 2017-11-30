//
//  ReviewanalysisVC.swift
//  where-to-go
//
//  Created by LMAO on 29/11/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//



import UIKit

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

class ReviewAnalysisVC: UIViewController {
    
    var currentYPosition = CGFloat(20)
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHeaderView(title: "TITLE1")
        addReviewView(text: "reviewwwwww", rating: "4.9", author: "me", time: "now")
        addReviewView(text: "reviewwwwww", rating: "4.9", author: "me", time: "now")
        
        addSentimentView(text: "a", score: "0.1", magnitude: "0.2")
        addSentimentView(text: "a", score: "0.1", magnitude: "0.2")
        addSentimentView(text: "a", score: "0.1", magnitude: "0.2")
        addHeaderView(title: "TITLE2")
        addSentimentView(text: "a", score: "0.1", magnitude: "0.2")
        addSentimentView(text: "a", score: "0.1", magnitude: "0.2")
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
        newView.setValues(author: author, rating: rating, time: time)
        let newViewHeight = newView.setText(text: text)
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
