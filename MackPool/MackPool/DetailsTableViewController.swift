//
//  DetailsTableViewController.swift
//  MackPool
//
//  Created by Julio Brazil on 06/05/17.
//  Copyright © 2017 Piera Marchesini. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class DetailsTableViewController: MapViewController {

    //let firebase = FirebaseController.instance
    
    @IBOutlet weak var horario: UILabel!
    @IBOutlet weak var local: UILabel!
    @IBOutlet weak var numeroIntegrantes: UILabel!
    @IBOutlet weak var meioTransporte: UILabel!
    
    var iconMarker: UIImage!
    var modeOfTravel: String!
    
    var group = Group()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let users = firebase.getUsers(forGroupWithId: group.id).count
        self.horario.text = "\(group.horario)"
        cLLocationToFormattedAddress(location: group.local, label: local)
        self.numeroIntegrantes.text = "\(users)/\(group.maxUsuarios)"
        
        switch group.meioTransporte {
        case .bicicleta:
            self.meioTransporte.text = "Bicicleta"
            iconMarker = #imageLiteral(resourceName: "bike")
            modeOfTravel = "bicycling"
        case .carro:
            self.meioTransporte.text = "Carro"
            iconMarker = #imageLiteral(resourceName: "car")
            modeOfTravel = "driving"
        case .pedestre:
            self.meioTransporte.text = "Andando"
            iconMarker = #imageLiteral(resourceName: "walk")
            modeOfTravel = "walking"
        case .transportePublico:
            self.meioTransporte.text = "Transporte Público"
            iconMarker = #imageLiteral(resourceName: "transit")
            modeOfTravel = "transit"
        }
    }
    
    override func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locationMackenzie = CLLocation(latitude: -23.547333693803449,longitude: -46.652063392102718)
        createMarker(titleMarker: "Mackenzie", subTitleMarker: "", iconMarker: #imageLiteral(resourceName: "Mack"), latitude: locationMackenzie.coordinate.latitude, longitude: locationMackenzie.coordinate.longitude, groupId: "")
        createMarker(titleMarker: "", subTitleMarker: "", iconMarker: iconMarker, latitude: group.local.coordinate.latitude, longitude: group.local.coordinate.longitude, groupId: group.id)
        
        drawPath(startLocation: locationMackenzie, endLocation: group.local, modeOfTravel: modeOfTravel)
        
        let bounds = GMSCoordinateBounds(coordinate: locationMackenzie.coordinate, coordinate: group.local.coordinate)
        let camera = self.googleMaps.camera(for: bounds, insets: UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30))!
        
        self.googleMaps?.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*
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
