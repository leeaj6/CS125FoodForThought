//
//  ConsumedTableViewCell.swift
//  FoodForThought
//
//  Created by Alex Lee on 3/7/21.
//

import UIKit

class ConsumedTableViewCell: UITableViewCell {

    @IBOutlet weak var consumedCellImage: UIImageView!
    @IBOutlet weak var consumedCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

struct consumedCell {
    var title: String
    var restaurant: String
    var breakfast: Bool
    var cuisines: Array<String>
    var allergies: Array<String>
    var calories: Double
    var protein: Double
    var carbs: Double
    var sugar: Double
    var cholesterol: Double
    var sodium: Double
    var fiber: Double
    var fat: Double
    var transFat: Double
    var saturatedFat: Double
    var image: String
    var price: Double
}
