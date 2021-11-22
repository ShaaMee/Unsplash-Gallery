//
//  Persistance.swift
//  Unsplash Gallery
//
//  Created by user on 22.11.2021.
//

import Foundation

class Persistance {
    
    static let shared = Persistance()
    
    private let persistanceKey = "FavouritesList"
    
    private let storage = UserDefaults.standard
    
    func addObject<T:Codable>(_ object: T, withKey objectKey: String) {
        var allObjects: [String:T] = getAllObjects()
        allObjects[objectKey] = object
        storage.setValue(try? PropertyListEncoder().encode(allObjects), forKey: persistanceKey)
    }
    
    func removeObjectWithKey<T:Codable>(_ objectKey:String, ofType: T.Type) {
        var allObjects: [String:T] = getAllObjects()
        allObjects.removeValue(forKey: objectKey)
        storage.setValue(try? PropertyListEncoder().encode(allObjects), forKey: persistanceKey)
    }
    
    func storesObjectForKey<T:Codable>(_ key: String, ofType: T.Type) -> Bool {
        let allObjects: [String:T] = getAllObjects()
        return allObjects[key] == nil ? false :  true
    }
    
    func getAllObjects<T:Codable>() -> [String:T] {
        guard let data = storage.value(forKey: persistanceKey) as? Data,
              let objects = try? PropertyListDecoder().decode([String:T].self, from: data)
        else { return [:] }
        
        return objects
    }
}
