import Foundation

#if canImport(UIKit)
import UIKit
public typealias Image = UIImage
#elseif canImport(AppKit)
import AppKit
public typealias Image = NSImage
#endif

/// Loads image from an URL using caching mechanism. Support both platforms (iOS and macOS).
public class ImageLoader {
	private let imageCache = DataCache<NSString, Image>(storagelimit: 500_000_000, maximumElements: 500, storage: .memory)
	static let shared = ImageLoader()

	/// Downloads an image from the given URL, uses cache to improve performance.
	func downloadImage(with url: URL, completion: @escaping (Image?) -> ()) {
		if let image = imageCache[url._absoluteString] {
			completion(image)
		} else {
			RemoteLoader.shared.downloadData(from: url) { [weak self] (result) in
				guard let data = try? result.get() else { return }
				let image = Image(data: data)
				self?.imageCache[url._absoluteString] = image
				completion(image)
			}
		}
	}
}
