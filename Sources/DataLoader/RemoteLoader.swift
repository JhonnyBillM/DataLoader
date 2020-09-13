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

		let downloadTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
			guard error == nil else { completion(.failure(error!)) ; return }
			guard let data = data else { /*completion(.failure(error))*/ return }
			completion(.success(data))
		}
		downloadTask.resume()
	}
}
