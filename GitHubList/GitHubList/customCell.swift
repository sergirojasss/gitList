//
//  customCell.swift
//  GitHubList
//
//  Created by Sergi Rojas on 03/03/2020.
//  Copyright © 2020 Sergi Rojas. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var desc: UILabel!
    @IBOutlet var login: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(git: GitProject) {
        
        self.backgroundColor = UIColor.white
        if git.forks != 0 {
            self.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        }
        
        self.name.text = git.name
        self.desc.text = git.description
        if let owner = git.owner {
            self.login.text = owner.login
            if let avatar = owner.avatarUrl, let url = URL(string: avatar), let login = owner.login {
                self.avatarImage.downloaded(id: login, from: url)
            } else {
                // delete image or set a placeholder instead
            }
        }

    }

}
