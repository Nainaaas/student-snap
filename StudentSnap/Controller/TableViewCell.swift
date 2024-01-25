//
//  TableViewCell.swift
//  StudentSnap
//
//  Created by Shahina Kassim on 01/12/23.
//

import UIKit
protocol tableViewCellDelegate{
    func didTapEdit(indexPAth: Int)
}

class TableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
  
  
    @IBOutlet weak var editButton: UIButton!
    var delegate : tableViewCellDelegate?
    
   
    var student: Student?{
        didSet{
            nameLabel.text = student?.name
          
            if #available(iOS 16.0, *) {
                let imagePath = URL.documentsDirectory.appendingPathComponent(student?.userImage ?? "").appendingPathExtension(".png")
                if let image = UIImage(contentsOfFile: imagePath.path()){
                    profilePic.image = image
                }else{
                    profilePic.image = UIImage(systemName: "person.circle.fill")
                }
            } else {
                profilePic.image = UIImage(systemName: "person.circle.fill")
            }
           
                
            
        }
    }
   
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func EditAction(_ sender: UIButton) {
        delegate?.didTapEdit(indexPAth: sender.tag)
    }
    
}
