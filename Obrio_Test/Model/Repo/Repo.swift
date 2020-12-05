//
//  Repo.swift
//  Obrio_Test
//
//  Created by Денис Андриевский on 05.12.2020.
//

import Foundation

struct Repo {
    var name: String
    var fullName: String
    
    init(from object: RepoObject) {
        self.name = object.name
        self.fullName = object.full_name
    }
}
