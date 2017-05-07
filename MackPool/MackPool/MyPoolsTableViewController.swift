//
//  MyPoolsTableViewController.swift
//  MackPool
//
//  Created by Piera Marchesini on 04/05/17.
//  Copyright © 2017 Piera Marchesini. All rights reserved.
//

import UIKit

class MyPoolsTableViewController: UITableViewController{

    let firebase = FirebaseController.instance
    var groups: [Group] = []
    
    override func viewWillAppear(_ animated: Bool) {
        self.groups = firebase.getGroups(forUserWithId: firebase.getCurrentUserId())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! PoolTableViewCell
        
        let group = groups[indexPath.row]
        cell.endereco.text = "NEEDS IMPLEMENTING"
        cell.horario.text = "\(group.horario)"
        if group.toMack {
            cell.toOrFrom.text = "\(cell.endereco.text!) para o Mackenzie"
        } else {
            cell.toOrFrom.text = "Mackenzie para \(cell.endereco.text!)"
        }
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "detail", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            firebase.deleteGroup(withId: groups[indexPath.row].id)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            groups.remove(at: indexPath.row)
//        }   
//    }

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "detail" {
            if let destination = segue.destination as? DetailsTableViewController {
                destination.group = self.groups[(tableView.indexPathForSelectedRow?.row)!]
            }
        }
    }

}
