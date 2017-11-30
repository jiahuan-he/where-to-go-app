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
        reviewTextView?.font = UIFont.systemFont(ofSize: reviewTextViewFont)
        self.addSubview(reviewTextView!)
        infoView = UIView()
        infoView!.frame = CGRect(x: 0, y: 0, width: screenWidth(),height: 20)
        
        scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        scoreLabel?.text = "Score: "
        scoreLabel?.font = UIFont.systemFont(ofSize: labelFont)
        scoreLabel?.sizeToFit()
        
        magnitudeLabel = UILabel(frame: CGRect(x: screenWidth()/3, y: 0, width: 0, height: 0))
        magnitudeLabel?.text = "Magnitude: "
        magnitudeLabel?.font = UIFont.systemFont(ofSize: labelFont)
        magnitudeLabel?.sizeToFit()
        
        scoreValueLabel = UILabel(frame: CGRect(x: (scoreLabel?.frame.width)!, y: 0, width: 0, height: 0))
        scoreValueLabel?.font = UIFont.systemFont(ofSize: labelFont)
        magnitudeValueLabel = UILabel(frame: CGRect(x: (magnitudeLabel?.frame.origin.x)! + (magnitudeLabel?.frame.width)!, y: 0, width: 0, height: 0))
        magnitudeValueLabel?.font = UIFont.systemFont(ofSize: labelFont)
        
        infoView?.addSubview(scoreLabel!)
        infoView?.addSubview(magnitudeLabel!)
        infoView?.addSubview(scoreValueLabel!)
        infoView?.addSubview(magnitudeValueLabel!)
        
        self.addSubview(infoView!)
    }
    
    func setValues(score: String, magnitude: String){
        scoreValueLabel?.text = score
        scoreValueLabel?.sizeToFit()
        magnitudeValueLabel?.text = magnitude
        magnitudeValueLabel?.sizeToFit()
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
