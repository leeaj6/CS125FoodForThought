//
//  UserSettingsViewController.swift
//  FoodForThought
//
//  Created by Alex Lee on 3/8/21.
//

import UIKit

class UserSettingsViewController: UIViewController {

    @IBOutlet weak var stepsWalked: UILabel!
    @IBOutlet weak var stepsGoalLabel: UILabel!
    @IBOutlet weak var updateStepsTextField: UITextField!
    
    let shapeLayer = CAShapeLayer() // circle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (presentingViewController as? DashboardViewController) != nil {
            let presenter = presentingViewController as? DashboardViewController
            stepsGoalLabel.text = String((presenter?.dailyStepsGoal)!)
            stepsWalked.text = String((presenter?.dailyStepsWalked)!)
        }
        
        // START: create circular progress bar
        let point = CGPoint(x: 210.0, y: 200.0) // hard coded coords
        
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
        let presenter = presentingViewController as! DashboardViewController
        
        // handle tap
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = (Double(presenter.dailyStepsWalked) / Double(presenter.dailyStepsGoal!))
        print(presenter.dailyStepsWalked)
        print(presenter.dailyStepsGoal!)
        print(Double(presenter.dailyStepsWalked) / Double(presenter.dailyStepsGoal!))
        
        basicAnimation.duration = 2
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "placeholder")
    }
    
    @IBAction func updateSteps(_ sender: Any) {
        let presenter = presentingViewController as? DashboardViewController
        presenter?.dailyStepsWalked = Int(updateStepsTextField.text!)!
        stepsWalked.text = String((presenter?.dailyStepsWalked)!)
        populateGraph()
    }
    

}
