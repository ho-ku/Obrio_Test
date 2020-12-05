//
//  OBRequestService.swift
//  Obrio_Test
//
//  Created by Денис Андриевский on 05.12.2020.
//

import Foundation

enum RequestError: Error {
    case requestError, invalidURL, noData
}

final class OBRequestService: RequestService {
    
    private let urlString = C.reposSearchURLString
    
    func fetchRepos(query: String, completionHandler: @escaping ([Repo]?) -> Void) {
        performRequest(query: query) { result in
            switch result {
            case .success(let data):
                guard let result = try? JSONDecoder().decode(RepoResponse.self, from: data) else {
                    completionHandler(nil)
                    return
                }
                completionHandler(result.items.map { Repo(from: $0) })
            case .failure(let error):
                print(error)
                completionHandler(nil)
            }
        }
    }
    
    private func performRequest(query: String, completionHandler: @escaping (Result<Data, RequestError>) -> Void) {
        guard var urlComponents = URLComponents(string: urlString) else {
            completionHandler(.failure(.invalidURL))
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "sort", value: C.starsSortTitle),
            URLQueryItem(name: "order", value: C.descOrderTitle),
            URLQueryItem(name: "per_page", value: String(C.resultsLimit))
        ]
        guard let url = urlComponents.url else { completionHandler(.failure(.invalidURL)); return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { completionHandler(.failure(.requestError)); return }
            guard let data = data else { completionHandler(.failure(.noData)); return }
            completionHandler(.success(data))
        }.resume()
    }
    
}
