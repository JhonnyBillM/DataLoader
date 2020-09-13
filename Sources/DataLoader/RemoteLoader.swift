//
//  RemoteLoader.swift
//  
//
//  Created by Jhonny Bill on 9/13/20.
//

import Foundation

// TODO: add custom errors enum, if needed.

class RemoteLoader {

	/// Stores the completion handlers for a given URL. This prevents to emit several download tasks for the same URL.
	private var downloads = [String: [(Result<Data, Error>) -> ()]]()

	func downloadData(from url: URL, completion: @escaping (Result<Data, Error>) -> ()) {
		// Prevent dispatching another URL Request if we are already downloading data for the given URL.
		// Store the completion so we can emit a response once the request completes.
		guard downloads[url.absoluteString] == nil else {
			downloads[url.absoluteString]?.append(completion)
			return
		}

		// Store the completion indicating that we have one ongoing download for this URL.
		downloads[url.absoluteString] = [completion]

		let downloadTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
			guard error == nil else { completion(.failure(error!)) ; return }
			guard let data = data else { /*completion(.failure(error))*/ return }

			guard let handlers = self?.downloads[url.absoluteString] else {
				// should I fail, or should I return a success only for the completion??
				/*completion(.failure(customError?))*/ // We lost the handlers.
				return
			}

			for handler in handlers {
				handler(.success(data))
			}

			self?.downloads[url.absoluteString] = nil
			return
		}

		downloadTask.resume()
	}
}
