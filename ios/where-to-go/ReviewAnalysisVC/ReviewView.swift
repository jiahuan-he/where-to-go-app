//
//  ReviewView.swift
//  where-to-go
//
//  Created by LMAO on 29/11/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit

let textOffset = CGFloat(5)
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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        reviewTextView = UITextView()
        reviewTextView!.frame = CGRect(x: 0, y: 0, width: screenWidth(), height: 0)
        reviewTextView?.font = Fonts.reviewContent
        reviewTextView?.textAlignment = NSTextAlignment.justified
        reviewTextView?.textColor = Colors.reviewText
        reviewTextView?.backgroundColor = Colors.reviewBackground
        self.addSubview(reviewTextView!)
        
        infoView = UIView()
        infoView!.frame = CGRect(x: textOffset, y: 0, width: screenWidth(),height: infoViewHeight)
        
        ratingLabel = UILabel()
        ratingLabel?.font = Fonts.reviewContent
        ratingLabel?.textColor = Colors.text
        
        ratingValueLabel = UILabel()
        ratingValueLabel?.font = Fonts.reviewContent
        ratingValueLabel?.textColor = Colors.text
        
        authorLabel = UILabel()
        authorLabel?.font = Fonts.reviewContent
        authorLabel?.textColor = Colors.text
        
        timeValueLabel = UILabel()
        timeValueLabel?.font = Fonts.reviewContent
        timeValueLabel?.textColor = Colors.text
        
        authorValueLabel = UILabel()
        authorValueLabel?.font = Fonts.reviewContent
        authorValueLabel?.textColor = Colors.text
        
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
        timeValueLabel?.frame.origin.x = textOffset
        
        setBottomBorder()
        if Double(rating)! < 0.625 {
            self.ratingValueLabel?.textColor = Colors.colorN4
        } else if Double(rating)! < 1.25 {
            self.ratingValueLabel?.textColor = Colors.colorN3
        } else if Double(rating)! < 1.875 {
            self.ratingValueLabel?.textColor = Colors.colorN2
        } else if Double(rating)! < 2.5 {
            self.ratingValueLabel?.textColor = Colors.colorN1
        } else if Double(rating)! < 3.125 {
            self.ratingValueLabel?.textColor = Colors.colorP1
        } else if Double(rating)! < 3.8 {
            self.ratingValueLabel?.textColor = Colors.colorP2
        } else if Double(rating)! < 4.325 {
            self.ratingValueLabel?.textColor = Colors.colorP3
        } else {
            self.ratingValueLabel?.textColor = Colors.colorP4
        }
        return (reviewTextView?.frame.height)! + infoViewHeight + (timeValueLabel?.frame.height)!
    }
    
    func setBottomBorder() {
        let bottomBorder = CALayer()
        let width = CGFloat(1.5)
        bottomBorder.frame = CGRect(x: 0, y: (timeValueLabel?.frame.height)!-width, width: screenWidth(), height: width)
        bottomBorder.backgroundColor = Colors.border.cgColor
        timeValueLabel?.layer.addSublayer(bottomBorder)
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
