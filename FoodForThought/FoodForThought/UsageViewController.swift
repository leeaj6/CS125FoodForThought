//
//  UsageViewController.swift
//  FoodForThought
//
//  Created by Alex Lee on 3/6/21.
//

import UIKit

class UsageViewController: UIViewController {

    @IBOutlet weak var accentRect: UILabel!
    @IBOutlet weak var consumedTableView: UITableView!
    
    // usage label
    @IBOutlet weak var calorieUsageLabel: UILabel!
    @IBOutlet weak var proteinUsageLabel: UILabel!
    @IBOutlet weak var fatUsageLabel: UILabel!
    @IBOutlet weak var carbsUsageLabel: UILabel!
    @IBOutlet weak var sugarUsageLabel: UILabel!
    @IBOutlet weak var cholesterolUsageLabel: UILabel!
    @IBOutlet weak var sodiumUsageLabel: UILabel!
    @IBOutlet weak var fiberUsageLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accentRect?.layer.cornerRadius = 20.0
        accentRect?.layer.masksToBounds = true
        
        self.consumedTableView.delegate = self
        self.consumedTableView.dataSource = self
        
        if let presenter = presentingViewController as? DashboardViewController {
            print("Dash to Usage")
            print(presenter.dailyFoodItemsConsumed)
            self.calorieUsageLabel.text = String(format: "%.01f", (presenter.personalData.dailyCalorieUsage/presenter.personalData.dailyCalorieLimit)*100.0)+"%"
            self.proteinUsageLabel.text = String(format: "%.01f", (presenter.personalData.dailyProteinUsage/presenter.personalData.dailyProteinLimit)*100.0)+"%"
            self.fatUsageLabel.text = String(format: "%.01f", (presenter.personalData.dailyFatUsage/presenter.personalData.dailyFatLimit)*100.0)+"%"
            self.carbsUsageLabel.text = String(format: "%.01f", (presenter.personalData.dailyCarbsUsage/presenter.personalData.dailyCarbsLimit)*100.0)+"%"
            self.sugarUsageLabel.text = String(format: "%.01f", (presenter.personalData.dailySugarUsage/presenter.personalData.dailySugarLimit)*100.0)+"%"
            self.cholesterolUsageLabel.text = String(format: "%.01f", (presenter.personalData.dailyCholesterolUsage/presenter.personalData.dailyCholesterolLimit)*100.0)+"%"
            self.sodiumUsageLabel.text = String(format: "%.01f", (presenter.personalData.dailySodiumUsage/presenter.personalData.dailySodiumLimit)*100.0)+"%"
            self.fiberUsageLabel.text = String(format: "%.01f", (presenter.personalData.dailyFiberUsage/presenter.personalData.dailyFiberLimit)*100.0)+"%"
        }
    }

}

extension UsageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let presenter = presentingViewController as? DashboardViewController {
            return presenter.dailyFoodItemsConsumed.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = consumedTableView.dequeueReusableCell(withIdentifier: "consumedCell", for: indexPath) as! ConsumedTableViewCell
        
        if let presenter = presentingViewController as? DashboardViewController {
            
            let consumedItem = presenter.dailyFoodItemsConsumed[indexPath.row]
            
            cell.consumedCellLabel.text = (consumedItem as! consumedCell).title
            
            /*
             Lets get spicy and use the image url provided in the api document
             */
            
            if (consumedItem as! consumedCell).image == "null" {
                cell.consumedCellImage.image = UIImage(named: "dine")
            }
            else{
                func setImage(from url: String) {
                    guard let imageURL = URL(string: url) else { return }

                    DispatchQueue.global().async {
                        guard let imageData = try? Data(contentsOf: imageURL) else { return }

                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            cell.consumedCellImage.image = image
                        }
                    }
                }
                setImage(from: (consumedItem as! consumedCell).image)
            }
            
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        consumedTableView.deselectRow(at: consumedTableView.indexPathForSelectedRow!, animated: true)
    }
    
}
