//
//  Receipt.swift
//  alura-ponto
//
//  Created by c94289a on 23/02/22.
//

import Foundation
import UIKit
import CoreData

@objc(Receipt)
class Receipt: NSManagedObject {
    @NSManaged var identifier: UUID
    @NSManaged var status: Bool
    @NSManaged var date: Date
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
//    @NSManaged var photo: UIImage
    
    convenience init(status: Bool, date: Date, latitude: Double, longitude: Double) {
        let context = DataBaseController.persistentContainer.viewContext
        self.init(context: context)
        self.identifier = UUID()
        self.status = status
        self.date = date
        self.longitude = longitude
        self.latitude = latitude
//        self.photo = photo
    }
}

extension Receipt {
    func save(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func fetchRequest() -> NSFetchRequest<Receipt> {
        return NSFetchRequest(entityName: "Receipt")
    }
    
    class func load(_ fetchedResultController: NSFetchedResultsController<Receipt>) {
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete(_ context: NSManagedObjectContext) {
        context.delete(self)
        save(context)
    }
}
