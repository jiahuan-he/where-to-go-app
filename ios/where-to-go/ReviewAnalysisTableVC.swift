//
//  ReviewAnalysisTableViewController.swift
//  where-to-go
//
//  Created by LMAO on 29/11/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit

class ReviewAnalysisTableVC: UITableViewController {
   
    var data = ["Reviews": ["review1", "review2", "review3"],
                "Sentences":["sentence1", "sentence2", "sentence3", "sentence4", "sentence5", "sentence6"],
                "Entities":["entity1", "entity2", "entity3", "entity4", "entity3", "entity4", "entity3", "entity4", "entity3", "entity4", "entity3", "entity4"]]
    struct Objects {
        var sectionName : String!
        var sectionObjects : [String]!
    }
    var objectArray = [Objects]()

    override func viewDidLoad() {
        super.viewDidLoad()
        for (key, value) in data {
            print("\(key) -> \(value)")
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return objectArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray[section].sectionObjects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "tempCell")
        let cell = ReviewCell(style: UITableViewCellStyle.default, reuseIdentifier: "tempCell")
//        cell.textLabel?.text = objectArray[indexPath.section].sectionObjects[indexPath.row]
        
        cell.reviewTextView.text = objectArray[indexPath.section].sectionObjects[indexPath.row]
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectArray[section].sectionName
    }

}
