//
//  ViewController.swift
//  Maps Direction
//
//  Created by Brendoon Ryos on 01/05/17.
//  Copyright © 2017 Brendoon Ryos. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacesAPI
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

extension UIImage {
    
}

class MapsViewController: UIViewController , GMSMapViewDelegate ,  CLLocationManagerDelegate {
	
	@IBOutlet weak var googleMaps: GMSMapView!
	@IBOutlet weak var startLocation: UITextField!
	@IBOutlet weak var destinationLocation: UITextField!
	

	var locationManager = CLLocationManager()
	var locationSelected = Location.startLocation
	
	var locationStart = CLLocation()
	var locationEnd = CLLocation()
    
    var mackLocations = [(titleMarker: "P7",iconMarker: #imageLiteral(resourceName: "mapspin") ,latitude: -23.548132206940085,longitude: -46.650346107780933),
        (titleMarker: "993",iconMarker: #imageLiteral(resourceName: "mapspin") ,latitude: -23.548710342177227,longitude: -46.650698818266392),
        (titleMarker: "847",iconMarker: #imageLiteral(resourceName: "mapspin") ,latitude: -23.548474293647466,longitude: -46.650090627372265),
        (titleMarker: "40" ,iconMarker: #imageLiteral(resourceName: "mapspin") ,latitude: -23.548710342177227,longitude: -46.650698818266392),
        (titleMarker: "41" ,iconMarker: #imageLiteral(resourceName: "mapspin") ,latitude: -23.547980987734501,longitude: -46.650152318179607),
        (titleMarker: "117",iconMarker: #imageLiteral(resourceName: "mapspin") ,latitude: -23.547467087020504,longitude: -46.650041677057743),
        (titleMarker: "139",iconMarker: #imageLiteral(resourceName: "mapspin") ,latitude: -23.547242101147475,longitude: -46.650134883821011),
        (titleMarker: "38", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.547618921531438, longitude: -46.650799065828323),
        (titleMarker: "37", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.547641973314331, longitude: -46.650957986712456),
        (titleMarker: "33", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.54764074388601, longitude: -46.651112884283066),
        (titleMarker: "35", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.547803950394762, longitude: -46.650850027799606),
        (titleMarker: "34", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.547960087505416, longitude: -46.651267111301422),
        (titleMarker: "30", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.547567592880362, longitude: -46.651478335261345),
        (titleMarker: "31", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.547371191449567, longitude: -46.651437431573868),
        (titleMarker: "28", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.547333079087849, longitude: -46.65177907794714),
        (titleMarker: "29", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.547683159156364, longitude: -46.651785112917423),
        (titleMarker: "52", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.548007420372404, longitude: -46.652216278016567),
        (titleMarker: "25", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.547082582241945, longitude: -46.651707999408245),
        (titleMarker: "24", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.546879725550713, longitude: -46.651528961956501),
        (titleMarker: "20", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.546982383369937, longitude: -46.65201410651207),
        (titleMarker: "23", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.546695924823862, longitude: -46.651369035243988),
        (titleMarker: "6", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.546503517767622, longitude: -46.65158998221159),
        (titleMarker: "5", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.54625732238566, longitude: -46.651348583400249),
        (titleMarker: "P3", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.546236421882575, longitude: -46.651145070791245),
        (titleMarker: "4", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.54615128303417, longitude: -46.651620827615261),
        (titleMarker: "3", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.546076901756873, longitude: -46.65182501077652),
        (titleMarker: "7", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.546462638915898, longitude: -46.651768684387207),
        (titleMarker: "10", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.546584660713851, longitude: -46.652035228908062),
        (titleMarker: "2", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.545965944484017, longitude: -46.651996001601219),
        (titleMarker: "1", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.545826095156315, longitude: -46.652149558067322),
        (titleMarker: "P4", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.545730198388494, longitude: -46.652379892766476),
        (titleMarker: "9", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.546334469802144, longitude: -46.65237620472908),
        (titleMarker: "11", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.546501366249426, longitude: -46.652644090354443),
        (titleMarker: "19", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.546713751661457, longitude: -46.652353405952454),
        (titleMarker: "12", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.546485383541732, longitude: -46.652865707874298),
        (titleMarker: "P2", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.54656314554359, longitude: -46.652948185801506),
        (titleMarker: "P1", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.546888638957363, longitude: -46.653342470526695),
        (titleMarker: "13", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.546637219186394, longitude: -46.652951203286648),
        (titleMarker: "14", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.546715595816934, longitude: -46.652874425053596),
        (titleMarker: "15", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.546763851209366, longitude: -46.652759090065956),
        (titleMarker: "16", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.546793050323565, longitude: -46.652709469199181),
        (titleMarker: "17", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.546837924739084, longitude: -46.652651466429234),
        (titleMarker: "18", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.54687511516774, longitude: -46.652949526906013),
        (titleMarker: "50", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.548328299878538, longitude: -46.652070432901382),
        (titleMarker: "49", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.548344897073058, longitude: -46.652495227754116),
        (titleMarker: "48", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.548079956421237, longitude: -46.652584075927734),
        (titleMarker: "P6", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.547996355547884, longitude: -46.652934104204178),
        (titleMarker: "46", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.547654574953931, longitude: -46.652915328741074),
        (titleMarker: "P5", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.547468316450445, longitude: -46.653196290135384),
        (titleMarker: "43", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.547026335645278, longitude: -46.653394103050232),
        (titleMarker: "44", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.547183703112022, longitude: -46.653267368674278),
        (titleMarker: "181", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.547732643621142, longitude: -46.653294190764427),
        (titleMarker: "143", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.548016026346406, longitude: -46.653193607926369),
        (titleMarker: "85", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: -23.548535764659576, longitude: -46.652855984866619)]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.startMonitoringSignificantLocationChanges()
		
		//Your map initiation code
        // Mackenzie
		let camera = GMSCameraPosition.camera(withLatitude: -23.548127289245073, longitude: -46.65037963539362, zoom: 10.0)
		
		self.googleMaps.camera = camera
		self.googleMaps.delegate = self
		self.googleMaps.settings.myLocationButton = true
		self.googleMaps.settings.compassButton = true
		self.googleMaps.settings.zoomGestures = true
        self.googleMaps.isBuildingsEnabled = true
        self.googleMaps.isTrafficEnabled = false
        self.googleMaps.isMyLocationEnabled = true
        
	}
	
	// MARK: function for create a marker pin on map
	func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
		let marker = GMSMarker()
		marker.position = CLLocationCoordinate2DMake(latitude, longitude)
		marker.title = titleMarker
		marker.icon = iconMarker
		marker.map = googleMaps
	}
	
	//MARK: - Location Manager delegates
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Error to get location : \(error)")
	}
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            googleMaps.isMyLocationEnabled = true
        }
    }
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
		let location = locations.last
		let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
		
		//let locationMackenzie = CLLocation(latitude: -23.548132206940085, longitude: -46.650346107780933)
		
        for index in mackLocations {
            createMarker(titleMarker: index.titleMarker, iconMarker: index.iconMarker, latitude: index.latitude, longitude: index.longitude)
        }
        
        //drawPath(startLocation: CLLocation(latitude: -23.548132206940085, longitude: -46.650346107780933), endLocation: CLLocation(latitude: -23.546713751661457, longitude: -46.652353405952454))
		
		self.googleMaps?.animate(to: camera)
		self.locationManager.stopUpdatingLocation()
		
	}
	
	// MARK: - GMSMapViewDelegate
	
	func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
		
	}
	
