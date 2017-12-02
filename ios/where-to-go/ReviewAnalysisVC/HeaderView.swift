//
//  HeaderView.swift
//  where-to-go
//
//  Created by LMAO on 02/12/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit

class HeaderView: UIView{
    
    var titleLabel: UILabel?
    let headerViewHeight = CGFloat(50)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel = UILabel()
        self.titleLabel?.font = Fonts.reviewHeader
        self.titleLabel?.textColor = Colors.text
        self.backgroundColor = Colors.headerBackground
        titleLabel?.backgroundColor = Colors.headerBackground
        titleLabel?.frame.origin.x = textOffset
        addSubview(titleLabel!)
        print(self.frame.height)
    }
    
    func setTitle(title: String) -> CGFloat{
        titleLabel?.text = title
        titleLabel?.sizeToFit()
//        self.sizeToFit()
        self.frame.size.width = screenWidth()
        self.frame.size.height = headerViewHeight
        titleLabel?.frame.origin.y = self.frame.height/2 - (self.titleLabel?.frame.height)!/2
        return headerViewHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
