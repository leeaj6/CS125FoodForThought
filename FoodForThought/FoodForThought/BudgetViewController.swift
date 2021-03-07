//
//  BudgetViewController.swift
//  FoodForThought
//
//  Created by Alex Lee on 3/2/21.
//

import UIKit

class BudgetViewController: UIViewController {
    
    var allergies: NSArray!
    var cuisines: NSArray!
    
    var budget: Double!

    @IBOutlet weak var budgetTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Budget VC")
        print(allergies ?? "Nothing here")
        print(cuisines ?? "Nothing here")

        // Do any additional setup after loading the view.
    }
    
    // MARK: Navigation to next view controller preserve inputs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSetupHealth" {
            let dvc = segue.destination as! HealthInformationViewController
            
            dvc.allergies = allergies
            dvc.cuisines = cuisines
            
            dvc.budget = Double(budgetTextField.text!)
        }
    }
    
}
