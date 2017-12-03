//
//  SentimentView.swift
//  where-to-go
//
//  Created by LMAO on 29/11/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit

func screenWidth() -> CGFloat {
    let screenSize = UIScreen.main.bounds
    return screenSize.width
}

class SentimentView: UIView {
    
    var reviewTextView: UITextView?
    var infoView: UIView?
    var scoreLabel: UILabel?
    var scoreValueLabel: UILabel?
    var magnitudeLabel: UILabel?
    var magnitudeValueLabel: UILabel?
    
    let infoViewHeight = CGFloat(28)
    let reviewTextViewFont = CGFloat(18)
    let labelFont = CGFloat(18)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        reviewTextView = UITextView()
        reviewTextView!.frame = CGRect(x: 0, y: 0, width: screenWidth(), height: 0)
        reviewTextView?.font = Fonts.reviewContent
        reviewTextView?.textColor = Colors.text
        reviewTextView?.backgroundColor = Colors.reviewBackground
        self.addSubview(reviewTextView!)
        infoView = UIView()
        infoView!.frame = CGRect(x: textOffset, y: 0, width: screenWidth(),height: 20)
        
        scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        scoreLabel?.text = "Score: "
        scoreLabel?.font = Fonts.reviewContent
        scoreLabel?.sizeToFit()
        scoreLabel?.textColor = Colors.text
        
        magnitudeLabel = UILabel(frame: CGRect(x: screenWidth()/3, y: 0, width: 0, height: 0))
        magnitudeLabel?.text = "Magnitude: "
        magnitudeLabel?.font = Fonts.reviewContent
        magnitudeLabel?.sizeToFit()
        magnitudeLabel?.textColor = Colors.text
        
        scoreValueLabel = UILabel(frame: CGRect(x: (scoreLabel?.frame.width)!, y: 0, width: 0, height: 0))
        scoreValueLabel?.font = Fonts.reviewContent
        scoreValueLabel?.textColor = Colors.text
        magnitudeValueLabel = UILabel(frame: CGRect(x: (magnitudeLabel?.frame.origin.x)! + (magnitudeLabel?.frame.width)!, y: 0, width: 0, height: 0))
        magnitudeValueLabel?.font = Fonts.reviewContent
        magnitudeValueLabel?.textColor = Colors.text
        
        infoView?.addSubview(scoreLabel!)
        infoView?.addSubview(magnitudeLabel!)
        infoView?.addSubview(scoreValueLabel!)
        infoView?.addSubview(magnitudeValueLabel!)
        
        self.backgroundColor = Colors.reviewBackground
        
        self.addSubview(infoView!)
    }
    
    func setValues(score: String, magnitude: String){
        scoreValueLabel?.text = score
        scoreValueLabel?.sizeToFit()
        magnitudeValueLabel?.text = magnitude
        magnitudeValueLabel?.sizeToFit()
        
        if Double(score)! < -0.75 {
            self.scoreValueLabel?.textColor = Colors.colorN4
        } else if Double(score)! < -0.50 {
            self.scoreValueLabel?.textColor = Colors.colorN3
        } else if Double(score)! < -0.25 {
            self.scoreValueLabel?.textColor = Colors.colorN2
        } else if Double(score)! < 0 {
            self.scoreValueLabel?.textColor = Colors.colorN1
        } else if Double(score)! < 0.25 {
            self.scoreValueLabel?.textColor = Colors.colorP1
        } else if Double(score)! < 0.50 {
            self.scoreValueLabel?.textColor = Colors.colorP2
        } else if Double(score)! < 0.70 {
            self.scoreValueLabel?.textColor = Colors.colorP3
        } else {
            self.scoreValueLabel?.textColor = Colors.colorP4
        }
    }
    
    func setText(text: String) -> CGFloat{
        reviewTextView?.text = text
        let totalHeight = adjustTextViewHeight() + infoViewHeight
//        self.frame.size.height = totalHeight
//        self.frame.size.width = screenWidth()
        setBottomBorder()
        return totalHeight
    }
    
    func setBottomBorder() {
        let bottomBorder = CALayer()
        let width = CGFloat(1.5)
        bottomBorder.frame = CGRect(x: 0, y: (infoView?.frame.height)!-width, width: screenWidth(), height: width)
        bottomBorder.backgroundColor = Colors.border.cgColor
        infoView?.layer.addSublayer(bottomBorder)
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
