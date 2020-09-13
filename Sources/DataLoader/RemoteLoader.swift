//
//  RemoteLoader.swift
//  
//
//  Created by Jhonny Bill on 9/13/20.
//

import Foundation

// TODO: add custom errors enum, if needed.

class RemoteLoader {
	typealias Handler = (Result<Data, Error>) -> ()

	/// Stores the completion handlers for a given URL. This prevents to emit several download tasks for the same URL.
	private var downloads = [String: [Handler]]()

	static let shared = RemoteLoader()

	/// Downloads data from the given URL and returns `Data` or `Error` to the passed `completion` parameter.
	///
	/// This method stores the completion handlers for a given URL to prevent duplicate requests; once a request completes for a given URL we call all the completion handlers tied to it.
	/// - Parameters:
	///   - url: url to download the data from.
	///   - completion: completion handler to call with the result once the download task completes. We store this completion handler in order to prevent making several requests for the same URL.
	func downloadData(from url: URL, completion: @escaping Handler) {
		let urlString = url.absoluteString
		// Prevent dispatching another URL Request if we are already downloading data for the given URL.
		// Store the completion so we can emit a response once the request completes.
		guard downloads[urlString] == nil else {
			downloads[urlString]?.append(completion)
			return
		}

		// Store the completion indicating that we have one ongoing download for this URL.
		downloads[urlString] = [completion]

		// Create and handle the Download operation and response.
		let downloadTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
			guard error == nil else {
				self?.completionFor(urlString, result: .failure(error!))
				return
			}
			guard let data = data else { /*completion(.failure(error))*/ return }

			self?.completionFor(urlString, result: .success(data))
			return
		}

		downloadTask.resume()
	}

	/// Calls all the handlers for the given String in the `downloads` dictionary.
	/// - Parameters:
	///   - urlString: key for the entry to look for in the `downloads` dictionary.
	///   - result: result to pass down to all the handlers.
	private func completionFor(_ urlString: String, result: Result<Data, Error>) {
		guard let handlers = downloads[urlString] else { return }
		for handler in handlers {
			handler(result)
		}
		downloads[urlString] = nil
	}
}
