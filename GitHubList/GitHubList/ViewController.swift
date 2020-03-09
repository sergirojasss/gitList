//
//  ViewController.swift
//  GitHubList
//
//  Created by Sergi Rojas on 03/03/2020.
//  Copyright © 2020 Sergi Rojas. All rights reserved.
//

import UIKit
import MBProgressHUD

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    let controller: GitHubProjectController = GitHubProjectController()
    
    var hud: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //controller
        controller.delegate = self
        //controller
        
        //tableView stuff
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        //tableView stuff

        //Long press
        let longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
        longPress.delegate = self
        longPress.minimumPressDuration = 1.0
        tableView.addGestureRecognizer(longPress)
        //Long press
        
        hud = MBProgressHUD.showAdded(to: tableView, animated: true)
        controller.getGitProjects()
    }
}

extension ViewController: GitControllerDelegate {
    func deliverGits() {
        hud.hide(animated: true)
        self.tableView.reloadData()
    }
    
}




