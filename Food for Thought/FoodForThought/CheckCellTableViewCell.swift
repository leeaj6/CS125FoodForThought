//
//  CheckCellTableViewCell.swift
//  FoodForThought
//
//  Created by Alex Lee on 3/1/21.
//

import UIKit

class CheckCellTableViewCell: UITableViewCell {

    @IBOutlet weak var allergyLabel: UILabel!
    @IBOutlet weak var checkMarkImageView: UIImageView!
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
struct allergyCell {
    var title: String
    var isMarked: Bool
}
