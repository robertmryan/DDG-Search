//
//  SearchResultsTVC.swift
//  DDG-Search
//
//  Created by Charles Wesley Cho on 11/12/15.
//  Copyright © 2015 Charles Wesley Cho. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchResultsTVC: UITableViewController {
    
    var searchText : String! {
        didSet {
            getSearchResults(searchText)
        }
    }
    
    var itemsArray : Array<Dictionary<NSObject, AnyObject>> = []
    
    var resultText : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

    }

    
    // MARK: - Get data
    
    func getSearchResults(text: String) {
        
        if let excapedText = text.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
            
            Alamofire.request(.GET, "https://api.duckduckgo.com/?q=\(excapedText)&format=json")
                .responseJSON { response in
                    guard response.result.error == nil else {
                        
                        // got an error in getting the data, need to handle it
                        print("error \(response.result.error!)")
                        return
                        
                    }
                    
                    let swiftyJsonVar = JSON(response.result.value!)
                    
                    if let relatedTopics = swiftyJsonVar["RelatedTopics"].arrayObject {
                        
                        self.itemsArray = relatedTopics as! Array<Dictionary<NSObject, AnyObject>>
                    }
                    
                    if self.itemsArray.count > 0 {
                        
                        self.tableView.reloadData()
                    }

//                    if let items = response.result.value {
//                        
//                        let item = JSON(items)
//                        
//                        
//                        for var i=0; i<item.count; ++i {
//                            if let text = item["RelatedTopics"][i]["Text"].string {
//                                
//                                self.resultText.append(text)
//                                print("The text is:" + text)
//                                
//                                self.tableView.reloadData()
//                            }
//                        }
//                    }
                    
            }
            
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return itemsArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchResultCell", forIndexPath: indexPath) as! SearchResultCell

        var dict = itemsArray[indexPath.row]
        
        cell.resultLabel.text = dict["Text"] as? String
        
        return cell
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
