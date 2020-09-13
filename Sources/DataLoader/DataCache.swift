//
//  DataCache.swift
//  
//
//  Created by Jhonny Bill on 9/13/20.
//

import Foundation

enum StorageConfiguration {
	case memory
	case disk
}

class DataCache<Key: AnyObject, Value: AnyObject> {
	let cache = NSCache<Key, Value>()
	let storage: StorageConfiguration
	let dataLoader = RemoteLoader.shared
	var storagelimit: Int
	var maximumElements: Int

	init(storagelimit: Int, maximumElements: Int, storage: StorageConfiguration) {
		self.storagelimit = storagelimit
		self.maximumElements = maximumElements
		self.storage = storage
	}

	subscript(key: Key) -> Value? {
		get {
			return cache.object(forKey: key)
		}
		set {
			guard let value = newValue else {
				cache.removeObject(forKey: key)
				return
			}
			cache.setObject(value, forKey: key)
		}
	}
}


// TODO: replace the internal cache backed by NSCache with a custom heap (probably a min-heap?) to be able to properly control the cost+priority
// and we can evict objects based on how active/inactive that entry has been.
// This is to improve the performance in TableView based applications.
