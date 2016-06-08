//
//  ConfigController.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 7/6/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//
import UIKit

class ConfigController: UITableViewController {
    var height: CGFloat {
        return CGFloat(tableView.numberOfRowsInSection(0)) * tableView.rowHeight
    }
    
    var configOptions: [NSObject]?
    var selectedOptions = [NSObject]()
    
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
        tableView.rowHeight = 60
    }
    
    override func tableView(tableView: UITableView,
                        numberOfRowsInSection section: Int) -> Int {
        return configOptions?.count ?? 0
    }
    
    override func tableView(tableView: UITableView,
                        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell",
                                           forIndexPath: indexPath) as UITableViewCell
        if let options = self.configOptions
                                    where options.count > indexPath.row {
            let option = options[indexPath.row]
            cell.textLabel?.text = option.description
            cell.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
            cell.accessoryType = selectedOptions.contains(option) ?
                UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None
        }
        return cell
    }
    
    override func tableView(tableView: UITableView,
                            didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let options = self.configOptions
                                where options.count > indexPath.row {
            let option = options[indexPath.row]
            if let index = selectedOptions.indexOf(option){
                selectedOptions.removeAtIndex(index)
            } else  {
                selectedOptions.append(option)
            }
        }
        tableView.reloadRowsAtIndexPaths([indexPath],
                                     withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
}
