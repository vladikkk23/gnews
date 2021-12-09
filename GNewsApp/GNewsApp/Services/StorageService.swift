//
//  StorageService.swift
//  GNewsApp
//
//  Created by vladikkk on 08/12/2021.
//

import Foundation
import RealmSwift

// MARK: - StorageServiceProtocol
protocol StorageServiceProtocol {
    // MARK: - Read one object
    func object<T: Object>(_ key: Any?) -> T?
    func object<T: Object>(_ predicate: (T) -> Bool) -> T?
    
    // MARK: - Read multiple objects
    func objects<T: Object>() -> [T]
    func objects<T: Object>(_ predicate: (T) -> Bool) -> [T]
    
    // MARK: - Write one object
    @discardableResult func write<T: Object>(_ object: T?) -> Bool
    
    // MARK: - Write multiple objects
    @discardableResult func write<T: Object>(_ objects: [T]?) -> Bool
    
    // MARK: - Update object info
    @discardableResult func update(_ block: () -> ()) -> Bool
    
    // MARK: - Delete one object
    @discardableResult func delete<T: Object>(_ object: T) -> Bool
    
    // MARK: - Delete all objects
    @discardableResult func flush() -> Bool
}

// MARK: - StorageService implementation
class StorageService {
    // MARK: - Properties
    fileprivate var realm: Realm? {
        do {
            return try Realm()
        } catch let err {
            let error = err as NSError
            
            if error.code == 10 {
                guard let defaultPath: URL = Realm.Configuration.defaultConfiguration.fileURL else { return nil }
                try? FileManager.default.removeItem(at: defaultPath)
                return self.realm
            }
            print("Default realm init failed: ", error)
            print("Data will not be saved.")
            print("Filters are not available.")
            print("Sort options are not available.")
        }
        return nil
    }
    
    // MARK: - Methods
    func object<T: Object>(_ key: PersistentDataTypes) -> T? {
        guard let realm: Realm = self.realm else { return nil }
        guard let object: T = realm.object(ofType: T.self, forPrimaryKey: key.rawValue) else { return nil }
        
        return !object.isInvalidated ? object : nil
    }
    
    func object<T: Object>(_ predicate: (T) -> Bool) -> T? {
        guard let realm: Realm = self.realm else { return nil }
        
        return realm.objects(T.self).filter(predicate).filter({ !$0.isInvalidated }).first
    }
    
    func objects<T: Object>() -> [T] {
        guard let realm: Realm = self.realm else { return [] }
        
        return realm.objects(T.self).filter({ !$0.isInvalidated })
    }
    
    func objects<T: Object>(_ predicate: (T) -> Bool) -> [T] {
        guard let realm: Realm = self.realm else { return [] }
        
        return realm.objects(T.self).filter(predicate).filter({ !$0.isInvalidated })
    }
    
    func write<T: Object>(_ object: T?) -> Bool {
        guard let object: T = object else { return false }
        guard let realm: Realm = self.realm else { return false }
        guard !object.isInvalidated else { return false }
        
        do {
            try realm.write {
                realm.add(object, update: .all)
            }
            
            return true
        } catch let error {
            print("Writing failed for ", String(describing: T.self), " with error ", error)
        }
        
        return false
    }
    
    func write<T: Object>(_ objects: [T]?) -> Bool {
        guard let objects: [T] = objects else { return false }
        guard let realm: Realm = self.realm else { return false }
        let validated: [T] = objects.filter({ !$0.isInvalidated })
        
        do {
            try realm.write {
                realm.add(validated, update: .all)
            }
            
            return true
        } catch let error {
            print("Writing of array failed for ", String(describing: T.self), " with error ", error)
        }
        
        return false
    }
    
    func update(_ block: () -> ()) -> Bool {
        guard let realm: Realm = self.realm else { return false }
        
        do {
            try realm.write(block)
            
            return true
        } catch let error {
            print("Updating failed with error ", error)
        }
        
        return false
    }
    
    func delete<T: Object>(_ object: T) -> Bool {
        guard let realm: Realm = self.realm else { return false }
        guard !object.isInvalidated else { return true }
        
        do {
            try realm.write {
                realm.delete(object)
            }
            
            return true
        } catch let error {
            print("Writing of array failed for ", String(describing: T.self), " with error ", error)
        }
        
        return false
    }
    
    func flush() -> Bool {
        guard let realm: Realm = self.realm else { return false }
        
        do {
            try realm.write {
                //                realm.delete(realm.objects(T.self))
            }
            
            return true
        } catch let error {
            print("Databse flush failed with ", error)
        }
        
        return false
    }
}
