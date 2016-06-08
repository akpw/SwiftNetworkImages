//
//  Choice.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 7/6/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//
import UIKit

class MultipleChoiceController: UITableViewController {
    var height: CGFloat {
        return CGFloat(tableView.numberOfRowsInSection(0)) * tableView.rowHeight
    }
    
    var allowMultipleSelections: Bool = false
    var maximumAllowedSelections: Int?
    
    var choices: [NSObject]?
    var selectedItems = [NSObject]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: UITableViewStyle.Grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
        
        self.navigationController?.title = "aaa"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choices!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
                                                                                    -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        let choice = self.choices![indexPath.row]
        
        cell.textLabel?.text = choice.description
        cell.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
                                                                                        
        
        cell.accessoryType = selectedItems.contains(choice) ?
                UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None
        
        return cell
    }
    
    override func tableView(tableView: UITableView,
                            didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let choice = choices![indexPath.row]
        
        if let index = selectedItems.indexOf(choice){
            selectedItems.removeAtIndex(index)
        } else if shouldAllowSelection() {
            selectedItems.append(choice)
        }
        
        tableView.reloadRowsAtIndexPaths([indexPath],
                                         withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func shouldAllowSelection() -> Bool{
        if !allowMultipleSelections{
            return true
        } else if allowMultipleSelections && maximumAllowedSelections == nil{
            return true
        } else {
            return selectedItems.count < maximumAllowedSelections!
        }
    }
    
}
