//
//  RemoteLoader.swift
//  
//
//  Created by Jhonny Bill on 9/13/20.
//

import Foundation

// TODO: add custom errors enum, if needed.

class RemoteLoader {
	// TODO: support multiple downloads tied to the same URL
	//	var downloads: [String: [(Result<Data, Error>) -> ()]]

	func downloadData(from url: URL, completion: @escaping (Result<Data, Error>) -> ()) {
		// TODO: check if the download exists, if so, append the completion to the downloads and return.

		let downloadTask = URLSession.shared.downloadTask(with: url) { (url, response, error) in

			guard error == nil else { completion(.failure(error!)) ; return }
			guard let url = url else { /*completion(.failure(error))*/ return }

			do {
				let data = try Data(contentsOf: url)
				completion(.success(data))
			} catch let error {
				completion(.failure(error))
				return
			}
		}
		downloadTask.resume()
	}
}
