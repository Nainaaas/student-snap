//
//  Student+CoreDataProperties.swift
//  StudentSnap
//
//  Created by Shahina Kassim on 04/12/23.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var age: Int16
    @NSManaged public var mailID: String?
    @NSManaged public var name: String?
    @NSManaged public var place: String?
    @NSManaged public var userImage: String?

}

extension Student : Identifiable {

}
