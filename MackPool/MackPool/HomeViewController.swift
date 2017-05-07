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

class HomeViewController: MapViewController {

    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        resultsViewController?.tableCellBackgroundColor = UIColor(hex: "990011")
        resultsViewController?.primaryTextColor = UIColor.gray
        resultsViewController?.primaryTextHighlightColor = UIColor.white
        resultsViewController?.secondaryTextColor = UIColor.white
        
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
        let subView = UIView(frame: CGRect(x: 0, y: 20.0, width: 330.0, height: 45.0))

        searchController?.searchBar.barTintColor = UIColor(hex: "990011")
        searchController?.searchBar.placeholder = "Buscar"
        subView.addSubview((searchController?.searchBar)!)
        self.view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    
}

// Handle the user's selection.
extension HomeViewController: GMSAutocompleteResultsViewControllerDelegate {
    
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

public extension UISearchBar {
    
    public func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
    
    public func setTextBackgroundColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.backgroundColor = color
    }
    
}


