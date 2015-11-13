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
    
    var itemsArray = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.reloadData()

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
                    
                    let items = JSON(response.result.value!)
                    
                    if let relatedTopics = items["RelatedTopics"].arrayObject {
                        
                        self.itemsArray = relatedTopics as! [[String:AnyObject]]
                    }
                    
                    if self.itemsArray.count > 0 {
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.tableView.reloadData()

                        })
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

        return 6 //itemsArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchResultCell", forIndexPath: indexPath) as! SearchResultCell

//        if itemsArray.count > 0 {
        
            var dict = itemsArray[indexPath.row]
            
            print(dict["Text"])
            cell.resultLabel?.text = dict["Text"] as? String
            
//        } else {
        
            print("Results not loaded yet")

//        }

        return cell
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
