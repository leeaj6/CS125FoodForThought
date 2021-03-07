//
//  AllergyViewController.swift
//  FoodForThought
//
//  Created by Alex Lee on 3/1/21.
//

import UIKit

class AllergyViewController: UIViewController {

    @IBOutlet weak var checkTableVIew: UITableView!
    
    // store allergy selection choices
    
    var allergies = [
        allergyCell(title: "Egg", isMarked: false),
        allergyCell(title: "Fish", isMarked: false),
        allergyCell(title: "Milk", isMarked: false),
        allergyCell(title: "Soy", isMarked: false),
        allergyCell(title: "Wheat", isMarked: false),
        allergyCell(title: "Nuts", isMarked: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        checkTableVIew.delegate = self
        checkTableVIew.dataSource = self
        
    }
    
    // MARK: Navigation to next view controller preserve inputs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSetupCuisine" {
            let dvc = segue.destination as! CuisineViewController
            
            // Pass marked allergies in array
            let passedAllergies: NSMutableArray = []
            for item in allergies {
                if item.isMarked {
                    passedAllergies.add(item.title)
                }
            }
            dvc.allergies = passedAllergies
        }
    }
}

extension AllergyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allergies.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = checkTableVIew.dequeueReusableCell(withIdentifier: "checkCell", for: indexPath) as! CheckCellTableViewCell
        
        let allergy = allergies[indexPath.row]
        
        cell.allergyLabel.text = allergy.title
        
        if allergy.isMarked {
            cell.checkMarkImageView.image = UIImage(named: "marked")
        }
        else{
            cell.checkMarkImageView.image = UIImage(named: "unmarked")
        }
        
        return cell
    }
    
    // On select cell
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? CheckCellTableViewCell else {return}
        
        var allergy = allergies[indexPath.row]
        allergy.isMarked = !allergy.isMarked
        allergies.remove(at: indexPath.row)
        allergies.insert(allergy, at: indexPath.row)
        
        if allergy.isMarked {
            cell.checkMarkImageView.image = UIImage(named: "marked")
        }
        else{
            cell.checkMarkImageView.image = UIImage(named: "unmarked")
        }
    }
    
    
}
