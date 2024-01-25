//
//  AddStudentViewController.swift
//  StudentSnap
//
//  Created by Shahina Kassim on 30/11/23.
//

import UIKit
import PhotosUI

protocol EditCompleted{
    func editSaved(student: Student)
}

@available(iOS 16.0, *)
class AddStudentViewController: UIViewController {
    @IBOutlet weak var nameTxt: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var placeTxt: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var ageTxt: UITextField!
    var userProfilePicSelected: Bool = false
    var isUpdating: Bool?
    var student: Student?
    var index: Int?
    var delegate: EditCompleted?
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        profileImageconfig()
        
    }
    func profileImageconfig(){
        let imageTap = UITapGestureRecognizer(target: self,action:#selector(imageTap))
        profileImage.addGestureRecognizer(imageTap)
    }
    @objc func imageTap(){
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        let photoVC = PHPickerViewController(configuration: config)
        photoVC.delegate = self
        self.present(photoVC, animated: true)
    }
    func saveImageToDocumentDirectory(imageName: String){
        let filePath = URL.documentsDirectory.appendingPathComponent(imageName).appendingPathExtension(".png")
        if let imageData = profileImage.image?.pngData(){
            do{
              try imageData.write(to: filePath)
            }catch{
                print("image saving to document directory is failed")
            }
        }
    }
    func configureUI(){
        if let isEdit = isUpdating, isEdit{
            self.title = Constants.edit
            if let studentData = student{
                self.nameTxt.text = studentData.name
                self.ageTxt.text = String(studentData.age)
                self.emailTxt.text = studentData.mailID
                self.placeTxt.text = studentData.place
                let imapgePath = URL.documentsDirectory.appendingPathComponent(studentData.userImage ?? "").appendingPathExtension(".png")
                if let image = UIImage(contentsOfFile: imapgePath.path()) {
                    self.profileImage.image = image
                }
                else{
                    self.profileImage.image = UIImage(systemName: "person.circle.fill")
                }
                
            }
            
        }else{
            self.title = Constants.AddStudent
        }
        
        self.profileImage.layer.cornerRadius = profileImage.frame.size.height/2
    }
    func refreshView(){
        nameTxt.text = ""
        ageTxt.text = ""
        placeTxt.text = ""
        emailTxt.text = ""
        profileImage.image = UIImage(systemName: "person.circle.fill")
    }
    @IBAction func AddStudent(_ sender: Any) {
       
        
        guard let name = nameTxt.text , !name.isEmpty else {
            Utility.alert(with: Constants.missingTitle, message: Constants.missingName, controller: self,completion: nil)
            return
        }
        guard let ageString = ageTxt.text, let age = Int16(ageString) else{
            Utility.alert(with: Constants.missingTitle, message: Constants.missingAge, controller: self,completion: nil)
            return
        }
        guard let place = placeTxt.text, !place.isEmpty else{
            Utility.alert(with: Constants.missingTitle, message: Constants.missingPlace, controller: self, completion: nil)
            return
        }
        guard let mailID = emailTxt.text, !mailID.isEmpty else{
            Utility.alert(with: Constants.missingTitle, message: Constants.missingMaildId, controller: self, completion: nil)
            return
        }
        let imageName: String?
        if (student == nil){
            imageName  = UUID().uuidString
        }
        else{
            self.userProfilePicSelected = true
            imageName = student?.userImage
        }
        if !userProfilePicSelected{
            Utility.alert(with: Constants.missingTitle, message: Constants.profilePicMissing, controller: self, completion: nil)
            return
        }
        
        saveImageToDocumentDirectory(imageName: imageName ?? "")
        let studentObj = StudentModel(name: name, age: age, place: place, mailID: mailID,userImage: imageName ?? "")
        
        
        if let editing = isUpdating,let indexPath = index, editing{
            CoreDataHelper.shared.edit(indexPAth: indexPath, ModifiedData: studentObj) { studentData in
                if let data = studentData{
                    refreshView()
                    delegate?.editSaved(student: data)
                    self.navigationController?.popViewController(animated: true)
                    Utility.alert(with: Constants.success, message: Constants.editSuccessMsg, controller: self, completion: nil)
                    
                    
                }
                else{
                    Utility.alert(with: Constants.failed , message: Constants.editFailedMsg, controller: self, completion: nil)
                }
            }
            
        }else{
            CoreDataHelper.shared.save(data: studentObj, completion:{errorValue in
                if let error = errorValue{
                    if(error as? validationError == validationError.invalidEmailFormat){
                        Utility.alert(with:Constants.invalidEmailFormat, message: "", controller: self, completion: nil)
                    }else{
                        Utility.alert(with: error.localizedDescription.description, message: "", controller: self, completion: nil)
                    }
                    
                }else{
                    refreshView()
                  //  self.navigationController?.popViewController(animated: true)
                     Utility.alert(with: Constants.savedMessage, message: "", controller: self, completion: nil)

                }
            } )
        }
    }
    


}
@available(iOS 16.0, *)
extension AddStudentViewController: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                guard let image  = image as? UIImage else{
                    return
                }
                DispatchQueue.main.async {
                    self.profileImage.image = image
                    self.userProfilePicSelected = true
                }
                
            }
        }
    }
    
    
}
