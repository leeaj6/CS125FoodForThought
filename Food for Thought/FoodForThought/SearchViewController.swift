//
//  SearchViewController.swift
//  FoodForThought
//
//  Created by Alex Lee on 3/7/21.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    // pull from API
    var searchResults: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        //print(searchText)
        searchResults = [] // reset
        getSearchQuery(queryText: searchText)
    }
    
    // get search API with query text
    func getSearchQuery(queryText: String){
        let json: [String: Any] = [
            "query": queryText,
        ]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        var request = URLRequest(url: URL(string: "http://127.0.0.1:5000/api/v1/foods/search")!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            do {
                if error == nil {
                    // If we're successful, cool. Let's prepare to move on.
                    guard let myJson:[String:AnyObject] = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:AnyObject] else {return}

                    //print(myJson["data"] as! NSArray)
                    let meals = myJson["data"] as! NSArray
                    
                    for item in meals{
                        // general
                        let mealTitle = (item as AnyObject)["title"]!!
                        let mealRest = (item as AnyObject)["restaurant"]!!
                        let mealisBreakfast = (item as AnyObject)["breakfast"]!!
                        let mealCuisines = (item as AnyObject)["cuisine"]!!
                        let mealAllergies = (item as AnyObject)["allergies"]!!
                        let mealPrice = (item as AnyObject)["price"]!!
                        
                        // nutrition
                        let mealCalories = ((item as AnyObject)["nutrition"]!! as! Dictionary<String, Any>)["calories"]!
                        let mealProtein = ((item as AnyObject)["nutrition"]!! as! Dictionary<String, Any>)["protein"]!
                        let mealCarbs = ((item as AnyObject)["nutrition"]!! as! Dictionary<String, Any>)["carbs"]!
                        let mealSugar = ((item as AnyObject)["nutrition"]!! as! Dictionary<String, Any>)["sugar"]!
                        let mealCholesterol = ((item as AnyObject)["nutrition"]!! as! Dictionary<String, Any>)["cholesterol"]!
                        let mealSodium = ((item as AnyObject)["nutrition"]!! as! Dictionary<String, Any>)["sodium"]!
                        let mealFiber = ((item as AnyObject)["nutrition"]!! as! Dictionary<String, Any>)["fiber"]!
                        let mealFat = ((item as AnyObject)["nutrition"]!! as! Dictionary<String, Any>)["fat"]!
                        let mealTransFat = ((item as AnyObject)["nutrition"]!! as! Dictionary<String, Any>)["transFat"]!
                        let mealSaturatedFat = ((item as AnyObject)["nutrition"]!! as! Dictionary<String, Any>)["saturatedFat"]!
                        
                        // graphic
                        let imageUrl = (item as AnyObject)["image_url"]!!
                        
                        //print(item)
                        
                        // check if image is nil
                        if (object_getClass(imageUrl)?.description() != "NSNull"){
                            self.searchResults.add(searchCell(
                                                        title: mealTitle as! String,
                                                        restaurant: mealRest as! String, // maybe do a name Conversion ex: CFA -> Chick-Fil-A
                                                        breakfast: mealisBreakfast as! Bool,
                                                        cuisines: mealCuisines as! Array<String>,
                                                        allergies: mealAllergies as! Array<String>,
                                                        calories: mealCalories as! Double,
                                                        protein: mealProtein as! Double,
                                                        carbs: mealCarbs as! Double,
                                                        sugar: mealSugar as! Double,
                                                        cholesterol: object_getClass(mealCholesterol)?.description() != "NSNull" ? (mealCholesterol as! Double): 0.0,
                                                        sodium: mealSodium as! Double,
                                                        fiber: object_getClass(mealFiber)?.description() != "NSNull" ? (mealFiber as! Double): 0.0,
                                                        fat: mealFat as! Double,
                                                        transFat: mealTransFat as! Double,
                                                        saturatedFat: mealSaturatedFat as! Double,
                                                        image: (imageUrl as! String).replacingOccurrences(of: "http://", with: "https://"),
                                                        price: mealPrice as! Double)
                            )
                        }
                        else{
                            self.searchResults.add(searchCell(
                                                        title: mealTitle as! String,
                                                        restaurant: mealRest as! String, // maybe do a name Conversion ex: CFA -> Chick-Fil-A
                                                        breakfast: mealisBreakfast as! Bool,
                                                        cuisines: mealCuisines as! Array<String>,
                                                        allergies: mealAllergies as! Array<String>,
                                                        calories: mealCalories as! Double,
                                                        protein: mealProtein as! Double,
                                                        carbs: mealCarbs as! Double,
                                                        sugar: mealSugar as! Double,
                                                        cholesterol: object_getClass(mealCholesterol)?.description() != "NSNull" ? (mealCholesterol as! Double): 0.0,
                                                        sodium: mealSodium as! Double,
                                                        fiber: object_getClass(mealFiber)?.description() != "NSNull" ? (mealFiber as! Double): 0.0,
                                                        fat: mealFat as! Double,
                                                        transFat: mealTransFat as! Double,
                                                        saturatedFat: mealSaturatedFat as! Double,
                                                        image: "null",
                                                        price: mealPrice as! Double)
                            )
                        }
                        //print(mealTitle)
                    }
                    DispatchQueue.main.async {
                        self.searchTableView.reloadData()
                        print("TableView Contents Reloaded")
                    }

                } else {
                    //error
                }
            } catch {
                //error
                print("Error parsing JSON")
            }
        })

        task.resume()
    }

}

// handle search TableView
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    // fill in cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        
        let result = searchResults[indexPath.row]
        
        cell.searchCellLabel.text = (result as! searchCell).title
        
        /*
         Lets get spicy and use the image url provided in the api document
         */
        
        if (result as! searchCell).image == "null" {
            cell.searchCellImage.image = UIImage(named: "dine")
        }
        else{
            func setImage(from url: String) {
                guard let imageURL = URL(string: url) else { return }

                DispatchQueue.global().async {
                    guard let imageData = try? Data(contentsOf: imageURL) else { return }

                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        cell.searchCellImage.image = image
                    }
                }
            }
            setImage(from: (result as! searchCell).image)
        }
        
        return cell
    }
    
    // When we select a table view item
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // show Catalog Item
        performSegue(withIdentifier: "showCatalogItem", sender: self)
    }
    
    // MARK: Navigation to next view controller preserve inputs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCatalogItem" {
            let dvc = segue.destination as! CatalogItemViewController
            
            // pass item information
            print(searchTableView.indexPathForSelectedRow!.row)
            let result = searchResults[searchTableView.indexPathForSelectedRow!.row]
            
            dvc.itemTitle = (result as! searchCell).title
            dvc.itemImage = (result as! searchCell).image
            dvc.restaurant = (result as! searchCell).restaurant
            dvc.breakfast = (result as! searchCell).breakfast
            dvc.cuisines = (result as! searchCell).cuisines
            dvc.allergies = (result as! searchCell).allergies
            dvc.calories = (result as! searchCell).calories
            dvc.protein = (result as! searchCell).protein
            dvc.carbs = (result as! searchCell).carbs
            dvc.sugar = (result as! searchCell).sugar
            dvc.cholesterol = (result as! searchCell).cholesterol
            dvc.sodium = (result as! searchCell).sodium
            dvc.fiber = (result as! searchCell).fiber
            dvc.fat = (result as! searchCell).fat
            dvc.transFat = (result as! searchCell).transFat
            dvc.saturatedFat = (result as! searchCell).saturatedFat
            dvc.price = (result as! searchCell).price
            
            // deselect that cell
            searchTableView.deselectRow(at: searchTableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
}
