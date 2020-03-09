//
//  DBHelper.swift
//  Xing
//
//  Created by Sergi Rojas on 03/03/2020.
//  Copyright © 2020 Sergi Rojas. All rights reserved.
//

import Foundation
import RealmSwift

import SQLite3

class GitProjectRealm: Object {
    @objc dynamic var id: Int = -1
    @objc dynamic var name: String?
    @objc dynamic var desc: String?
    @objc dynamic var htmlUrl: String?
    @objc dynamic var owner: OwnerRealm?
    let fork = RealmOptional<Int>()
    
    override static func primaryKey() -> String? {
      return "id"
    }

}

class OwnerRealm: Object {
    @objc dynamic var login: String?
    @objc dynamic var htmlUrl: String?
    @objc dynamic var avatarUrl: String?
}

class DBHelper
{
    
    static let shared: DBHelper = DBHelper.init()

    func insertOrUpdate(git: GitProject) {
        let realm = try! Realm()
        try! realm.write{
            let gitRealm = GitProjectRealm()
            gitRealm.id = git.id
            gitRealm.name = git.name
            gitRealm.desc = git.description
            gitRealm.htmlUrl = git.htmlUrl
            gitRealm.fork.value = git.forks
            let ownerRealm = OwnerRealm()
            ownerRealm.login = git.owner?.login
            ownerRealm.htmlUrl = git.owner?.htmlUrl
            ownerRealm.avatarUrl = git.owner?.avatarUrl
            gitRealm.owner = ownerRealm
            realm.add(gitRealm, update: .modified)
        }
    }
    
    func readRealm() -> [GitProject] {
        let realm = try! Realm()
        let gitsRealm = realm.objects(GitProjectRealm.self)
        var gits: [GitProject] = []
        for gitRealm in gitsRealm {
            gits.append(GitProject(id: gitRealm.id, name: gitRealm.name, description: gitRealm.desc, htmlUrl: gitRealm.htmlUrl, ownerLogin: gitRealm.owner?.login, ownerHtmlUrl: gitRealm.owner?.htmlUrl, ownerAvatarUrl: gitRealm.owner?.avatarUrl, forks: gitRealm.fork.value))
        }
        return gits
    }
    
    func deleteAllRealm() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }

}
