//
//  CatalogItemViewController.swift
//  FoodForThought
//
//  Created by Alex Lee on 3/4/21.
//

import UIKit

class CatalogItemViewController: UIViewController {

    @IBOutlet weak var itemRestLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemTitleLabel: UILabel!
    
    // Nutrition Labels
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var cholestrolLabel: UILabel!
    @IBOutlet weak var sodiumLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var sugarLabel: UILabel!
    @IBOutlet weak var fiberLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    
    @IBOutlet weak var allergiesLabel: UILabel!
    
    // add to my meals button
    @IBOutlet weak var addToMealsButton: UIButton!
    
    
    // passed inputs
    var itemTitle: String!
    var itemImage: String!
    var restaurant: String!
    var breakfast: Bool!
    var cuisines: Array<String>!
    var allergies: Array<String>!
    var calories: Double!
    var protein: Double!
    var carbs: Double!
    var sugar: Double!
    var cholesterol: Double!
    var sodium: Double!
    var fiber: Double!
    var fat: Double!
    var transFat: Double!
    var saturatedFat: Double!
    var price: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set labels
        self.itemTitleLabel.text = itemTitle
        self.itemPriceLabel.text = String(format: "$%.02f", price)
        self.itemRestLabel.text = restaurant
        
        // nutrition labels
        self.caloriesLabel.text = String(format: "%.01f", calories)
        self.proteinLabel.text = String(format: "%.01f", protein)
        self.cholestrolLabel.text = String(format: "%.01f", cholesterol)
        self.sodiumLabel.text = String(format: "%.01f", sodium)
        self.carbsLabel.text = String(format: "%.01f", carbs)
        self.sugarLabel.text = String(format: "%.01f", sugar)
        self.fiberLabel.text = String(format: "%.01f", fiber)
        self.fatLabel.text = String(format: "%.01f", fat)
        
        // allergies list
        self.allergiesLabel.text = allergies.joined(separator: ", ")
        
        // set Image
        if itemImage == "null" {
            // No image is available
            itemImageView.image = UIImage(named: "dine")
        }
        else{
            // set image from url
            func setImage(from url: String) {
                guard let imageURL = URL(string: url) else { return }

                DispatchQueue.global().async {
                    guard let imageData = try? Data(contentsOf: imageURL) else { return }

                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        self.itemImageView.image = image
                    }
                }
            }
            setImage(from: itemImage)
        }

    }
    
    @IBAction func addToMeals(_ sender: Any) {
        print("Button Touched")
        if let presenter = presentingViewController as? DashboardViewController {
            print(presenter.personalData)
            // update nutrition usage
            presenter.personalData.dailyCalorieUsage = presenter.personalData.dailyCalorieUsage + calories
            presenter.personalData.dailyProteinUsage = presenter.personalData.dailyProteinUsage + protein
            presenter.personalData.dailyCarbsUsage = presenter.personalData.dailyCarbsUsage + carbs
            presenter.personalData.dailySugarUsage = presenter.personalData.dailySugarUsage + sugar
            presenter.personalData.dailyCholesterolUsage = presenter.personalData.dailyCholesterolUsage + cholesterol
            presenter.personalData.dailySodiumUsage = presenter.personalData.dailySodiumUsage + sodium
            presenter.personalData.dailyFiberUsage = presenter.personalData.dailyFiberUsage + fiber
            presenter.personalData.dailyFatUsage = presenter.personalData.dailyFatUsage + fat
            
            // update spending
            presenter.personalData.spent = presenter.personalData.spent + price
            print("Spent Updated")
            print(presenter.personalData.spent)
            print(presenter.personalData)
            
            // update labels on dashboard
            DispatchQueue.main.async {
                // fill in labels for dashboard
                presenter.spentLabel.text = String(format: "$%.02f", presenter.personalData.spent)
                presenter.maxBudgetLabel.text = String(format: "$%.02f", presenter.personalData.budget)

                presenter.dailyCalorieUsageLabel.text = String(format: "%d", Int(presenter.personalData.dailyCalorieUsage))

                presenter.dailyCaloriePercentageLabel.text = String(format: "%.01f", (Double(presenter.personalData.dailyCalorieUsage)/Double(presenter.personalData.dailyCalorieLimit))*100.0)+"%"
                // update progress bar for budget
                presenter.populateGraph()
                // request new recommendations from API
                presenter.updateRecommendations()
                // add to consumed today
                presenter.dailyFoodItemsConsumed.add(consumedCell(
                                                        title: self.itemTitle,
                                                        restaurant: self.restaurant,
                                                        breakfast: self.breakfast,
                                                        cuisines: self.cuisines,
                                                        allergies: self.allergies,
                                                        calories: self.calories,
                                                        protein: self.protein,
                                                        carbs: self.carbs,
                                                        sugar: self.sugar,
                                                        cholesterol: self.cholesterol,
                                                        sodium: self.sodium,
                                                        fiber: self.fiber,
                                                        fat: self.fat,
                                                        transFat: self.transFat,
                                                        saturatedFat: self.saturatedFat,
                                                        image: self.itemImage,
                                                        price: self.price)
                )
            }
            print("dailyFoodItemsConsumed")
            print(presenter.dailyFoodItemsConsumed)
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Navigation to next view controller preserve inputs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*
        if segue.identifier == "showCatalogItem" {
            let dvc = segue.destination as! CatalogItemViewController
        }
         */
        print("Catalog Item Segue")
    }

}
