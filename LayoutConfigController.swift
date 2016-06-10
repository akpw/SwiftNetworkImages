//
//  ConfigController.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 7/6/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//
import UIKit

/// Visual configuration of AKPCollectionViewFlowLayout's LayoutConfigOptions 

class LayoutConfigController: UITableViewController {
    var configOptions: LayoutConfigOptions?
    var selectedOptions: LayoutConfigOptions?

    var height: CGFloat {
        return CGFloat(tableView.numberOfRowsInSection(0)) * tableView.rowHeight +
                                    tableView(tableView, heightForHeaderInSection: 0) +
                                    tableView(tableView, heightForFooterInSection: 0)
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: UITableViewStyle.Grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 40
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CellReuseID")
    }
    
    override func tableView(tableView: UITableView,
                        numberOfRowsInSection section: Int) -> Int {
        return configOptions?.descriptions.count ?? 0
    }
    
    override func tableView(tableView: UITableView,
                        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellReuseID",
                                           forIndexPath: indexPath) as UITableViewCell
        if let configOptions = configOptions
                                    where configOptions.descriptions.count > indexPath.row {
            let optionDescription = configOptions.descriptions[indexPath.row]
            cell.textLabel?.text = optionDescription
            if let selectedOptions = selectedOptions {
                let option = LayoutConfigOptions(rawValue: 1<<(indexPath.row + 1))
                cell.accessoryType = selectedOptions.contains(option) ?
                    UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None
            }
        }
        cell.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        return cell
    }
    
    override func tableView(tableView: UITableView,
                            didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let selectedOptions = selectedOptions {
            let option = LayoutConfigOptions(rawValue: 1<<(indexPath.row + 1))
            if selectedOptions.contains(option) {
                self.selectedOptions?.remove(option)
            } else {
                self.selectedOptions?.insert(option)
            }
        }
        tableView.reloadRowsAtIndexPaths([indexPath],
                                     withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
