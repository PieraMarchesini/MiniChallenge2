//
//  HomeViewController.swift
//  MackPool
//
//  Created by Piera Marchesini on 04/05/17.
//  Copyright © 2017 Piera Marchesini. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class MeetingPointViewController: MapViewController {
    
    var delegate: MeetingPointViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Put the search bar in the navigation bar.
        
        navigationItem.titleView = searchController?.searchBar
        navigationItem.hidesBackButton = true
    }
    
    
    @IBAction func doneButtonWasPressed(_ sender: Any) {
        delegate?.didReceiveAddressFromMeetingPointViewController(address: searchController?.searchBar.text, coordinate: placeCoordinate)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        googleMaps.clear()
        createMarker(titleMarker: "Endereço: ", subTitleMarker: "Meu Ponto de Encontro", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: coordinate.latitude, longitude: coordinate.longitude, groupId: "")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }*/
    

}
