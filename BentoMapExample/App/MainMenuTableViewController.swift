//
//  MainMenuTableViewController.swift
// BentoMap
//
//  Created by Matthew Buckley on 9/5/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

class MainMenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") else {
            return UITableViewCell()
        }
        if indexPath.row == 0 {
            cell.textLabel?.text = "MapKit Example"
        }
        else if indexPath.row == 1 {
            cell.textLabel?.text = "CoreGraphics Example"
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            navigationController?.pushViewController(MapKitViewController(), animated: true)
        }
        else if indexPath.row == 1 {
            navigationController?.pushViewController(CoreGraphicsViewController(), animated: true)
        }
    }

}
