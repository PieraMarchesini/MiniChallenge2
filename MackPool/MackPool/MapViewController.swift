//
//  MapViewController.swift
//  MackPool
//
//  Created by Brendoon Ryos on 01/05/17.
//  Copyright © 2017 Brendoon Ryos. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire

enum ModeOfTravel {
    case driving
    case walking
    case bicycling
    case transit
}

enum JSONError: String, Error {
    case NoData = "ERROR: no data"
    case ConversionFailed = "ERROR: conversion from JSON failed"
}

class MapViewController: UITableViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var googleMaps: GMSMapView!
    
    var locationManager = CLLocationManager()
    
    var polyline: GMSPolyline = GMSPolyline()
    
    let firebase = FirebaseController.instance
    var groups: [Group]!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    let defaults = UserDefaults.standard
    
    var markerLocations = [(modeOfTravel: "Mackenzie",horario: "Grupo ID",iconName: "Mack" ,latitude: -23.547333693803449,longitude: -46.652063392102718)]
    
    var placeCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        //Your map initiation code
        // Mackenzie
        let camera = GMSCameraPosition.camera(withLatitude: -23.548127289245073, longitude: -46.65037963539362, zoom: 15.0)
        
        self.googleMaps.camera = camera
        self.googleMaps.delegate = self
        self.googleMaps.settings.myLocationButton = true
        self.googleMaps.settings.compassButton = true
        self.googleMaps.settings.zoomGestures = true
        self.googleMaps.isBuildingsEnabled = true
        self.googleMaps.isTrafficEnabled = false
        self.googleMaps.isMyLocationEnabled = true
        
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
        
        searchController?.searchBar.barTintColor = UIColor(hex: "990011")
        searchController?.searchBar.placeholder = "Buscar"
        searchController?.searchBar.sizeToFit()
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        
    }
    
    // MARK: function for create a marker pin on map
    func createMarker(titleMarker: String, subTitleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees, groupId: String) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.snippet = subTitleMarker
        marker.icon = iconMarker
        marker.id = groupId
        marker.map = googleMaps
    }
    
    //MARK: - Location Manager delegates
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get location : \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        
        //let locationMackenzie = CLLocation(latitude: -23.548132206940085, longitude: -46.650346107780933)
        //fillWithMarkers(markerLocations: markerLocations)
        
        //drawPath(startLocation: CLLocation(latitude: -23.548132206940085, longitude: -46.650346107780933), endLocation: CLLocation(latitude: -23.546713751661457, longitude: -46.652353405952454))
        
        self.googleMaps?.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
        
        
    }
    
    // MARK: - GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        googleMaps.isMyLocationEnabled = true
        //fillWithMarkers(markerLocations: groups)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        googleMaps.isMyLocationEnabled = true
        //fillWithMarkers(markerLocations: groups)
        if (gesture) {
            mapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        googleMaps.isMyLocationEnabled = true
        //fillWithMarkers(markerLocations: groups)
    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        googleMaps.isMyLocationEnabled = true
        //drawPath(startLocation: googleMaps.myLocation!, endLocation: CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude), modeOfTravel: "walking")
        //performSegue(withIdentifier: "filtro", sender: marker)
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        googleMaps.isMyLocationEnabled = true
        //performSegue(withIdentifier: "toJoin", sender: self)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        googleMaps.isMyLocationEnabled = true
        print("COORDINATE \(coordinate)") // when you tapped coordinate
        //createMarker(titleMarker: "\(coordinate)", subTitleMarker: "Subtitle", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: coordinate.latitude, longitude: coordinate.longitude)
    }

    func mapViewDidStartTileRendering(_ mapView: GMSMapView) {
        googleMaps.isMyLocationEnabled = true
        //fillWithMarkers(markerLocations: groups)
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        googleMaps.isMyLocationEnabled = true
        googleMaps.selectedMarker = nil
        return false
    }
    
    func fillWithMarkers (markerLocations: [Group]) {
        googleMaps.clear()
        for index in markerLocations {
            
            switch index.meioTransporte.rawValue {
            case 0:
                createMarker(titleMarker: "Carro", subTitleMarker: "Horário: \(index.horario)", iconMarker: UIImage(named: "car")!, latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude, groupId: index.id)
            case 1:
                createMarker(titleMarker: "Pedestre", subTitleMarker: "Horário: \(index.horario)", iconMarker: UIImage(named: "walk")!, latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude, groupId: index.id)
            case 2:
                createMarker(titleMarker: "Bicicleta", subTitleMarker: "Horário: \(index.horario)", iconMarker: UIImage(named: "bike")!, latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude, groupId: index.id)
            case 3:
                createMarker(titleMarker: "Transporte Publico", subTitleMarker: "Horário: \(index.horario)", iconMarker: UIImage(named: "transit")!, latitude: index.local.coordinate.latitude, longitude: index.local.coordinate.longitude, groupId: index.id)
            default:
                print("Error")
            }
            
            
        }
    }
    
    func cLLocationToFormattedAddress(location: CLLocation, label: UILabel) {
        
        let urlString = "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=\(markerLocations[0].latitude),\(markerLocations[0].longitude)&destinations=\(location.coordinate.latitude),\(location.coordinate.longitude)"
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                    throw JSONError.ConversionFailed
                }
                print(json)
                
                if let array = json["destination_addresses"] as? NSArray {
                    if let address = array[0] as? String {
                        DispatchQueue.main.async {
                            print("Destination Address: \(address)")
                            label.text = address
                        }
                    }
                }
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            
        })
        
        task.resume()
        
    }

    
    //MARK: - this is function for create direction path, from start location to desination location
    
    func drawPath(startLocation: CLLocation, endLocation: CLLocation, modeOfTravel: String) {
        
        self.polyline.map = nil
        
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=\(modeOfTravel)"
        
        Alamofire.request(url).responseJSON { response in
            
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization
            
            let json = JSON(data: response.data!)
            let routes = json["routes"].arrayValue
            
            // print route using Polyline
            for route in routes {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                self.polyline = GMSPolyline.init(path: path)
                self.polyline.strokeWidth = 4
                self.polyline.strokeColor = UIColor.red
                self.polyline.map = self.googleMaps
                
            }
            
            
        }
    }
    
    func showDistanceAndDuration(startLocation: CLLocation, endLocation: CLLocation, modeOfTravel: String) {

        let urlString = "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)&destinations=\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)&mode=\(modeOfTravel)"
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                    throw JSONError.ConversionFailed
                }
                print(json)
                
                if let array = json["rows"] as? NSArray {
                    if let rows = array[0] as? NSDictionary{
                        if let array2 = rows["elements"] as? NSArray{
                            if let elements = array2[0] as? NSDictionary{
                                if let duration = elements["duration"] as? NSDictionary {
                                    if let text = duration["text"] as? String{
                                        DispatchQueue.main.async {
                                            print("Duration: \(text)")
                                        }
                                    }
                                }
                                if let duration = elements["distance"] as? NSDictionary {
                                    if let text = duration["text"] as? String{
                                        DispatchQueue.main.async {
                                            print("Distance: \(text)")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            
        })
        task.resume()
    }
    
}

// Handle the user's selection.
extension MapViewController: GMSAutocompleteResultsViewControllerDelegate {
    
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
        placeCoordinate = place.coordinate
        //locationEnd = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        //createMarker(titleMarker: "Location End", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        // }
        
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0)
        
        //let locationMackenzie = CLLocation(latitude: -23.548132206940085, longitude: -46.650346107780933)
        //fillWithMarkers(markerLocations: markerLocations)
        
        //drawPath(startLocation: CLLocation(latitude: -23.548132206940085, longitude: -46.650346107780933), endLocation: CLLocation(latitude: -23.546713751661457, longitude: -46.652353405952454))
        
        self.googleMaps?.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
        //self.drawPath(startLocation: googleMaps.myLocation!, endLocation: locationEnd, modeOfTravel: "\(ModeOfTravel.walking)")
        //self.showDistanceAndDuration(startLocation: googleMaps.myLocation!, endLocation: locationEnd, modeOfTravel: "\(ModeOfTravel.walking)")
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



