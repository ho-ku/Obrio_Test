//
//  Request.swift
//  Obrio_Test
//
//  Created by Денис Андриевский on 05.12.2020.
//

import Foundation

protocol RequestService: class {
    func fetchRepos(query: String, completionHandler: @escaping ([Repo]?) -> Void)
}
