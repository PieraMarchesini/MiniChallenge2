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
    
    var carros =  [Group]()
    var pedestres =  [Group]()
    var bikes =  [Group]()
    var transit =  [Group]()
    
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
        
        splitGroups(groups: groups)
        
        fillWithMarkers()
        
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
        performSegue(withIdentifier: "toJoin", sender: marker)
    }
    
    func splitGroups(groups: [Group]) {
    
        for index in groups {
            if index.meioTransporte.rawValue == 0{
                carros.append(index)
            } else if index.meioTransporte.rawValue == 1 {
                pedestres.append(index)
            } else if index.meioTransporte.rawValue == 2 {
                bikes.append(index)
            } else if index.meioTransporte.rawValue == 3 {
                transit.append(index)
            }
        }
        
    }

    
    override func fillWithMarkers() {

        googleMaps.clear()
        
        let carState: Bool = defaults.value(forKey: "carState")  as! Bool
        let transitState: Bool = defaults.value(forKey: "transitState")  as! Bool
        let walkState: Bool = defaults.value(forKey: "walkState")  as! Bool
        let bikeState: Bool = defaults.value(forKey: "bikeState")  as! Bool
        let goToMackenzieState: Bool = defaults.value(forKey: "goToMackenzieState")  as! Bool
        let backFromMackenzieState: Bool = defaults.value(forKey: "backFromMackenzieState")  as! Bool
        
        
        switch goToMackenzieState{
        case true:
            if backFromMackenzieState == true {
                if carState == true {
                    for index in carros {
                        createMarker(titleMarker: "Carro", subTitleMarker: index.horario, iconMarker: #imageLiteral(resourceName: "car"), latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude, groupId: index.id)
                    }
                }
            
                if walkState == true {
                    for index in pedestres {
                        createMarker(titleMarker: "Pedestre", subTitleMarker: index.horario, iconMarker: #imageLiteral(resourceName: "walk"), latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude, groupId: index.id)
                    }
                }
            
                if bikeState == true {
                    for index in bikes {
                        createMarker(titleMarker: "Bicicleta", subTitleMarker: index.horario, iconMarker: #imageLiteral(resourceName: "bike"), latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude, groupId: index.id)
                    }
                }
            
                if transitState == true {
                    for index in transit {
                        createMarker(titleMarker: "Transporte Público", subTitleMarker: index.horario, iconMarker: #imageLiteral(resourceName: "transit"), latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude, groupId: index.id)
                    }
                }
            } else {
                if carState == true {
                    for index in carros {
                        if index.toMack == true {
                            createMarker(titleMarker: "Carro", subTitleMarker: index.horario, iconMarker: #imageLiteral(resourceName: "car"), latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude, groupId: index.id)
                        }
                    }
                }
                
                if walkState == true {
                    for index in pedestres {
                        if index.toMack == true {
                            createMarker(titleMarker: "Pedestre", subTitleMarker: index.horario, iconMarker: #imageLiteral(resourceName: "walk"), latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude, groupId: index.id)
                        }
                    }
                }
                
                if bikeState == true {
                    for index in bikes {
                        if index.toMack == true {
                            createMarker(titleMarker: "Bicicleta", subTitleMarker: index.horario, iconMarker: #imageLiteral(resourceName: "bike"), latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude, groupId: index.id)
                        }
                    }
                }
                
                if transitState == true {
                    for index in transit {
                        if index.toMack == true {
                            createMarker(titleMarker: "Transporte Público", subTitleMarker: index.horario, iconMarker: #imageLiteral(resourceName: "transit"), latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude, groupId: index.id)
                        }
                    }
                }
            }

        case false:
            if backFromMackenzieState == true {
                if carState == true {
                    for index in carros {
                        if index.toMack == false {
                            createMarker(titleMarker: "Carro", subTitleMarker: index.horario, iconMarker: #imageLiteral(resourceName: "car"), latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude, groupId: index.id)
                        }
                    }
                }
                
                if walkState == true {
                    for index in pedestres {
                        if index.toMack == false {
                            createMarker(titleMarker: "Pedestre", subTitleMarker: index.horario, iconMarker: #imageLiteral(resourceName: "walk"), latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude, groupId: index.id)
                        }
                    }
                }
                
                if bikeState == true {
                    for index in bikes {
                        if index.toMack == false {
                            createMarker(titleMarker: "Bicicleta", subTitleMarker: index.horario, iconMarker: #imageLiteral(resourceName: "bike"), latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude, groupId: index.id)
                        }
                    }
                }
                
                if transitState == true {
                    for index in transit {
                        if index.toMack == false {
                            createMarker(titleMarker: "Transporte Público", subTitleMarker: index.horario, iconMarker: #imageLiteral(resourceName: "transit"), latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude, groupId: index.id)
                        }
                    }
                }
            }
        }
    }
}



