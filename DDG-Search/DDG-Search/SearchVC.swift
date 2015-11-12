//
//  SearchVC.swift
//  DDG-Search
//
//  Created by Charles Wesley Cho on 11/12/15.
//  Copyright © 2015 Charles Wesley Cho. All rights reserved.
//

import UIKit


class SearchVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchField.delegate = self
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField.text == "" {
            
            noTextAlert()
            return false
        } else {
            
            performSegueWithIdentifier("ShowSearchResults", sender: self)
            return true

        }
    }

    func noTextAlert() {
        
        let alertController = UIAlertController(title: "Alert", message: "Enter Text! Nothing is not nothing but please search \"Nothing\"!", preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            
        }
        
        alertController.addAction(OKAction)
        
        presentViewController(alertController, animated: true, completion: { () -> Void in
            print("Alert was shown")
        })

    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let searchResultTVC = SearchResultsTVC()
        searchResultTVC.searchText = searchField.text
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
