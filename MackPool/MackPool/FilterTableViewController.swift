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
    
    /*@IBOutlet weak var switch1: UISwitch!
    let defaults = UserDefaults.standard
    var switchON : Bool = false
    @IBAction func checkState(_ sender: AnyObject) {
        
        if switch1.isOn{
            switchON = true
            defaults.set(switchON, forKey: "switchON")
        }
        if switch1.isOn == false{
            switchON = false
            defaults.set(switchON, forKey: "switchON")
        }
        
    }*/
    
    public static let sharedInstance = FilterTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        car.isOn =  UserDefaults.standard.bool(forKey: "carState")
        transit.isOn =  UserDefaults.standard.bool(forKey: "transitState")
        walk.isOn =  UserDefaults.standard.bool(forKey: "walkState")
        bike.isOn =  UserDefaults.standard.bool(forKey: "bikeState")
        goToMackenzie.isOn =  UserDefaults.standard.bool(forKey: "goToMackenzieState")
        backFromMackenzie.isOn =  UserDefaults.standard.bool(forKey: "backFromMackenzieState")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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

    // MARK: - Table view data source
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
