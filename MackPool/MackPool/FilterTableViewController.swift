//
//  FilterTableViewController.swift
//  MackPool
//
//  Created by Brendoon Ryos on 07/05/17.
//  Copyright © 2017 Piera Marchesini. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {
    @IBOutlet weak var car: UISwitch!
    @IBOutlet weak var transit: UISwitch!
    @IBOutlet weak var walk: UISwitch!
    @IBOutlet weak var bike: UISwitch!
    @IBOutlet weak var goToMackenzie: UISwitch!
    @IBOutlet weak var backFromMackenzie: UISwitch!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        car.isOn =  UserDefaults.standard.bool(forKey: "carState")
        transit.isOn =  UserDefaults.standard.bool(forKey: "transitState")
        walk.isOn =  UserDefaults.standard.bool(forKey: "walkState")
        bike.isOn =  UserDefaults.standard.bool(forKey: "bikeState")
        goToMackenzie.isOn =  UserDefaults.standard.bool(forKey: "goToMackenzieState")
        backFromMackenzie.isOn =  UserDefaults.standard.bool(forKey: "backFromMackenzieState")
    
    }
    
    @IBAction func carValueChanged(_ sender: Any) {
        if car.isOn {
            UserDefaults.standard.set(true, forKey: "carState")
        }
        if car.isOn == false {
            UserDefaults.standard.set(false, forKey: "carState")
        }
    }
    
    @IBAction func transitValueChanged(_ sender: Any) {
        if transit.isOn {
            UserDefaults.standard.set(true, forKey: "transitState") 
        }
        if transit.isOn == false {
            UserDefaults.standard.set(false, forKey: "transitState")
        }
    }
    
    @IBAction func walkValueChanged(_ sender: Any) {
        if walk.isOn {
            UserDefaults.standard.set(true, forKey: "walkState")
        }
        if walk.isOn == false {
            UserDefaults.standard.set(false, forKey: "walkState")
        }
    }
    
    @IBAction func bikeValueChanged(_ sender: Any) {
        if bike.isOn {
            UserDefaults.standard.set(true, forKey: "bikeState")
        }
        if bike.isOn == false {
            UserDefaults.standard.set(false, forKey: "bikeState")
        }
    }
    
    @IBAction func goToMackenzieValueChanged(_ sender: Any) {
        if goToMackenzie.isOn {
            UserDefaults.standard.set(true, forKey: "goToMackenzieState")
        }
        if goToMackenzie.isOn == false {
            UserDefaults.standard.set(false, forKey: "goToMackenzieState")
        }
    }
    
    @IBAction func backFromMackenzieValueChanged(_ sender: Any) {
        if backFromMackenzie.isOn {
            UserDefaults.standard.set(true, forKey: "backFromMackenzieState")
        }
        if backFromMackenzie.isOn == false {
            UserDefaults.standard.set(false, forKey: "backFromMackenzieState")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
