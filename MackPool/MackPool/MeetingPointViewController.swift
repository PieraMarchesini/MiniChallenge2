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
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groups = firebase.getGroups()
        
        setupSwitchButtons()
        setupResultsController()
        setupSearchController()
        
    }
    
    func setupSwitchButtons() {
        defaults.set(true, forKey: "carState")
        defaults.set(true, forKey: "transitState")
        defaults.set(true, forKey: "walkState")
        defaults.set(true, forKey: "bikeState")
        defaults.set(true, forKey: "goToMackenzieState")
        defaults.set(true, forKey: "backFromMackenzieState")
    }
    
    func setupResultsController() {
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        resultsViewController?.tableCellBackgroundColor = UIColor(hex: "990011")
        resultsViewController?.primaryTextColor = UIColor.gray
        resultsViewController?.primaryTextHighlightColor = UIColor.white
        resultsViewController?.secondaryTextColor = UIColor.white
    }
    
    func setupSearchController() {
        
        UISearchBar.appearance().setTextBackgroundColor(color: UIColor(hex: "6D0011"))
        UISearchBar.appearance().tintColor = UIColor.white
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Deixar a search bar branca e o ícone.
        let textFieldInsideSearchBar = searchController?.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = UIColor.white
        
        let clearButton = textFieldInsideSearchBar?.value(forKey: "clearButton") as! UIButton
        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton.tintColor = UIColor.white
        
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = UIColor.white
        // Put the search bar in the navigation bar.
        
        navigationItem.titleView = searchController?.searchBar
        
        
        // Put the search bar in the top of screen
        //let subView = UIView(frame: CGRect(x: 0, y: 0, width: 370.0, height: 45.0))
        
        searchController?.searchBar.barTintColor = UIColor(hex: "990011")
        searchController?.searchBar.placeholder = "Buscar"
        //subView.addSubview((searchController?.searchBar)!)
        //self.view.addSubview(subView)
        //searchController?.searchBar.sizeToFit()
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if segue.identifier == "toJoin" {
     if let destination = segue.destination as? JoinTableViewController {
     
     destination.group =
     }
     }
     }*/
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }*/
    
    
    override func fillWithMarkers(markerLocations: [Group]) {
        googleMaps.clear()
        for index in groups {
            
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
        }
        
    }
}


// Handle the user's selection.
extension MeetingPointViewController: GMSAutocompleteResultsViewControllerDelegate {
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        //print("Place name: \(place.name)")
        //print("Place address: \(place.formattedAddress)")
        //print("Place attributions: \(place.attributions)")
        // Change map location
        //let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 12.0)
        /*let vancouver = CLLocationCoordinate2D(latitude: 49.26, longitude: -123.11)
         let calgary = CLLocationCoordinate2D(latitude: 51.05,longitude: -114.05)
         let bounds = GMSCoordinateBounds(coordinate: vancouver, coordinate: calgary)
         let camera = mapView.camera(for: bounds, insets: UIEdgeInsets())!
         mapView.camera = camera
         */
        
        // set coordinate to text
        //if locationSelected == .startLocation {
        //startLocation.text = "\(place.coordinate.latitude), \(place.coordinate.longitude)"
        //startLocation.text = place.formattedAddress
        //locationStart = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        //createMarker(titleMarker: "Location Start", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        //} else {
        //destinationLocation.text = "\(place.coordinate.latitude), \(place.coordinate.longitude)"
        //destinationLocation?.textColor = UIColor.white
        searchController?.searchBar.text = place.formattedAddress
        locationEnd = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        //createMarker(titleMarker: "Location End", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        // }
        
        let bounds = GMSCoordinateBounds(coordinate: (googleMaps.myLocation?.coordinate)!, coordinate: locationEnd.coordinate)
        let camera = self.googleMaps.camera(for: bounds, insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))!
        
        self.googleMaps.camera = camera
        self.drawPath(startLocation: googleMaps.myLocation!, endLocation: locationEnd, modeOfTravel: "\(ModeOfTravel.walking)")
        createMarker(titleMarker: "Carro", subTitleMarker: "Horário", iconMarker: #imageLiteral(resourceName: "car"), latitude: locationEnd.coordinate.latitude, longitude: locationEnd.coordinate.longitude)
        self.showDistanceAndDuration(startLocation: googleMaps.myLocation!, endLocation: locationEnd, modeOfTravel: "\(ModeOfTravel.walking)")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
}



