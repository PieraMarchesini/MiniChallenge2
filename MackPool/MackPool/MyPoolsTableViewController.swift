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

class MyPoolsTableViewController: UITableViewController,GMSMapViewDelegate ,  CLLocationManagerDelegate  {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    @IBOutlet weak var map: GMSMapView?
    
    var locationManager = CLLocationManager()
    //var locationSelected = Location.destinationLocation
    
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    
    var polyline: GMSPolyline = GMSPolyline()
    
    var mackLocations = [(titleMarker: "Mackenzie",subTitle: "Grupo ID",iconMarker: #imageLiteral(resourceName: "Mack") ,latitude: -23.547333693803449,longitude: -46.652063392102718),(titleMarker: "Carro",subTitle: "Grupo 1",iconMarker: #imageLiteral(resourceName: "car") ,latitude: -23.546291439376215, longitude: -46.651166863739491),(titleMarker: "Bike",subTitle: "Grupo 2",iconMarker: #imageLiteral(resourceName: "bike") ,latitude: -23.546486305621073, longitude: -46.652858331799507),(titleMarker: "Pedestre",subTitle: "Grupo 3",iconMarker: #imageLiteral(resourceName: "walk"),latitude: -23.548041229552691, longitude: -46.65295522660017), (titleMarker: "Transporte Público",subTitle: "Grupo 4",iconMarker: #imageLiteral(resourceName: "transit"),latitude: -23.548174929407701, longitude: -46.650337055325508)]
    
    let firebase = FirebaseController.instance
    var groups: [Group] = []
    
    override func viewWillAppear(_ animated: Bool) {
        self.groups = firebase.getGroups(forUserWithId: firebase.getCurrentUserId())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        //Your map initiation code
        // Mackenzie
        let camera = GMSCameraPosition.camera(withLatitude: -23.5481272892, longitude: -46.6503796353, zoom: 10.0)
        
        self.map?.camera = camera
        self.map?.delegate = self
        self.map?.settings.myLocationButton = true
        self.map?.settings.compassButton = true
        self.map?.settings.zoomGestures = true
        self.map?.isBuildingsEnabled = true
        self.map?.isTrafficEnabled = false
        //self.googleMaps.isMyLocationEnabled = true
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        setupResultsController()
        setupSearchController()
        
        
        self.clearsSelectionOnViewWillAppear = true
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        
        //navigationItem.titleView = searchController?.searchBar
        
        
        // Put the search bar in the top of screen
        //let subView = UIView(frame: CGRect(x: 0, y: 20.0, width: 330.0, height: 45.0))
        
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

    
    // MARK: function for create a marker pin on map
    func createMarker(titleMarker: String, subTitleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.snippet = subTitleMarker
        marker.icon = iconMarker
        marker.map = map
    }
    
    //MARK: - Location Manager delegates
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get location : \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 10.0)
        
        //let locationMackenzie = CLLocation(latitude: -23.548132206940085, longitude: -46.650346107780933)
        
        for index in mackLocations {
            
            createMarker(titleMarker: index.titleMarker, subTitleMarker: index.subTitle, iconMarker: index.iconMarker, latitude: index.latitude, longitude: index.longitude)
        }
        
        //drawPath(startLocation: CLLocation(latitude: -23.548132206940085, longitude: -46.650346107780933), endLocation: CLLocation(latitude: -23.546713751661457, longitude: -46.652353405952454))
        
        self.map?.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
        
    }
    
    // MARK: - GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        map?.isMyLocationEnabled = true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        map?.isMyLocationEnabled = true
        if (gesture) {
            mapView.selectedMarker = nil
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        map?.isMyLocationEnabled = true
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("COORDINATE \(coordinate)") // when you tapped coordinate
        //createMarker(titleMarker: "\(coordinate)", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        map?.isMyLocationEnabled = true
        map?.selectedMarker = nil
        return false
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
                self.polyline.map = self.map
                
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

// Handle the user's selection.
extension MyPoolsTableViewController: GMSAutocompleteResultsViewControllerDelegate {
    
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
        
        let bounds = GMSCoordinateBounds(coordinate: (map?.myLocation?.coordinate)!, coordinate: locationEnd.coordinate)
        let camera = map?.camera(for: bounds, insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))!
        
        map?.camera = camera!
        drawPath(startLocation: (map?.myLocation!)!, endLocation: locationEnd, modeOfTravel: "\(ModeOfTravel.walking)")
        showDistanceAndDuration(startLocation: (map?.myLocation!)!, endLocation: locationEnd, modeOfTravel: "\(ModeOfTravel.walking)")
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
