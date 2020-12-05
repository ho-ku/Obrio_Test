//
//  RepoResponse.swift
//  Obrio_Test
//
//  Created by Денис Андриевский on 05.12.2020.
//

import Foundation

struct RepoResponse: Codable {
    var items: [RepoObject]
}

struct RepoObject: Codable {
    var name: String
    var full_name: String
}
