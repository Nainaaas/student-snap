//
//  Lesson+CoreDataProperties.swift
//  StudentSnap
//
//  Created by Shahina Kassim on 07/12/23.
//
//

import Foundation
import CoreData


extension Lesson {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lesson> {
        return NSFetchRequest<Lesson>(entityName: "Lesson")
    }

    @NSManaged public var name: String?

}

extension Lesson : Identifiable {

}
