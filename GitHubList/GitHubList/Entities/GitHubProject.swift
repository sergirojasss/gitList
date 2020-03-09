//
//  GitHubProject.swift
//  Xing
//
//  Created by Sergi Rojas on 03/03/2020.
//  Copyright © 2020 Sergi Rojas. All rights reserved.
//

import Foundation


struct GitProject: Codable {
    var id: Int
    var name: String?
    var description: String?
    var htmlUrl: String?
    var owner: Owner?
    var forks: Int?
    
    struct Owner: Codable {
        var login: String?
        var htmlUrl: String?
        var avatarUrl: String?
        
        private enum CodingKeys: String, CodingKey {
            case login
            case htmlUrl = "html_url"
            case avatarUrl = "avatar_url"
        }
        
        init(login: String?, htmlUrl: String?, avatarUrl: String?) {
            self.login = login
            self.htmlUrl = htmlUrl
            self.avatarUrl = avatarUrl
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description = "description"
        case htmlUrl = "html_url"
        case owner
        case forks
    }
    
    init(id: Int, name: String?, description: String?, htmlUrl:String?, ownerLogin: String?, ownerHtmlUrl: String?, ownerAvatarUrl: String?, forks: Int?) {
        self.id = id
        self.name = name
        self.description = description
        self.htmlUrl = htmlUrl
        self.owner = Owner.init(login: ownerLogin, htmlUrl: ownerHtmlUrl, avatarUrl: ownerAvatarUrl)
        self.forks = forks
    }
    
}
