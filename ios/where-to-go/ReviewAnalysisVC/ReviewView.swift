//
//  ReviewView.swift
//  where-to-go
//
//  Created by LMAO on 29/11/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit

class ReviewView: UIView {
    var reviewTextView: UITextView?
    var infoView: UIView?
    
    var authorLabel: UILabel?
    var ratingLabel: UILabel?
    
    var authorValueLabel: UILabel?
    var ratingValueLabel: UILabel?
    var timeValueLabel: UILabel?
    
    let infoViewHeight = CGFloat(28)
    let reviewTextViewFont = CGFloat(18)
    let labelFont = CGFloat(18)
    let authorOffsetRatio = CGFloat(0.33)
    let offSet = CGFloat(5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        reviewTextView = UITextView()
        reviewTextView!.frame = CGRect(x: 0, y: 0, width: screenWidth(), height: 0)
        reviewTextView?.font = UIFont.systemFont(ofSize: reviewTextViewFont)
        reviewTextView?.textAlignment = NSTextAlignment.justified
        self.addSubview(reviewTextView!)
        
        infoView = UIView()
        infoView!.frame = CGRect(x: offSet, y: 0, width: screenWidth(),height: infoViewHeight)
        
        ratingLabel = UILabel()
        ratingLabel?.font = UIFont.systemFont(ofSize: labelFont)
        
        ratingValueLabel = UILabel()
        ratingValueLabel?.font = UIFont.systemFont(ofSize: labelFont)
        
        authorLabel = UILabel()
        authorLabel?.font = UIFont.systemFont(ofSize: labelFont)
        
        timeValueLabel = UILabel()
        timeValueLabel?.font = UIFont.systemFont(ofSize: labelFont)
        
        authorValueLabel = UILabel()
        authorValueLabel?.font = UIFont.systemFont(ofSize: labelFont)
        
        infoView?.addSubview(ratingLabel!)
        infoView?.addSubview(authorLabel!)
        infoView?.addSubview(authorValueLabel!)
        infoView?.addSubview(ratingValueLabel!)
        self.addSubview(timeValueLabel!)
//        infoView?.addSubview(timeValueLabel!)
        
        self.addSubview(infoView!)
    }
    
    func setValues(author: String, rating: String, time: String){
        
        infoView?.addSubview(authorValueLabel!)
        infoView?.addSubview(ratingValueLabel!)
        infoView?.addSubview(timeValueLabel!)
    }
    
    
    func setText(text: String, author: String, rating: String, time: String) -> CGFloat{
        reviewTextView?.text = text
        reviewTextView!.translatesAutoresizingMaskIntoConstraints = true
        reviewTextView!.sizeToFit()
        reviewTextView!.isScrollEnabled = false
        
        infoView?.frame.origin.y = (reviewTextView?.frame.origin.y)! + (reviewTextView?.frame.height)!
        
        ratingLabel?.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        ratingLabel?.text = "Rating: "
        ratingLabel?.sizeToFit()
        
        ratingValueLabel?.frame = CGRect(x: (ratingLabel?.frame.width)!, y: 0, width: 0, height: 0)
        ratingValueLabel?.text = rating
        ratingValueLabel?.sizeToFit()
        
        authorLabel?.frame = CGRect(x: screenWidth()*authorOffsetRatio, y: 0, width: 0, height: 0)
        authorLabel?.text = " By: "
        authorLabel?.sizeToFit()

        authorValueLabel?.frame = CGRect(x: (authorLabel?.frame.width)! + (authorLabel?.frame.origin.x)!, y: 0, width: 0, height: 0)
        authorValueLabel?.text = author
        authorValueLabel?.sizeToFit()
        
        timeValueLabel?.text = time
        timeValueLabel?.sizeToFit()
        timeValueLabel?.frame.origin.y = infoView!.frame.origin.y + (infoView?.frame.height)!
        timeValueLabel?.frame.origin.x = offSet
        
        return (reviewTextView?.frame.height)! + infoViewHeight + (timeValueLabel?.frame.height)!
    }
    
    func adjustTextViewHeight() -> CGFloat
    {
        reviewTextView!.translatesAutoresizingMaskIntoConstraints = true
        reviewTextView!.sizeToFit()
        reviewTextView!.isScrollEnabled = false
        infoView?.frame.origin.y = (reviewTextView?.frame.origin.y)! + (reviewTextView?.frame.height)!
        timeValueLabel?.frame.origin.y = infoView!.frame.origin.y + (infoView?.frame.height)!
        return (reviewTextView?.frame.height)!
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
