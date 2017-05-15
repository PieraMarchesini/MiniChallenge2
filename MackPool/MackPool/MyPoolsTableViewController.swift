//
//  MyPoolsTableViewController.swift
//  MackPool
//
//  Created by Piera Marchesini on 04/05/17.
//  Copyright © 2017 Piera Marchesini. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire

class MyPoolsTableViewController: UITableViewController {
    
    /*var mackLocations = [(titleMarker: "Mackenzie",subTitle: "Grupo ID",iconMarker: #imageLiteral(resourceName: "Mack") ,latitude: -23.547333693803449,longitude: -46.652063392102718),(titleMarker: "Carro",subTitle: "Grupo 1",iconMarker: #imageLiteral(resourceName: "car") ,latitude: -23.546291439376215, longitude: -46.651166863739491),(titleMarker: "Bike",subTitle: "Grupo 2",iconMarker: #imageLiteral(resourceName: "bike") ,latitude: -23.546486305621073, longitude: -46.652858331799507),(titleMarker: "Pedestre",subTitle: "Grupo 3",iconMarker: #imageLiteral(resourceName: "walk"),latitude: -23.548041229552691, longitude: -46.65295522660017), (titleMarker: "Transporte Público",subTitle: "Grupo 4",iconMarker: #imageLiteral(resourceName: "transit"),latitude: -23.548174929407701, longitude: -46.650337055325508)]*/
    
    let firebase = FirebaseController.instance
    var groups: [Group] = []
    
    override func viewWillAppear(_ animated: Bool) {
        self.groups = firebase.getGroups(forUserWithId: firebase.getCurrentUserId())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Prevent the navigation bar from being hidden when searching.
        //searchController?.hidesNavigationBarDuringPresentation = false
        //self.clearsSelectionOnViewWillAppear = true
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem
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
        MapViewController().cLLocationToFormattedAddress(location: group.local, label: cell.endereco)
        //cell.endereco.text = "NEEDS IMPLEMENTING"
        cell.horario.text = "\(group.horario)"
        if group.toMack {
            cell.toOrFrom.text = "Ponto de encontro para o Mackenzie"
        } else {
            cell.toOrFrom.text = "Mackenzie para o Ponto de encontro"
        }
        
        return cell
        
    }
    
    //override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        performSegue(withIdentifier: "detail", sender: self)
    //}
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            firebase.deleteGroup(withId: groups[indexPath.row].id)
            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
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
