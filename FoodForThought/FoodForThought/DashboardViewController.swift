//
//  DashboardViewController.swift
//  FoodForThought
//
//  Created by Alex Lee on 3/2/21.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var recommendationsTableView: UITableView!
    @IBOutlet weak var spentLabel: UILabel!
    @IBOutlet weak var dailyCalorieUsageLabel: UILabel!
    @IBOutlet weak var dailyCaloriePercentageLabel: UILabel!
    @IBOutlet weak var maxBudgetLabel: UILabel!
    
    // search bar
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Passed Inputs
    var allergies: NSArray!
    var cuisines: NSArray!
    var budget: Double!
    
    // keep track of food items for the day - store recommendationCell structs maybe?
    var dailyFoodItemsConsumed: NSMutableArray = []
    
    // add some additional vars like day of week etc
    
    // pull from API in viewWillAppear
    var recommendations: NSMutableArray = []
    
    let shapeLayer = CAShapeLayer() // circle
    
    // SOME OF THESE UPDATE ON VIEW LOAD - personal model attributes
    /*
     GURMAN HERE: add daily values from struct def
     */
    
    func CalorieLimit(gender : Bool,weight: Int, inches: Int,age: Int) -> Double{
        let realage = Double(age)
        let realheight = Double(inches)
        let realweight = Double(weight)
        if (gender){
            let first = 66.0 + (6.3 * realweight) + (12.9 * realheight)
            let second = first - (6.8 * realage)
            let answer = second * 1.375
            return answer
        }
        else{
            let first = 47.0 + (4.3 * realweight) + (4.7 * realheight)
            let second = first - (4.7 * realage)
            let answer = second * 1.375
            return answer
        }
    }

    
    var personalData = personalModel(
        weight: 300,
        heightFeet: 6,
        heightInches: 1,
        genderIsMale: true,
        age: 25,
        preferences: ["Seafood"],
        allergies: ["Egg"],
        spent: 0.0,
        budget: 250.0,
        
        //usages
        dailyCalorieUsage: 0.0,
        dailyProteinUsage: 0.0,
        dailyFatUsage: 0.0,
        dailyCarbsUsage: 0.0,
        dailySugarUsage: 0.0,
        dailyCholesterolUsage: 0.0,
        dailySodiumUsage: 0.0,
        dailyFiberUsage: 0.0,
        
        // limits
        dailyCalorieLimit: 0.0,
        dailyProteinLimit: 0.0,
        dailyFatLimit: 0.0,
        dailyCarbsLimit: 0.0,
        dailySugarLimit: 0.0,
        dailyCholesterolLimit: 0.0,
        dailySodiumLimit: 0.0,
        dailyFiberLimit: 0.0
    )
    
    // may not even need this we will see
    override func viewWillAppear(_ animated: Bool) {
        if !API_ENABLED {
            // hardcoded for disabled API testing
            recommendations.add(recommendationCell(
                                    title: "DASANI® Bottled Water",
                                    restaurant: "Chick-Fil-A",
                                    breakfast: false,
                                    cuisines: ["American", "Fast Food"],
                                    allergies: [],
                                    calories: 0.0,
                                    protein: 0.0,
                                    carbs: 0.0,
                                    sugar: 0.0,
                                    cholesterol: 0.0,
                                    sodium: 0.0,
                                    fiber: 0.0,
                                    fat: 0.0,
                                    transFat: 0.0,
                                    saturatedFat: 0.0,
                                    image: "https://www.cfacdn.com/img/order/menu/Mobile/Beverages/Menu%20Item/Edited_400x280/DasaniBottledWater_mobile.png",
                                    price: 2.09)
            )
            self.recommendationsTableView.delegate = self
            self.recommendationsTableView.dataSource = self
        }
        else{
            DispatchQueue.main.async {
                self.getRecommendations()
                self.recommendationsTableView.delegate = self
                self.recommendationsTableView.dataSource = self
            }
        }
    }
    
    func updateRecommendations() {
        if !API_ENABLED {
            // hardcoded for disabled API testing
            recommendations.add(recommendationCell(
                                    title: "DASANI® Bottled Water",
                                    restaurant: "Chick-Fil-A",
                                    breakfast: false,
                                    cuisines: ["American", "Fast Food"],
                                    allergies: [],
                                    calories: 0.0,
                                    protein: 0.0,
                                    carbs: 0.0,
                                    sugar: 0.0,
                                    cholesterol: 0.0,
                                    sodium: 0.0,
                                    fiber: 0.0,
                                    fat: 0.0,
                                    transFat: 0.0,
                                    saturatedFat: 0.0,
                                    image: "https://www.cfacdn.com/img/order/menu/Mobile/Beverages/Menu%20Item/Edited_400x280/DasaniBottledWater_mobile.png",
                                    price: 2.09)
            )
        }
        else{
            self.recommendations = [] // clear old recommendations
            self.getRecommendations() // get new ones
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        self.recommendationsTableView.delegate = self
        self.recommendationsTableView.dataSource = self
        
        // setup personal model
        self.personalData.preferences = cuisines as! Array<String>
        self.personalData.allergies = allergies as! Array<String>
        self.personalData.budget = budget
        
        
        self.personalData.dailyCalorieLimit = CalorieLimit(gender: self.personalData.genderIsMale,weight: self.personalData.weight,inches: ((self.personalData.heightFeet * 12)+self.personalData.heightInches),age:self.personalData.age)
        
        self.personalData.dailyProteinLimit = 0.36 * Double(self.personalData.weight)
        self.personalData.dailyFatLimit = 0.025 * self.personalData.dailyCalorieLimit
        self.personalData.dailyCarbsLimit = self.personalData.dailyCalorieLimit / 8
        
        if(self.personalData.genderIsMale){
            self.personalData.dailySugarLimit = 38.0
        }
        else{
            self.personalData.dailySugarLimit = 25.0
        }
        
        self.personalData.dailyCholesterolLimit = 300.0
        self.personalData.dailySodiumLimit = 2300
        self.personalData.dailyFiberLimit = 0.0125 * self.personalData.dailyCalorieLimit
        
        // fill in labels for dashboard
        self.spentLabel.text = String(format: "$%.02f", self.personalData.spent)
        self.maxBudgetLabel.text = String(format: "$%.02f", self.personalData.budget)
        self.dailyCalorieUsageLabel.text = String(format: "%d", self.personalData.dailyCalorieUsage)
        self.dailyCaloriePercentageLabel.text = String(format: "%.01f", (Double(self.personalData.dailyCalorieUsage)/Double(self.personalData.dailyCalorieLimit))*100.0)+"%"
        
        // START: create circular progress bar
        let point = CGPoint(x: 210.0, y: 250.0) // hard coded coords
        
        // bottom track
        let trackLayer = CAShapeLayer()

        let circularPath = UIBezierPath(arcCenter: point, radius: 100, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.lineCap = CAShapeLayerLineCap.round
        
        view.layer.addSublayer(trackLayer)
        
        // full circle - 0 to 2*pi start at (3/2)*pi (bottom)
        
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.strokeColor = UIColor.systemTeal.cgColor
        shapeLayer.lineWidth = 10
        
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
        
        populateGraph() // fill in graph stroke
        
        // END OF CIRCLE STUFF
    }
    
    // update usage on circle progress bar
    @objc func populateGraph(){
        // handle tap
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        print("circle stroke percentage")
        print(personalData.spent/personalData.budget)
        
        basicAnimation.toValue = (personalData.spent/personalData.budget) // get percentage of calorie usage
        
        basicAnimation.duration = 2
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "placeholder")
    }
    
    // call api for recommendations
    func getRecommendations(){
        /*
         GURMAN HERE: adjust budget (per meal), calories (per meal), check if breakfast time
         */
        let json: [String: Any] = [
            "preferences": personalData.preferences,
            "allergies": personalData.allergies,
            "budget": personalData.budget-personalData.spent,
            "nutrition": [
                "calories": (personalData.dailyCalorieLimit-personalData.dailyCalorieUsage) // leftover calories
            ],
            "breakfast": false // add a func to check local time
            // if between 6am-10:30am breakfast
        ]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        var request = URLRequest(url: URL(string: BASE_API_URL+REC_API_PATH)!)
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
                            self.recommendations.add(recommendationCell(
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
                            self.recommendations.add(recommendationCell(
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
                        self.recommendationsTableView.reloadData()
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

// handle all search bar interactions
extension DashboardViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        // we would request search API with searchText content here
        // reload TableView data for search as well - probably new VC for TV
        print(searchText)
    }
}

// handle recommendation TableView
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendations.count
    }
    
    // fill in cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = recommendationsTableView.dequeueReusableCell(withIdentifier: "recCell", for: indexPath) as! RecommendationTableViewCell
        
        let recommendation = recommendations[indexPath.row]
        
        cell.recLabel.text = (recommendation as! recommendationCell).title
        
        /*
         Lets get spicy and use the image url provided in the api document
         */
        
        if (recommendation as! recommendationCell).image == "null" {
            cell.recImageView.image = UIImage(named: "dine")
        }
        else{
            func setImage(from url: String) {
                guard let imageURL = URL(string: url) else { return }

                DispatchQueue.global().async {
                    guard let imageData = try? Data(contentsOf: imageURL) else { return }

                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        cell.recImageView.image = image
                    }
                }
            }
            setImage(from: (recommendation as! recommendationCell).image)
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
            print(recommendationsTableView.indexPathForSelectedRow!.row)
            let recommendation = recommendations[recommendationsTableView.indexPathForSelectedRow!.row]
            
            dvc.itemTitle = (recommendation as! recommendationCell).title
            dvc.itemImage = (recommendation as! recommendationCell).image
            dvc.restaurant = (recommendation as! recommendationCell).restaurant
            dvc.breakfast = (recommendation as! recommendationCell).breakfast
            dvc.cuisines = (recommendation as! recommendationCell).cuisines
            dvc.allergies = (recommendation as! recommendationCell).allergies
            dvc.calories = (recommendation as! recommendationCell).calories
            dvc.protein = (recommendation as! recommendationCell).protein
            dvc.carbs = (recommendation as! recommendationCell).carbs
            dvc.sugar = (recommendation as! recommendationCell).sugar
            dvc.cholesterol = (recommendation as! recommendationCell).cholesterol
            dvc.sodium = (recommendation as! recommendationCell).sodium
            dvc.fiber = (recommendation as! recommendationCell).fiber
            dvc.fat = (recommendation as! recommendationCell).fat
            dvc.transFat = (recommendation as! recommendationCell).transFat
            dvc.saturatedFat = (recommendation as! recommendationCell).saturatedFat
            dvc.price = (recommendation as! recommendationCell).price
            
            // deselect that cell
            recommendationsTableView.deselectRow(at: recommendationsTableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
}

/*
 GURMAN HERE: add daily values to struct def
 */
struct personalModel {
    // ideally use healthkit
    var weight: Int
    var heightFeet: Int
    var heightInches: Int
    var genderIsMale: Bool
    var age: Int
    
    var preferences: Array<String> // cuisines
    var allergies: Array<String> // allergy list
    var spent: Double // money spent for the week
    var budget: Double // max weekly budget
    
    //Usages
    var dailyCalorieUsage: Double // calories used that day
    var dailyProteinUsage: Double // 0.36 grams of protein per pound of body weight
    var dailyFatUsage: Double // 0.5 grams per pound of body weight
    var dailyCarbsUsage: Double
    var dailySugarUsage: Double
    var dailyCholesterolUsage: Double
    var dailySodiumUsage: Double
    var dailyFiberUsage: Double
    
    // add nutrition calculation here
    var dailyCalorieLimit: Double // calories used that day
    var dailyProteinLimit: Double // 0.36 grams of protein per pound of body weight
    var dailyFatLimit: Double // 0.5 grams per pound of body weight
    var dailyCarbsLimit: Double
    var dailySugarLimit: Double
    var dailyCholesterolLimit: Double
    var dailySodiumLimit: Double
    var dailyFiberLimit: Double
    
}

// For No API Testing
var API_ENABLED = true


let BASE_API_URL = "http://127.0.0.1:5000/api/v1/foods/"

let REC_API_PATH = "recommendations"
let SEARCH_API_PATH = "search"


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
