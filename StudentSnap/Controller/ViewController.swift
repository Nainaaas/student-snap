//
//  ViewController.swift
//  StudentSnap
//
//  Created by Shahina Kassim on 30/11/23.
//

import UIKit

@available(iOS 16.0, *)
class ViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{
   
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var students : [Student] = []
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableview.isUserInteractionEnabled = true
       
        students  = CoreDataHelper.shared.fetch()
    }
    override func viewWillAppear(_ animated: Bool) {
        students  = CoreDataHelper.shared.fetch()
        tableview.reloadData()
    }
    @IBAction func addStudent(_ sender: Any) {
        let AddStudentVC = self.storyboard?.instantiateViewController(withIdentifier: "AddStudentViewController") as! AddStudentViewController
    AddStudentVC.isUpdating = false
        self.navigationController?.pushViewController(AddStudentVC, animated: true)
   
    }
 
    
    //MARK:- tableview methods
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.student = students[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            students = CoreDataHelper.shared.delete(indexpath: indexPath.row)
            tableView.reloadData()
        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "StudentDetailViewController") as!  StudentDetailViewController
        
        studentDetailVC.index = indexPath.row
        studentDetailVC.student = students[indexPath.row]
        self.navigationController?.pushViewController(studentDetailVC, animated: true)
    }
    
}
@available(iOS 16.0, *)
extension ViewController: UISearchBarDelegate{
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text , !searchText.isEmpty, let age = Int(searchText){
            students =  CoreDataHelper.shared.fetchWithFilter(filter: age)
            tableview.reloadData()
        }else{
          students =   CoreDataHelper.shared.fetch()
            tableview.reloadData()
        }
    }
}
