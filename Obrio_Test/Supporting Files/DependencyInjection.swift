//
//  DependencyInjection.swift
//  Obrio_Test
//
//  Created by Денис Андриевский on 05.12.2020.
//

import Foundation

final class DependencyInjection {
    
    // MARK: - Singleton
    static let shared = DependencyInjection()
    private init() { }
    
    func requestService() -> RequestService {
        return OBRequestService()
    }
 
}
