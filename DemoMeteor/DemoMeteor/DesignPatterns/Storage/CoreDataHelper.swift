//
//  CoreDataHelper.swift
//  DemoMeteor
//
//  Created by Jagdish on 22/09/21.
//

import UIKit
import CoreData

class CoreDataHelper: NSObject {
    
    let storeName = "meteordata"
    let storeFilename = "meteordata.sqlite"
    
    override init(){
        super.init()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.storeName, withExtension: "momd")
        return NSManagedObjectModel.init(contentsOf: modelURL!)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent(self.storeFilename)
        debugPrint("Core Data path : \(String(describing: url))")
        var failureReason = "There was an error creating or loading the application's saved data."
        let mOptions = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: mOptions)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            
            debugPrint("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = coordinator
        return backgroundContext
    }()
    
    
    func saveContext (context: NSManagedObjectContext) {
        var error: NSError? = nil
        if context.hasChanges {
            do {
                try context.save()
            } catch let error1 as NSError {
                error = error1
                debugPrint("Unresolved error \(String(describing: error)), \(error!.userInfo)")
                abort()
            }
        }
    }
    
    func saveContext () {
        self.saveContext(context: self.backgroundContext)
    }
    
}
