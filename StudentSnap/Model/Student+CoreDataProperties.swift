//
//  Student+CoreDataProperties.swift
//  StudentSnap
//
//  Created by Shahina Kassim on 30/11/23.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var place: String?
    @NSManaged public var mailID: String?

}

extension Student : Identifiable {

}
