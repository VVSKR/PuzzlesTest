//
//  NetworkService.swift
//  Puzzles
//
//  Created by Leonid Serebryanyy on 18.11.2019.
//  Copyright © 2019 Leonid Serebryanyy. All rights reserved.
//

import Foundation
import UIKit


class NetworkService {
	
	let session: URLSession
	
	private var queue = DispatchQueue(label: "com.sber.puzzless", qos: .default, attributes: .concurrent)

	
	init() {
		session = URLSession(configuration: .default)
	}
	
	
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
        
		// в этот массив запишите итоговые картинки
			var results = [UIImage]()
		
		let groupUrl = DispatchGroup()
        groupUrl.enter()
        for url in urls {
            let image = UIImage(data:  try! Data(contentsOf: url))!
            results.append(image)
        }
        groupUrl.leave()
        let block = DispatchWorkItem {
            if let merged = ImagesServices.image(byCombining: results) {
                completion(.success(merged))
            }
        }
        groupUrl.notify(queue: DispatchQueue.main, work: block)
	}
	
	
	// MARK:- Второе задание
	
	
	///  Здесь задание такое:
	///  У вас есть ключ keyURL, по которому спрятан клад.
	///  Верните картинку с этим кладом в completion
    public func loadQuiz(completion: @escaping(Result<UIImage, Error>) -> ()) {
        let keyURL = URL(string: "https://sberschool-c264c.firebaseio.com/enigma.json?avvrdd_token=AIzaSyDqbtGbRFETl2NjHgdxeOGj6UyS3bDiO-Y")!
        let request = URLRequest(url: keyURL)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { (data, responce, error) in
            guard let data = data else { completion(.failure(error!)); return }
            do {
                let decodedData = try JSONDecoder().decode(String.self, from: data)
                let url = URL(string: decodedData)!
                let image = UIImage(data:  try! Data(contentsOf: url))!
                completion(.success(image))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

}
