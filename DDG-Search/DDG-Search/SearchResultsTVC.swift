//
//  SearchResultsTVC.swift
//  DDG-Search
//
//  Created by Charles Wesley Cho on 11/12/15.
//  Copyright © 2015 Charles Wesley Cho. All rights reserved.
//

import UIKit
import Alamofire

class SearchResultsTVC: UITableViewController {
    
    var searchText : String!
    
    var itemsArray: [[String:AnyObject]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.reloadData()
        
        getSearchResults(searchText)
    }
    
    // MARK: - Get data
    
    func getSearchResults(text: String) {
        
        let parameters = ["q": text, "format": "json"]
        
        Alamofire.request(.GET, "https://api.duckduckgo.com", parameters: parameters)
            .responseJSON { response in
                guard response.result.error == nil else {
                    print("error \(response.result.error!)")
                    return
                }
                
                self.itemsArray = response.result.value?["RelatedTopics"] as? [[String:AnyObject]]
                self.tableView.reloadData()
        }
        
    }
    
    
    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchResultCell", forIndexPath: indexPath) as! SearchResultCell
        
        var dict = itemsArray?[indexPath.row]
        
        print(dict?["Text"])
        cell.resultLabel?.text = dict?["Text"] as? String
        
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
