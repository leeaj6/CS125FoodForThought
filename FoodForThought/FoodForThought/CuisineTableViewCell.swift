//
//  CuisineTableViewCell.swift
//  FoodForThought
//
//  Created by Alex Lee on 3/2/21.
//

import UIKit

class CuisineTableViewCell: UITableViewCell {

    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var checkMarkImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// store information for cell
struct cuisineCell {
    var title: String
    var isMarked: Bool
}
