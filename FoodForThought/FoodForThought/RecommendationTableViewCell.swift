//
//  RecommendationTableViewCell.swift
//  FoodForThought
//
//  Created by Alex Lee on 3/3/21.
//

import UIKit

class RecommendationTableViewCell: UITableViewCell {

    @IBOutlet weak var recLabel: UILabel!
    @IBOutlet weak var recImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

struct recommendationCell {
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

/*
 {
     "_id": {
         "$oid": "600e6c2287995719ada44a04"
     },
     "title": "Grilled Chicken Sandwich",
     "restaurant": "CFA",
     "breakfast": false,
     "cuisine": [
         "American",
         "Fast Food"
     ],
     "allergies": [
         "Wheat"
     ],
     "nutrition": {
         "calories": 320,
         "protein": 28,
         "carbs": 41,
         "sugar": 9,
         "cholesterol": 70,
         "sodium": 680,
         "fiber": 4,
         "fat": 6,
         "transFat": 0,
         "saturatedFat": 1
     },
     "image_url": "http://www.cfacdn.com/img/order/menu/Mobile/Entrees/Parent/grilledChickenSandwich_test.png",
     "price": 5.95
 }
 */
