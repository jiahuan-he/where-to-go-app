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
    
    let infoViewHeight = CGFloat(20)
    override init(frame: CGRect) {
        super.init(frame: frame)
        reviewTextView = UITextView()
        reviewTextView!.frame = CGRect(x: 0, y: 0, width: screenWidth(), height: 0)
        reviewTextView?.font = UIFont.systemFont(ofSize: 20)
        self.addSubview(reviewTextView!)
        infoView = UIView()
        infoView!.frame = CGRect(x: 0, y: 0, width: screenWidth(),height: 20)
        self.addSubview(infoView!)
        
        infoView?.backgroundColor = UIColor.blue
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
