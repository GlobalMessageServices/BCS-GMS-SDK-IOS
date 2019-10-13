//
//  sk_sdk_init.swift
//  sksdk
//
//  Created by Дмитрий Буйновский on 28/07/2019.
//  Copyright © 2019 Дмитрий Буйновский. All rights reserved.
//

import Foundation
import CoreData

@objc public class Company: NSManagedObject {
    
    @NSManaged public var inn: String?
    @NSManaged public var name: String?
    @NSManaged public var uid: String?
    @NSManaged public var employee: NSSet?
}


class SDKinit {
    
    let uuid = NSUUID().uuidString
    
    public func uuidprint() {
        print(uuid)
    }
    
    public func testcore(){
        
        var persistentContainer: NSPersistentContainer = {
            
            let container = NSPersistentContainer(name: "DataModel")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                print("storeDescription = \(storeDescription)")
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        } ()
        
        
        
        //let company1 = NSEntityDescription.insertNewObject(forEntityName: "Company", into: moc)
       // company1.setValue("077456789111", forKey: "inn")
       // company1.setValue("Натура кура", forKey: "name")
        
    }
    
    
    
}
