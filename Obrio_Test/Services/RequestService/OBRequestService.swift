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
    private let dispatchGroup = DispatchGroup()
    private let dispatchSemaphore = DispatchSemaphore(value: 1)
    
    func fetchRepos(query: String, completionHandler: @escaping ([Repo]) -> Void) {
        performComplexRequest(query: query) { result in
            completionHandler(result)
        }
    }
    
    private func performComplexRequest(query: String, completionHandler: @escaping ([Repo]) -> Void) {
        var res: [Repo] = []
        for limit in [C.resultsFirstLimit, C.resultsSecondLimit] {
            self.performRequest(query: query, resultLimit: limit) { result in
                switch result {
                case .success(let data):
                    guard let result = try? JSONDecoder().decode(RepoResponse.self, from: data) else {
                        completionHandler([])
                        return
                    }
                    res.append(contentsOf: result.items.map{Repo(from: $0)}.suffix(15))
                case .failure(let error):
                    print(error)
                    completionHandler([])
                }
            }
        }
        dispatchGroup.notify(queue: .global(qos: .background)) {
            completionHandler(res)
        }
    }
    
    private func performRequest(query: String, resultLimit: Int, completionHandler: @escaping (Result<Data, RequestError>) -> Void) {
        self.dispatchGroup.enter()
        self.dispatchSemaphore.wait()
        DispatchQueue.global(qos: .background).async { [unowned self] in
            guard var urlComponents = URLComponents(string: urlString) else {
                completionHandler(.failure(.invalidURL))
                self.dispatchGroup.leave()
                self.dispatchSemaphore.signal()
                return
            }
            urlComponents.queryItems = [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "sort", value: C.starsSortTitle),
                URLQueryItem(name: "order", value: C.descOrderTitle),
                URLQueryItem(name: "per_page", value: String(resultLimit))
            ]
            guard let url = urlComponents.url else {
                completionHandler(.failure(.invalidURL))
                self.dispatchGroup.leave()
                self.dispatchSemaphore.signal()
                return
            }
            URLSession.shared.dataTask(with: url) { [unowned self] (data, response, error) in
                guard error == nil else {
                    completionHandler(.failure(.requestError))
                    self.dispatchGroup.leave()
                    self.dispatchSemaphore.signal()
                    return
                }
                guard let data = data else {
                    completionHandler(.failure(.noData))
                    self.dispatchGroup.leave()
                    self.dispatchSemaphore.signal()
                    return
                }
                completionHandler(.success(data))
                self.dispatchGroup.leave()
                self.dispatchSemaphore.signal()
            }.resume()
        }
    }
    
}
