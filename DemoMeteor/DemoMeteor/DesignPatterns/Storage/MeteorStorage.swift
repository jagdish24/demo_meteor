//
//  MeteorStorage.swift
//  DemoMeteor
//
//  Created by Jagdish on 22/09/21.
//

import UIKit
import CoreData

struct DB {
    static var meteor = "DB_meteor"
    static var geoLocation = "DB_geolocation"
}


class MeteorStorage: NSObject {
    
    lazy var cdHelper: CoreDataHelper = {
        let cdHelper = CoreDataHelper()
        return cdHelper
    }()

    
    internal func saveMeteors(_ objects: [MeteorElement]) {
        
        for a:Int in 0..<objects.count  {
            
            let object = objects[a]
            
            //Remove existing
            self.removeMeteor(object.id)
            
            //New Add
            let entity = NSEntityDescription.entity(forEntityName: DB.meteor, in: self.cdHelper.backgroundContext)
            let saveObject = NSManagedObject(entity: entity!, insertInto: self.cdHelper.backgroundContext)
            
            saveObject.setValue(object.id, forKey: "id")
            saveObject.setValue(object.name, forKey: "name")
            saveObject.setValue(object.nametype, forKey: "nametype")
            saveObject.setValue(object.recclass, forKey: "recclass")
            saveObject.setValue(object.mass, forKey: "mass")
            saveObject.setValue(object.year, forKey: "year")
            saveObject.setValue(object.fall, forKey: "fall")
            saveObject.setValue(object.reclat, forKey: "reclat")
            saveObject.setValue(object.reclong, forKey: "reclong")
            saveObject.setValue(false, forKey: "isfavorite")


            if let geolocation = object.geolocation {
                self.saveGeoLocation(object.id, geo: geolocation)
            }
            debugPrint("Inserted Meteor")
        }
        
        self.cdHelper.saveContext(context: self.cdHelper.backgroundContext)
    }
    
    internal func getMeteors(_ isFavorite: Bool = false) -> [MeteorElement] {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: DB.meteor)
        if isFavorite == true {
            request.predicate = NSPredicate(format: "isfavorite = %i", isFavorite)
        }
        request.returnsObjectsAsFaults = false
        
        var values = [MeteorElement]()
        do {
            let result = try self.cdHelper.backgroundContext.fetch(request)
            for data in result as! [NSManagedObject] {
                

                let id = (data.value(forKey: "id") as! String)
                let name = (data.value(forKey: "name") as! String)
                let nametype = (data.value(forKey: "nametype") as! String)
                let recclass = (data.value(forKey: "recclass") as! String)
                let mass = (data.value(forKey: "mass") as? String)
                let year = data.value(forKey: "year") as? String
                let reclat = (data.value(forKey: "reclat") as? String)
                let reclong = (data.value(forKey: "reclong") as? String)
                let fall = (data.value(forKey: "fall") as? String)
                let isfavorite = (data.value(forKey: "isfavorite") as? Bool)
                

                let geo = self.getGeoLocation(id)
                
                let meteor = MeteorElement.init(name: name, id: id, nametype: nametype, recclass: recclass, mass: mass, year: year, fall: fall, reclat: reclat, reclong: reclong, geolocation: geo, isFavorite: isfavorite)

                values.append(meteor)
            }
        }
        catch {
            print("Failed")
        }
        return values
    }
    
    internal func getMeteor(_ meteorId: String) -> MeteorElement? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: DB.meteor)
        request.predicate = NSPredicate(format: "id = %@", meteorId)
        request.returnsObjectsAsFaults = false
        
        var values: MeteorElement?
        do {
            let result = try self.cdHelper.backgroundContext.fetch(request)
            for data in result as! [NSManagedObject] {
                

                let id = (data.value(forKey: "id") as! String)
                let name = (data.value(forKey: "name") as! String)
                let nametype = (data.value(forKey: "nametype") as! String)
                let recclass = (data.value(forKey: "recclass") as! String)
                let mass = (data.value(forKey: "mass") as? String)
                let year = data.value(forKey: "year") as? String
                let reclat = (data.value(forKey: "reclat") as? String)
                let reclong = (data.value(forKey: "reclong") as? String)
                let fall = (data.value(forKey: "fall") as? String)
                let isfavorite = (data.value(forKey: "isfavorite") as? Bool)
                

                let geo = self.getGeoLocation(id)
                
                let meteor = MeteorElement.init(name: name, id: id, nametype: nametype, recclass: recclass, mass: mass, year: year, fall: fall, reclat: reclat, reclong: reclong, geolocation: geo, isFavorite: isfavorite)

                values = meteor
            }
        }
        catch {
            print("Failed")
        }
        return values
    }


    private func saveGeoLocation(_ meteorId: String, geo: Geolocation) {
        
        //New Add
        let entity = NSEntityDescription.entity(forEntityName: DB.geoLocation, in: self.cdHelper.backgroundContext)
        let saveObject = NSManagedObject(entity: entity!, insertInto: self.cdHelper.backgroundContext)
        
        saveObject.setValue(geo.latitude, forKey: "latitude")
        saveObject.setValue(geo.longitude, forKey: "longitude")
        saveObject.setValue(meteorId, forKey: "meteorId")

        debugPrint("Inserted geo location")
        self.cdHelper.saveContext(context: self.cdHelper.backgroundContext)
    }
    
    private func getGeoLocation(_ meteorId: String) -> Geolocation? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: DB.geoLocation)
        request.predicate = NSPredicate(format: "meteorId = %@", meteorId)
        request.returnsObjectsAsFaults = false
        
        var value: Geolocation!
        do {
            let result = try self.cdHelper.backgroundContext.fetch(request)
            for data in result as! [NSManagedObject] {
                
                let latitude = (data.value(forKey: "latitude") as! String)
                let longitude = (data.value(forKey: "longitude") as! String)

                let geo = Geolocation.init(latitude: latitude, longitude: longitude)
                value = geo
            }
        }
        catch {
            print("Failed")
        }
        return value
    }


    
    internal func update(_ meteorId: String, isFavorite: Bool) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: DB.meteor)
        request.predicate = NSPredicate(format: "id = %@", meteorId)
        request.returnsObjectsAsFaults = false
        do {
            let result = try self.cdHelper.backgroundContext.fetch(request)
            for data in result as! [NSManagedObject] {
                debugPrint(data.value(forKey: "isfavorite") as Any)
                data.setValue(isFavorite, forKey: "isfavorite")
            }
        } catch {
            debugPrint("Failed udpateMeteor")
        }
        
        self.cdHelper.saveContext(context: self.cdHelper.backgroundContext)
    }

    
    private func removeMeteor(_ meteorId: String) {
        //Fetch
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: DB.meteor)
        request.predicate = NSPredicate(format: "id = %@", meteorId)
        request.returnsObjectsAsFaults = false
        do {
            let result = try self.cdHelper.backgroundContext.fetch(request)
            for data in result as! [NSManagedObject] {
                self.removeGeoLocation(meteorId)
                self.cdHelper.backgroundContext.delete(data)
            }
        } catch {
            debugPrint("Failed removeMeteor")
        }
    }
    
    private func removeGeoLocation(_ meteorId: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: DB.geoLocation)
        request.predicate = NSPredicate(format: "meteorId = %@", meteorId)
        request.returnsObjectsAsFaults = false
        do {
            let result = try self.cdHelper.backgroundContext.fetch(request)
            for data in result as! [NSManagedObject] {
                self.cdHelper.backgroundContext.delete(data)
            }
        } catch {
            debugPrint("Failed removeGeoLocation")
        }
    }


}
