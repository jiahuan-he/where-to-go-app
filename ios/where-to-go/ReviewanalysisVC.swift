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

class ReviewanalysisVC: UIViewController {
    
    var currentYPosition = CGFloat(20)
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSentimentView(text: "a")
        addHeaderView(title: "TITLE1")
        addSentimentView(text: "a")
        addSentimentView(text: "a")
        addHeaderView(title: "TITLE2")
        addSentimentView(text: "a")
        addSentimentView(text: "a")
    }
    
    func addSentimentView(text: String){
        let newView = SentimentView()
        newView.frame.origin.y = currentYPosition
        let newViewHeight =  newView.setText(text: text)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
