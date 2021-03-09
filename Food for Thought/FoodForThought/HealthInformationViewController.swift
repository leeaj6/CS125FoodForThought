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
    
    // new inputs
    var genderIsMale: Bool = true
    
    @IBOutlet weak var picker: UIPickerView!
    
    // input fields
    @IBOutlet weak var weightInput: UITextField!
    @IBOutlet weak var heightFeetInput: UITextField!
    @IBOutlet weak var heightInchesInput: UITextField!
    @IBOutlet weak var ageInput: UITextField!
    @IBOutlet weak var dailyStepsGoalInput: UITextField!
    
    
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerData = ["Male", "Female"]
        self.picker.delegate = self
        self.picker.dataSource = self
    }
    

    // MARK: Navigation to next view controller preserve inputs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDashboard" {
            let dvc = segue.destination as! DashboardViewController
            
            dvc.allergies = allergies
            dvc.cuisines = cuisines
            dvc.budget = budget
            
            // new stuff
            dvc.weight = Double(weightInput.text!)
            dvc.heightFT = Int(heightFeetInput.text!)
            dvc.heightIN = Int(heightInchesInput.text!)
            dvc.age = Int(ageInput.text!)
            dvc.genderIsMale = genderIsMale
            dvc.dailyStepsGoal = Int(dailyStepsGoalInput.text!)
        }
    }

}

// gender picker view
extension HealthInformationViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerData[row] == "Male" {
            genderIsMale = true
            print("Male Selected")
        }
        else{
            genderIsMale = false
            print("Female Selected")
        }
    }
    
}
