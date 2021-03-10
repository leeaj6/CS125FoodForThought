//
//  CuisineViewController.swift
//  FoodForThought
//
//  Created by Alex Lee on 3/2/21.
//

import UIKit

class CuisineViewController: UIViewController {

    @IBOutlet weak var cuisineTableView: UITableView!
    
    // store cuisine selection choices
    /*
    var cuisines = [
        "American",
        "Chinese",
        "Mexican",
        "Fast Food",
        "Italian",
        "Seafood",
        "Japanese",
        "Pizza"
    ]
 */
    // passed vars
    var allergies: NSArray!
    
    // new stuff
    var cuisines = [
        cuisineCell(title: "American", isMarked: false),
        cuisineCell(title: "Asian", isMarked: false),
        cuisineCell(title: "Mexican", isMarked: false),
        cuisineCell(title: "Fast Food", isMarked: false),
        cuisineCell(title: "Italian", isMarked: false),
        cuisineCell(title: "Seafood", isMarked: false),
        cuisineCell(title: "Pizza", isMarked: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("Cuisine VC")
        //print(allergies ?? "Nothing here")

        // Do any additional setup after loading the view.
        cuisineTableView.delegate = self
        cuisineTableView.dataSource = self
    }
    
    // MARK: Navigation to next view controller preserve inputs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSetupBudget" {
            let dvc = segue.destination as! BudgetViewController
            
            dvc.allergies = allergies
            
            // Pass marked cuisines in array
            let passedCuisines: NSMutableArray = []
            for item in cuisines {
                if item.isMarked {
                    passedCuisines.add(item.title)
                }
            }
            dvc.cuisines = passedCuisines
        }
    }
    
}

extension CuisineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cuisines.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cuisineTableView.dequeueReusableCell(withIdentifier: "checkCell", for: indexPath) as! CuisineTableViewCell
        
        let cuisine = cuisines[indexPath.row]
        
        cell.cuisineLabel.text = cuisine.title
        
        if cuisine.isMarked {
            cell.checkMarkImage.image = UIImage(named: "marked")
        }
        else{
            cell.checkMarkImage.image = UIImage(named: "unmarked")
        }
        
        return cell
    }
    
    // On select cell
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? CuisineTableViewCell else {return}
        
        var cuisine = cuisines[indexPath.row]
        cuisine.isMarked = !cuisine.isMarked
        cuisines.remove(at: indexPath.row)
        cuisines.insert(cuisine, at: indexPath.row)
        
        if cuisine.isMarked {
            cell.checkMarkImage.image = UIImage(named: "marked")
        }
        else{
            cell.checkMarkImage.image = UIImage(named: "unmarked")
        }
    }
}
