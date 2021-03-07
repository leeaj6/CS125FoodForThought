//
//  HealthInformationViewController.swift
//  FoodForThought
//
//  Created by Alex Lee on 3/2/21.
//

import UIKit

class HealthInformationViewController: UIViewController {
    // Passed Inputs
    var allergies: NSArray!
    var cuisines: NSArray!
    var budget: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: Navigation to next view controller preserve inputs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDashboard" {
            let dvc = segue.destination as! DashboardViewController
            
            dvc.allergies = allergies
            dvc.cuisines = cuisines
            
            dvc.budget = budget
        }
    }

}
