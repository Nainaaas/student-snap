//
//  StudentDetailViewController.swift
//  StudentSnap
//
//  Created by Shahina Kassim on 05/12/23.
//

import UIKit

@available(iOS 16.0, *)
class StudentDetailViewController: UIViewController {
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var mailIDLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var student: Student?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        configureUI()
        
    }
    @IBAction func EditAction(_ sender: Any) {
        let AddStudentVC = self.storyboard?.instantiateViewController(withIdentifier: "AddStudentViewController") as!  AddStudentViewController
        AddStudentVC.isUpdating = true
        AddStudentVC.delegate = self
        AddStudentVC.index = index
        AddStudentVC.student = student
        self.navigationController?.pushViewController(AddStudentVC, animated: true)
    }
    func configureUI(){
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        self.title = student?.name ?? ""
        let editButton = UIBarButtonItem(title: Constants.edit, style: .plain, target: self, action: #selector(EditAction))
      //  editButton.tintColor = UIColor(red: 196/255.0, green: 126/255.0, blue: 139/255.0, alpha: 1.0)
        self.navigationItem.rightBarButtonItem = editButton
        self.navigationController?.navigationBar.tintColor = UIColor(red: 196/255.0, green: 126/255.0, blue: 139/255.0, alpha: 1.0)
    }
    func updateView(){
        if let studentDta = student{
            nameLabel.text = studentDta.name
            ageLabel.text = String(studentDta.age)
            placeLabel.text = studentDta.place
            mailIDLabel.text = studentDta.mailID
            let imgPath = URL.documentsDirectory.appendingPathComponent(studentDta.userImage ?? "").appendingPathExtension(".png")
            if let img = UIImage(contentsOfFile: imgPath.path()){
                profileImg.image = img
            }else{
                profileImg.image = UIImage(named: "person.circle.fill")
            }
        }
    }
   

}
@available(iOS 16.0, *)
extension StudentDetailViewController : EditCompleted{
    func editSaved(student: Student) {
        self.student = student
        updateView()
        
    }
    
    
}
