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
    
    let infoViewHeight = CGFloat(30)
    let reviewTextViewFont = CGFloat(20)
    let labelFont = CGFloat(20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        reviewTextView = UITextView()
        reviewTextView!.frame = CGRect(x: 0, y: 0, width: screenWidth(), height: 0)
        reviewTextView?.font = UIFont.systemFont(ofSize: reviewTextViewFont)
        self.addSubview(reviewTextView!)
        
        infoView = UIView()
        infoView!.frame = CGRect(x: 0, y: 0, width: screenWidth(),height: 20)
        
        ratingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        ratingLabel?.text = "Rating: "
        ratingLabel?.font = UIFont.systemFont(ofSize: labelFont)
        ratingLabel?.sizeToFit()
        
        authorLabel = UILabel(frame: CGRect(x: screenWidth()/3, y: 0, width: 0, height: 0))
        authorLabel?.text = "Author: "
        authorLabel?.font = UIFont.systemFont(ofSize: labelFont)
        authorLabel?.sizeToFit()
        
        ratingValueLabel = UILabel(frame: CGRect(x: (ratingLabel?.frame.width)!, y: 0, width: 0, height: 0))
        ratingValueLabel?.font = UIFont.systemFont(ofSize: labelFont)

        authorValueLabel = UILabel(frame: CGRect(x: (authorLabel?.frame.width)! + (authorLabel?.frame.origin.x)!, y: 0, width: 0, height: 0))
        authorValueLabel?.font = UIFont.systemFont(ofSize: labelFont)

        timeValueLabel = UILabel(frame: CGRect(x: screenWidth() * 0.6, y: 0, width: 0, height: 0))
        timeValueLabel?.font = UIFont.systemFont(ofSize: labelFont)

        
        infoView?.addSubview(ratingLabel!)
        infoView?.addSubview(authorLabel!)
        infoView?.addSubview(authorValueLabel!)
        infoView?.addSubview(ratingValueLabel!)
        infoView?.addSubview(timeValueLabel!)
        
        self.addSubview(infoView!)
    }
    
    func setValues(author: String, rating: String, time: String){
        authorValueLabel?.text = author
        authorValueLabel?.sizeToFit()
        
        ratingValueLabel?.text = rating
        ratingValueLabel?.sizeToFit()
        
        timeValueLabel?.text = time
        timeValueLabel?.sizeToFit()
        
        infoView?.addSubview(authorValueLabel!)
        infoView?.addSubview(ratingValueLabel!)
        infoView?.addSubview(timeValueLabel!)
    }
    
    
    func setText(text: String) -> CGFloat{
        reviewTextView?.text = text
        return adjustTextViewHeight() + infoViewHeight
    }
    
    func adjustTextViewHeight() -> CGFloat
    {
        reviewTextView!.translatesAutoresizingMaskIntoConstraints = true
        reviewTextView!.sizeToFit()
        reviewTextView!.isScrollEnabled = false
        infoView?.frame.origin.y = (reviewTextView?.frame.origin.y)! + (reviewTextView?.frame.height)!
        return (reviewTextView?.frame.height)!
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
