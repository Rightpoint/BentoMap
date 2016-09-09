//
//  MainMenuTableViewController.swift
//  BentoBox
//
//  Created by Matthew Buckley on 9/5/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

class MainMenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.separatorStyle = .None
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier") else {
            return UITableViewCell()
        }
        if indexPath.row == 0 {
            cell.textLabel?.text = "MapKit Example"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "CoreGraphics Example"
        }
        cell.accessoryType = .DisclosureIndicator
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            navigationController?.pushViewController(MapKitViewController(), animated: true)
        } else if indexPath.row == 1 {
            navigationController?.pushViewController(CoreGraphicsViewController(), animated: true)
        }
    }

}
