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

enum Location {
    case startLocation
    case destinationLocation
}

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

class MapViewController: UIViewController , GMSMapViewDelegate ,  CLLocationManagerDelegate {
    
    
    @IBOutlet weak var googleMaps: GMSMapView!
    
    //@IBOutlet weak var startLocation: UITextField!
    //@IBOutlet weak var destinationLocation: UITextField?
    
    
    var locationManager = CLLocationManager()
    //var locationSelected = Location.destinationLocation
    
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    
    var polyline: GMSPolyline = GMSPolyline()
    
    var markerLocations = [(modeOfTravel: "Mackenzie",horario: "Grupo ID",iconName: "Mack" ,latitude: -23.547333693803449,longitude: -46.652063392102718),(modeOfTravel: "goToMackenzie",horario: "Grupo 1",iconName: "car" ,latitude: -23.546291439376215, longitude: -46.651166863739491),(modeOfTravel: "backFromMackenzie",horario: "Grupo 2",iconName: "bike" ,latitude: -23.546486305621073, longitude: -46.652858331799507),(modeOfTravel: "goToMackenzie",horario: "Grupo 3",iconName: "walk",latitude: -23.548041229552691, longitude: -46.65295522660017), (modeOfTravel: "backFromMackenzie",horario: "Grupo 4",iconName: "transit",latitude: -23.548174929407701, longitude: -46.650337055325508),(modeOfTravel: "goToMackenzie",horario: "Grupo 4",iconName: "car",latitude: -23.571799248721028, longitude: -46.65556937456131),(modeOfTravel: "backFromMackenzie",horario: "Grupo 4",iconName: "bike",latitude: -23.562555322108739, longitude: -46.672520935535431),(modeOfTravel: "goToMackenzie",horario: "Grupo 4",iconName: "walk",latitude: -23.54760631988842, longitude: -46.682176887989044),(modeOfTravel: "backFromMackenzie",horario: "Grupo 4",iconName: "transit",latitude: -23.539836101261127, longitude: -46.670160591602325),(modeOfTravel: "goToMackenzie",horario: "Grupo 4",iconName: "car",latitude: -23.561473543499769, longitude: -46.643874943256378),(modeOfTravel: "backFromMackenzie",horario: "Grupo 4",iconName: "bike",latitude: -23.539737741120668, longitude: -46.662757694721222),(modeOfTravel: "goToMackenzie",horario: "Grupo 4",iconName: "walk",latitude: -23.527442144355184, longitude: -46.65481835603714),(modeOfTravel: "backFromMackenzie",horario: "Grupo 4",iconName: "transit",latitude: -23.544262231443664, longitude: -46.629498302936554),(modeOfTravel: "goToMackenzie",horario: "Grupo 4",iconName: "car",latitude: -23.561276855522994, longitude: -46.637652218341827),(modeOfTravel: "backFromMackenzie",horario: "Grupo 4",iconName: "bike",latitude: -23.566193966603894, longitude: -46.649990379810333),(modeOfTravel: "goToMackenzie",horario: "Grupo 4",iconName: "walk",latitude: -23.566784007565513, longitude: -46.670160591602325),(modeOfTravel: "backFromMackenzie",horario: "Grupo 4",iconName: "transit",latitude: -23.519473984157308, longitude: -46.678314507007599),(modeOfTravel: "goToMackenzie",horario: "Grupo 4",iconName: "car",latitude: -23.523015448241424, longitude: -46.642802059650421),(modeOfTravel: "backFromMackenzie",horario: "Grupo 4",iconName: "bike",latitude: -23.555376079311237, longitude: -46.628961861133575), (modeOfTravel: "goToMackenzie",horario: "Grupo 4",iconName: "walk",latitude: -23.582222470515362, longitude: -46.655247509479523), (modeOfTravel: "backFromMackenzie",horario: "Grupo 4",iconName: "transit",latitude: -23.607490430236677, longitude: -46.634326279163361)]
    
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
        //self.googleMaps.isMyLocationEnabled = true
        
    }
    
    // MARK: function for create a marker pin on map
    func createMarker(titleMarker: String, subTitleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.snippet = subTitleMarker
        marker.icon = iconMarker
        marker.map = googleMaps
    }
    
    //MARK: - Location Manager delegates
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get location : \(error)")
    }
    
    
    /*private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
     if status == CLAuthorizationStatus.authorizedWhenInUse {
     googleMaps.isMyLocationEnabled = true
     }
     }*/
    
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
        fillWithMarkers(markerLocations: markerLocations)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        googleMaps.isMyLocationEnabled = true
        fillWithMarkers(markerLocations: markerLocations)
        if (gesture) {
            mapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        fillWithMarkers(markerLocations: markerLocations)
    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        googleMaps.isMyLocationEnabled = true
        //performSegue(withIdentifier: "filtro", sender: marker)
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("COORDINATE \(coordinate)") // when you tapped coordinate
        //createMarker(titleMarker: "\(coordinate)", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    func mapViewDidStartTileRendering(_ mapView: GMSMapView) {
        fillWithMarkers(markerLocations: markerLocations)
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        googleMaps.isMyLocationEnabled = true
        googleMaps.selectedMarker = nil
        return false
    }
    
    func fillWithMarkers (markerLocations: [(modeOfTravel: String,horario: String,iconName: String, latitude: Double, longitude: Double)]) {
        googleMaps.clear()
        for index in markerLocations {
            createMarker(titleMarker: index.modeOfTravel, subTitleMarker: index.horario, iconMarker: UIImage(named: index.iconName)!, latitude: index.latitude, longitude: index.longitude)
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
                        DispatchQueue.main.sync {
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
        
        //let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(startLocation.coordinate)&destination=\(endLocation.coordinate)&mode=\(modeOfTravel)"
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
    
    // MARK: when start location tap, this will open the search location
    /*@IBAction func openStartLocation(_ sender: UIButton) {
     
     let autoCompleteController = GMSAutocompleteViewController()
     autoCompleteController.delegate = self
     
     // selected location
     locationSelected = .startLocation
     
     // Change text color
     UISearchBar.appearance().setTextColor(color: UIColor.black)
     self.locationManager.stopUpdatingLocation()
     
     self.present(autoCompleteController, animated: true, completion: nil)
     }*/
    
    // MARK: when destination location tap, this will open the search location
    /*@IBAction func openDestinationLocation(_ sender: UIButton) {
     
     let autoCompleteController = GMSAutocompleteViewController()
     autoCompleteController.delegate = self
     
     // selected location
     locationSelected = .destinationLocation
     
     // Change text color
     UISearchBar.appearance().setTextColor(color: UIColor.black)
     self.locationManager.stopUpdatingLocation()
     
     self.present(autoCompleteController, animated: true, completion: nil)
     }*/
    
    
    /*// MARK: SHOW DIRECTION WITH BUTTON
     @IBAction func showDirection(_ sender: UIButton) {
     // when button direction tapped, must call drawpath func
     self.drawPath(startLocation: locationStart, endLocation: locationEnd, modeOfTravel: "\(ModeOfTravel.walking)")
     }*/
    
}

// MARK: - GMS Auto Complete Delegate, for autocomplete search location
/*extension MapViewController: GMSAutocompleteViewControllerDelegate {
 
 func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
 print("Error \(error)")
 }
 
 func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
 
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
 destinationLocation?.textColor = UIColor.white
 destinationLocation?.text = place.formattedAddress
 locationEnd = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
 //createMarker(titleMarker: "Location End", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
 // }
 
 let bounds = GMSCoordinateBounds(coordinate: (googleMaps.myLocation?.coordinate)!, coordinate: locationEnd.coordinate)
 let camera = self.googleMaps.camera(for: bounds, insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))!
 
 self.googleMaps.camera = camera
 self.dismiss(animated: true, completion: nil)
 self.drawPath(startLocation: googleMaps.myLocation!, endLocation: locationEnd, modeOfTravel: "\(ModeOfTravel.walking)")
 self.showDistanceAndDuration(startLocation: googleMaps.myLocation!, endLocation: locationEnd, modeOfTravel: "\(ModeOfTravel.walking)")
 }
 
 func wasCancelled(_ viewController: GMSAutocompleteViewController) {
 self.dismiss(animated: true, completion: nil)
 }
 
 func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
 UIApplication.shared.isNetworkActivityIndicatorVisible = true
 }
 
 func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
 UIApplication.shared.isNetworkActivityIndicatorVisible = false
 }
 
 }*/


