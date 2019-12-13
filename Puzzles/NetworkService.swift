//
//  NetworkService.swift
//  Puzzles
//
//  Created by Leonid Serebryanyy on 18.11.2019.
//  Copyright © 2019 Leonid Serebryanyy. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkServiceProtocol {
    func loadQuiz(request: URLRequest, completion: @escaping(Result<String, Error>) -> ())
}


class NetworkService {
    
    let session: NetworkServiceProtocol
    private var queue = DispatchQueue(label: "com.sber.puzzless", qos: .default, attributes: .concurrent)
    
    
    init(session: NetworkServiceProtocol = URLSession.shared) {
        self.session = session
    }
    
    var results = [UIImage]()
    
    
    // MARK:- Первое задание
    
    ///  Вот здесь должны загружаться 4 картинки и совмещаться в одну.
    ///  Для выполнения этой задачи вам можно изменять только этот метод.
    ///  Метод, соединяющий картинки в одну, уже написан (вызывается в конце).
    ///  Ответ передайте в completion.
    ///  Помните, что надо сделать так, чтобы метод работал как можно быстрее.
    public func loadPuzzle(completion: @escaping (Result<UIImage, Error>) -> ()) {
        // это адреса картинок. они работающие, всё ок!
        let firstURL = URL(string: "https://i.imgur.com/JnY1dY7.jpg")!
        let secondURL = URL(string: "https://i.imgur.com/S93pvex.jpg")!
        let thirdURL = URL(string: "https://i.imgur.com/pvCHGsL.jpg")!
        let fourthURL = URL(string: "https://i.imgur.com/DgijrVE.jpg")!
        let urls = [firstURL, secondURL, thirdURL, fourthURL]
        
        
        
        let groupUrl = DispatchGroup()
        groupUrl.enter()
        for url in urls {
            let image = UIImage(data:  try! Data(contentsOf: url))!
            self.results.append(image)
        }
        groupUrl.leave()
        let block = DispatchWorkItem {
            if let merged = ImagesServices.image(byCombining: self.results) {
                completion(.success(merged))
            }
        }
        groupUrl.notify(queue: DispatchQueue.main, work: block)
    }
    
    
    // MARK:- Второе задание
    
    ///  Здесь задание такое:
    ///  У вас есть ключ keyURL, по которому спрятан клад.
    ///  Верните картинку с этим кладом в completion
    public func loadQuiz(url: URL, completion: @escaping(Result<String, Error>) -> ()) {
        
        let request = URLRequest(url: url)
        session.loadQuiz(request: request) { (result) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


extension URLSession: NetworkServiceProtocol {
    
    func loadQuiz(request: URLRequest, completion: @escaping(Result<String, Error>) -> ()) {
        let task = dataTask(with: request) { (data, _, error) in
            guard let data = data else { completion(.failure(error!)); return }
            do {
                print(data)
                let decodedData = try JSONDecoder().decode(String.self, from: data)
                print(decodedData)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
