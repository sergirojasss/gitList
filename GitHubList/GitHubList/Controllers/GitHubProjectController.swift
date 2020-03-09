//
//  GitHubProjectController.swift
//  GitHubList
//
//  Created by Sergi Rojas on 03/03/2020.
//  Copyright © 2020 Sergi Rojas. All rights reserved.
//

import Foundation
import UIKit

protocol GitControllerDelegate {
    func deliverGits()
}

class GitHubProjectController {
    
    var delegate: GitControllerDelegate?
    
    var gits: [GitProject] = []
    
    var lastRequestCount: Int = -1 //useing this var for pagination
    
    func getGitProjects(){
        let db = DBHelper.shared

        if lastRequestCount == Constants.APIpagination || lastRequestCount == -1 { //==-1 first time
            Network.getRequest(url: constructURL(), requestID: Constants.APIRequestMain) { (gits) in
                self.lastRequestCount = gits.count
                if gits.isEmpty {
                    //try to get the ones saved on DB
                    let savedOnes = db.readRealm()
                    self.lastRequestCount = -2 //no ned to request more, we are offline
                    self.gits.append(contentsOf: savedOnes)
                    self.delegate?.deliverGits()
                } else {
                    self.gits.append(contentsOf: gits)
                    self.delegate?.deliverGits()
                }
            }
        } else {
            print("not more pages to load")
        }
    }
    
    private func constructURL() -> String {
        var url = Constants.APIBase
        if gits.count % Constants.APIpagination == 0  {
            let page = (gits.count/Constants.APIpagination)+1
            url.append("?page=\(page)")
        }
        lastRequestCount = -2 //to avoid load again if user scrolls super fast
        print(url)
        return url
    }
    
}



// -MARK: GESTURE RECOGNIZER
extension ViewController: UIGestureRecognizerDelegate {
       
    @objc func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {

        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let git = controller.gits[indexPath.row]
                var actions: [UIAlertAction] = []
                
                createActions(git, &actions)
                
                let alert = Utils.createAlertController(title: NSLocalizedString(Constants.mainAlertViewTitle, comment: ""), message: NSLocalizedString(Constants.mainAlertViewMessage, comment: ""), actions: actions, includeCancelAction: true)
                
                self.present(alert, animated: true)
            }
        }
    }
    
    fileprivate func createActions(_ git: GitProject, _ actions: inout [UIAlertAction]) {
        if let html = git.htmlUrl, let url = URL(string: html) {
            let action1 = UIAlertAction(title: NSLocalizedString(Constants.alertViewAction1, comment: ""), style: .default) { (action) in
                UIApplication.shared.open(url)
            }
            actions.append(action1)
        }
        if let owner = git.owner, let html = owner.htmlUrl, let url = URL(string: html) {
            let action2 = UIAlertAction(title: NSLocalizedString(Constants.alertViewAction2, comment: ""), style: .default) { (action) in
                UIApplication.shared.open(url)
            }
            actions.append(action2)
        }
    }

}



// -MARK: TABLE VIEW STUFF

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.gits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: CustomCell = tableView.dequeueReusableCell(withIdentifier: Constants.mainTableviewCell, for: indexPath) as? CustomCell {
            
            let git = controller.gits[indexPath.row]
            cell.configCell(git: git)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == controller.gits.count - 10 {
            controller.getGitProjects()
        }
    }
}