	func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
		
		if (gesture) {
			mapView.selectedMarker = nil
		}
	}
    
	
	func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        drawPath(startLocation: googleMaps.myLocation!, endLocation: CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude))
		return true
	}
	
	func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
		print("COORDINATE \(coordinate)") // when you tapped coordinate
        //createMarker(titleMarker: "\(coordinate)", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: coordinate.latitude, longitude: coordinate.longitude)
	}
	
	func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
		googleMaps.selectedMarker = nil
		return true
	}
	
	

	//MARK: - this is function for create direction path, from start location to desination location
	
	func drawPath(startLocation: CLLocation, endLocation: CLLocation) {
        
        googleMaps.clear()
        for index in mackLocations {
            createMarker(titleMarker: index.titleMarker, iconMarker: index.iconMarker, latitude: index.latitude, longitude: index.longitude)
        }
        
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
		let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
		
		
		let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=\(ModeOfTravel.walking)"
		
		Alamofire.request(url).responseJSON { response in
			
			print(response.request as Any)  // original URL request
			print(response.response as Any) // HTTP URL response
			print(response.data as Any)     // server data
			print(response.result as Any)   // result of response serialization
			
			let json = JSON(data: response.data!)
			let routes = json["routes"].arrayValue
            var polyline: GMSPolyline?
			
			// print route using Polyline
			for route in routes {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                if polyline?.path == nil {
                    polyline = GMSPolyline.init(path: path)
                } else {
                   polyline?.path = path
                }
                    polyline?.strokeWidth = 4
                    polyline?.strokeColor = UIColor.red
                    polyline?.map = self.googleMaps
				
            }
            
			
		}
	}
	
	// MARK: when start location tap, this will open the search location
	@IBAction func openStartLocation(_ sender: UIButton) {
		
		let autoCompleteController = GMSAutocompleteViewController()
		autoCompleteController.delegate = self
		
		// selected location
		locationSelected = .startLocation
		
		// Change text color
		UISearchBar.appearance().setTextColor(color: UIColor.black)
		self.locationManager.stopUpdatingLocation()
		
		self.present(autoCompleteController, animated: true, completion: nil)
	}
	
	// MARK: when destination location tap, this will open the search location
	@IBAction func openDestinationLocation(_ sender: UIButton) {
		
		let autoCompleteController = GMSAutocompleteViewController()
		autoCompleteController.delegate = self
		
		// selected location
		locationSelected = .destinationLocation
		
		// Change text color
		UISearchBar.appearance().setTextColor(color: UIColor.black)
		self.locationManager.stopUpdatingLocation()
		
		self.present(autoCompleteController, animated: true, completion: nil)
	}
	
	
	// MARK: SHOW DIRECTION WITH BUTTON
	@IBAction func showDirection(_ sender: UIButton) {
		// when button direction tapped, must call drawpath func
		self.drawPath(startLocation: locationStart, endLocation: locationEnd)
	}

}

// MARK: - GMS Auto Complete Delegate, for autocomplete search location
extension MapsViewController: GMSAutocompleteViewControllerDelegate {
	
	func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
		print("Error \(error)")
	}
	
	func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
		
		// Change map location
		let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16.0)
		
		// set coordinate to text
		if locationSelected == .startLocation {
			//startLocation.text = "\(place.coordinate.latitude), \(place.coordinate.longitude)"
            startLocation.text = place.formattedAddress
			locationStart = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
			createMarker(titleMarker: "Location Start", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
		} else {
			//destinationLocation.text = "\(place.coordinate.latitude), \(place.coordinate.longitude)"
            destinationLocation.text = place.formattedAddress
			locationEnd = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
			createMarker(titleMarker: "Location End", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
		}
		
		
		self.googleMaps.camera = camera
		self.dismiss(animated: true, completion: nil)
		
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
	
}

public extension UISearchBar {
	
	public func setTextColor(color: UIColor) {
		let svs = subviews.flatMap { $0.subviews }
		guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
		tf.textColor = color
	}
	
}
