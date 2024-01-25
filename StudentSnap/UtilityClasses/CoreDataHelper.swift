//
//  CoreDataHelper.swift
//  StudentSnap
//
//  Created by Shahina Kassim on 30/11/23.
//

import Foundation
import CoreData

enum error:Error{
    case fetchError
}

@available(iOS 16.0, *)
class CoreDataHelper{
    
    static var shared = CoreDataHelper()
    
    func save(data:StudentModel,completion: ( Error?) -> Void){
        
        let student = Student(context: PersistentStorage.sharedStorage.context)
        student.name = data.name
        student.age = data.age
        student.place = data.place
        student.mailID = data.mailID
        student.userImage = data.userImage
        do{
            try PersistentStorage.sharedStorage.context.save()
            completion(nil)
        }catch let error as validationError{
            completion(error)
            
        }catch{
            completion(error)
        }
      
        
    }
    func fetch() -> [Student]{
        
        var students = [Student]()
        let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
         
        do {
            students = try PersistentStorage.sharedStorage.context.fetch(fetchRequest)
            
        } catch {
            print("Error fetching data: \(error)")
        }
        return students
    }
    func fetchWithFilter(filter: Int) -> [Student]{
        var studentsAfterFilter = [Student]()
        let request: NSFetchRequest<Student> = Student.fetchRequest()
        let pred = NSPredicate(format: "age == %d", filter)
        request.predicate = pred
        do{
            studentsAfterFilter = try PersistentStorage.sharedStorage.context.fetch(request)
        }catch{
            print("Fetch with filter \(filter) failed with error: \(error)")
        }
        return studentsAfterFilter
    }
    func delete(indexpath : Int) ->[Student]{
        var students = fetch()
        let imgURL = URL.documentsDirectory.appendingPathComponent(students[indexpath].userImage ?? "").appendingPathExtension(".png")
        do{
            try FileManager.default.removeItem(at: imgURL)
        }catch{
            print("Removing from document directory is failed with error:",error.localizedDescription.description)
        }
        PersistentStorage.sharedStorage.context.delete(students[indexpath])
        students.remove(at: indexpath)
        PersistentStorage.sharedStorage.saveContext()
        return students
        
    }
    func edit(indexPAth: Int, ModifiedData: StudentModel,completion: ( Student?) -> Void){
        var students = fetch()
        students[indexPAth].name = ModifiedData.name
        students[indexPAth].age = ModifiedData.age
        students[indexPAth].place = ModifiedData.place
        students[indexPAth].mailID = ModifiedData.mailID
        students[indexPAth].userImage = ModifiedData.userImage
        do{
         try PersistentStorage.sharedStorage.context.save()
            completion(students[indexPAth])
        }
        catch{
           completion(nil)
        }
        
    }
}
