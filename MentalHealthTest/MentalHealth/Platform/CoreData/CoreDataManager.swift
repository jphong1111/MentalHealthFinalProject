//
//  CoreDataManager.swift
//  MentalHealth
//
//  Created by JungpyoHong on 2/10/25.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}

//    lazy var starPersistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "StarCountModel")
//        container.loadPersistentStores { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        }
//        return container
//    }()
}

#if DEBUG
extension CoreDataManager {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: CoreDataManager

    }
}
#endif