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

class HomeTableViewController: MapViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groups = firebase.getGroups()
        
        //Your map initiation code - Mackenzie
        let camera = GMSCameraPosition.camera(withLatitude: -23.548127289245073, longitude: -46.65037963539362, zoom: 15.0)
        
        self.googleMaps.camera = camera
        self.googleMaps.delegate = self
        self.googleMaps.settings.myLocationButton = true
        self.googleMaps.settings.compassButton = true
        self.googleMaps.settings.zoomGestures = true
        self.googleMaps.isBuildingsEnabled = true
        self.googleMaps.isTrafficEnabled = false
        self.googleMaps.isMyLocationEnabled = true
        
        // Put the search bar in the navigation bar.
        
        navigationItem.titleView = searchController?.searchBar
        
        fillWithMarkers(markerLocations: groups)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toJoin" {
            
            let marker =  sender as! GMSMarker?
            
            if let destination = segue.destination as? JoinTableViewController {
                for index in groups {
                    if index.id == marker?.id {
                        destination.group = index
                    }
                }
            }
        }
    }
    
    
    override func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("DID TAP INFO WINDOW OF: \(marker.title)")
        performSegue(withIdentifier: "toJoin", sender: marker)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller
    }*/

    
    /*override func fillWithMarkers(markerLocations: [Group]) {
        /*for index in groups {
            
            let carState: Bool = defaults.value(forKey: "carState")  as! Bool
            let transitState: Bool = defaults.value(forKey: "transitState")  as! Bool
            let walkState: Bool = defaults.value(forKey: "walkState")  as! Bool
            let bikeState: Bool = defaults.value(forKey: "bikeState")  as! Bool
            let goToMackenzieState: Bool = defaults.value(forKey: "goToMackenzieState")  as! Bool
            let backFromMackenzieState: Bool = defaults.value(forKey: "backFromMackenzieState")  as! Bool
            
            var modeOfTravel: String!
            var iconName: String!
            
            switch index.meioTransporte.rawValue {
            case 0:
                modeOfTravel = "Carro"
                iconName = "car"
            case 1:
                modeOfTravel = "Pedestre"
                iconName = "walk"
            case 2:
                modeOfTravel = "Bicicleta"
                iconName = "bike"
            case 3:
                modeOfTravel = "Transporte Público"
                iconName = "transit"
            default:
                print("Error")
            }
            
            if carState == true && transitState == true && walkState == true && bikeState == true && goToMackenzieState == true && backFromMackenzieState == true {
                createMarker(titleMarker: modeOfTravel, subTitleMarker: index.horario, iconMarker: UIImage(named: iconName)!, latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude)
            } else if carState == true && transitState == false && walkState == false && bikeState == false && goToMackenzieState == true && backFromMackenzieState == true {
                if iconName == "car" {
                    createMarker(titleMarker: modeOfTravel, subTitleMarker: index.horario, iconMarker: UIImage(named: iconName)!, latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude)
                }
                
            } else if carState == false && transitState == true && walkState == false && bikeState == false && goToMackenzieState == true && backFromMackenzieState == true {
                if iconName == "transit" {
                    createMarker(titleMarker: modeOfTravel, subTitleMarker: index.horario, iconMarker: UIImage(named: iconName)!, latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude)
                }
            } else if carState == false && transitState == false && walkState == true && bikeState == false && goToMackenzieState == true && backFromMackenzieState == true {
                if iconName == "walk" {
                    createMarker(titleMarker: modeOfTravel, subTitleMarker: index.horario, iconMarker: UIImage(named: iconName)!, latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude)
                }
            } else if carState == false && transitState == false && walkState == false && bikeState == true && goToMackenzieState == true && backFromMackenzieState == true {
                if iconName == "bike" {
                    createMarker(titleMarker: modeOfTravel, subTitleMarker: index.horario, iconMarker: UIImage(named: iconName)!, latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude)
                }
            } else if carState == true && transitState == false && walkState == false && bikeState == false && goToMackenzieState == true && backFromMackenzieState == false {
                if iconName == "goToMackenzie" && iconName == "car" {
                    createMarker(titleMarker: modeOfTravel, subTitleMarker: index.horario, iconMarker: UIImage(named: iconName)!, latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude)
                }
            } else if carState == true && transitState == false && walkState == false && bikeState == false && goToMackenzieState == false && backFromMackenzieState == true {
                if iconName == "backFromMackenzie" && iconName == "car" {
                    createMarker(titleMarker: modeOfTravel, subTitleMarker: index.horario, iconMarker: UIImage(named: iconName)!, latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude)
                }
            } else if carState == false && transitState == false && walkState == false && bikeState == false && goToMackenzieState == false && backFromMackenzieState == false {
                
            } else {

                if carState == false {
                    if iconName != "car" {
                        createMarker(titleMarker: modeOfTravel, subTitleMarker: index.horario, iconMarker: UIImage(named: iconName)!, latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude)
                    }
                }
            
                if transitState == false {
                    if iconName != "transit" {
                        createMarker(titleMarker: modeOfTravel, subTitleMarker: index.horario, iconMarker: UIImage(named: iconName)!, latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude)
                    }
                }
            
                if walkState == false {
                    if iconName != "walk" {
                        createMarker(titleMarker: modeOfTravel, subTitleMarker: index.horario, iconMarker: UIImage(named: iconName)!, latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude)
                    }
                }
            
                if bikeState == false {
                    if iconName != "bike" {
                        createMarker(titleMarker: modeOfTravel, subTitleMarker: index.horario, iconMarker: UIImage(named: iconName)!, latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude)
                    }
                }
            
                if goToMackenzieState == false {
                    if modeOfTravel != "goToMackenzie" {
                        createMarker(titleMarker: modeOfTravel, subTitleMarker: index.horario, iconMarker: UIImage(named: iconName)!, latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude)
                    }
                }
            
                if backFromMackenzieState == false {
                    if modeOfTravel != "backFromMackenzie" {
                        createMarker(titleMarker: modeOfTravel, subTitleMarker: index.horario, iconMarker: UIImage(named: iconName)!, latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude)
                    }
                }
            }
        }*/
            
    }*/
}



