//
//  WAPickUpLocation.swift
//  WhereApp
//
//  Created by Salman on 05/06/2017.
//  Copyright © 2017 Salman. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

var DEVICE_LAT =  0.0
var DEVICE_LONG = 0.0


var CURRENT_DEVICE_LAT =  0.0
var CURRENT_DEVICE_LONG = 0.0

protocol PickUpLatLnt {
    func pickUpLatitudeAndLong(_ lon:Double, andLatitude lat:Double, title: String)
}


class WAPickUpLocation: UIViewController  , LocateOnTheMap,GMSAutocompleteFetcherDelegate , UISearchBarDelegate {
    
    @IBOutlet var pinImage: UIImageView!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var textFieldSearch: UITextField!
    @IBOutlet var viewOfMaps: GMSMapView!
    
    @IBOutlet var btnSelectLocation: UIButton!
    @IBOutlet var btnFind: UIButton!
    
    var resultsArray = [String]()
    var gmsFetcher: GMSAutocompleteFetcher!
    var searchResultController: SearchResultsController!
    var delegate: PickUpLatLnt!
    
    var latitude :  Double?
    var lngitude :  Double?
    var address :  String?
    var isPickingLocation: Bool = false
    var isFirstTime: Bool = false
    var isSelectLocatin: Bool = false
    
    var pickMarker: GMSMarker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getting the current location
        setDefaultLocationOnMap()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        localizeStrings(language: APIManager.sharedInstance.getLanguage()!.code)
        
        WebServiceManager.setBorderAndCornerRadius(layer: textFieldSearch.layer, width: 0.0, radius: 15, color: .clear)
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        textFieldSearch.delegate = self
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
        

    }
    override func viewWillDisappear(_ animated: Bool) {
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Localization configrations
    func localizeStrings(language: String) {
//        LocalizationSystem.shared.setLanguage(languageCode: language)
        title = LocalizationSystem.shared.localizedStringForKey(key: "Select_your_location", comment: "")
        btnSelectLocation.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "Select_Location", comment: ""), for: .normal)
        btnFind.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "find", comment: ""), for: .normal)

    }
    

    //MARK: custom methods
    func setupUI() {
        
        self.viewOfMaps.delegate = self
        self.viewOfMaps?.isMyLocationEnabled = true
        self.viewOfMaps.mapType = GMSMapViewType(rawValue: 3)!

    }
    
    
    func setDefaultLocationOnMap() {
        if self.latitude != nil  && self.lngitude != nil {
            setLocationOnMap(lat: self.latitude!, long: self.lngitude!)
        }else {
            _ =  Location.getLocation(withAccuracy:.block, frequency: .oneShot, onSuccess: { location in
                print("loc \(location.coordinate.longitude)\(location.coordinate.latitude)")
                DEVICE_LAT = location.coordinate.latitude
                DEVICE_LONG = location.coordinate.longitude
                self.latitude = DEVICE_LAT
                self.lngitude = DEVICE_LONG
                
                //setting location on map
                self.setLocationOnMap(lat: self.latitude!, long: self.lngitude!)
                
            }) { (last, error) in
                
                print("Something bad has occurred \(error)")
                
                //setting location on map
                self.setLocationOnMap(lat: DEVICE_LAT, long: DEVICE_LONG)
                
            } 
        }
    }
    
    func setLocationOnMap(lat: Double, long: Double) {
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.viewOfMaps.mapType = GMSMapViewType(rawValue: 3)!
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 16)
            self.viewOfMaps.camera = camera

        })
        self.viewOfMaps.settings.myLocationButton = false
    }
    
    //MARK: IBAction Method
    @IBAction func btnSearchLocation(_ sender: UIButton) {
        
        let searchController = UISearchController(searchResultsController: searchResultController)
        
        searchController.searchBar.delegate = self
        self.present(searchController, animated:true, completion: nil)
        
    }
    
    
    @IBAction func currentLocationPressed(_ sender: Any) {
        _ =  Location.getLocation(withAccuracy:.block, frequency: .oneShot, onSuccess: { location in
            print("loc \(location.coordinate.longitude)\(location.coordinate.latitude)")
            DEVICE_LAT = location.coordinate.latitude
            DEVICE_LONG = location.coordinate.longitude
            self.latitude = DEVICE_LAT
            self.lngitude = DEVICE_LONG
            
            self.viewOfMaps.animate(toLocation: CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.lngitude!))
            
            
        }) { (last, error) in
            
            self.viewOfMaps.animate(toLocation: CLLocationCoordinate2D(latitude: DEVICE_LAT, longitude: DEVICE_LONG))
            
        }
    }
    
    @IBAction func btnPickUpLocation(_ sender: UIButton) {
//        if isPickingLocation == false {
//            self.delegate.pickUpLatitudeAndLong(self.lngitude!, andLatitude: self.latitude!, title: self.address!)
//
//            _ = self.navigationController?.popViewController(animated: true)
//        }
        var loc = StoreByLocation()
        if let lat = self.latitude , let long = self.lngitude {
            loc.latitude = lat
            loc.lngitude = long
            loc.isLocation = true
            DEVICE_LONG = long
            DEVICE_LAT = lat
            APIManager.sharedInstance.setLocation(in: loc)
        }
        self.navigationController?.navigationController?.navigationBar.isHidden = true
        self.navigationController?.popViewController(animated: true)
        

        print(self.latitude ," - ", self.lngitude)
    }
    
    @IBAction func clearText(_ sender: Any) {
        
        textFieldSearch.text = ""
        tblView.isHidden = true
        self.resultsArray.removeAll()
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.reloadData()
        
        
    }
    
    @IBAction func goBack(_ sender: Any) {
//        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    // pickUp Location Delegate method
    
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        DispatchQueue.main.async { () -> Void in
            
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 15)
            self.viewOfMaps.camera = camera
            marker.icon = UIImage(named: "pin-3")
            marker.title = "Address : \(title)"
            self.latitude = lat
            self.lngitude = lon
            self.address = title
            
            marker.map = self.viewOfMaps
            
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//        self.resultsArray.removeAll()
        gmsFetcher?.sourceTextHasChanged(searchText)
    }
    
    
    // Google place autocomplete method
    
    /**
     * Called when an autocomplete request returns an error.
     * @param error the error that was received.
     */
    public func didFailAutocompleteWithError(_ error: Error) {
        //        resultText?.text = error.localizedDescription
    }
    
    /**
     * Called when autocomplete predictions are available.
     * @param predictions an array of GMSAutocompletePrediction objects.
     */
    public func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        //self.resultsArray.count + 1
        self.resultsArray.removeAll()
        for prediction in predictions {
            
            if let prediction = prediction as GMSAutocompletePrediction!{
                self.resultsArray.append(prediction.attributedFullText.string)
            }
        }
        //self.searchResultController.reloadDataWithArray(self.resultsArray)
        //   self.searchResultsTable.reloadDataWithArray(self.resultsArray)
        tblView.delegate = self
        tblView.dataSource = self
        tblView.reloadData()
        
    }
    
    // Google map Method
    
    
    
}

extension WAPickUpLocation: GMSMapViewDelegate {
    
    
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if isFirstTime == false {
            self.pinImage.isHidden = false
            mapView.clear()
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        if isSelectLocatin == true {
            isSelectLocatin = false
            return
        }
        
        let gooogle = GMSGeocoder()
        isPickingLocation = true
        self.latitude = position.target.latitude
        self.lngitude = position.target.longitude
        gooogle.reverseGeocodeCoordinate(position.target) { (response, error) in
            self.isPickingLocation = false
            if response != nil {
                let obj = (response?.results()?.first)! as GMSAddress
                for str in obj.lines! {
                    if str.characters.count > 0 {
                        self.address = str
                        self.textFieldSearch.text = str
                        return
                    }
                }
            }
        }
    }
    
    func mapViewSnapshotReady(_ mapView: GMSMapView) {
        isFirstTime = false
    }
    
    
}

extension WAPickUpLocation: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if indexPath.row < self.resultsArray.count {
            cell.textLabel?.font = UIFont(name: "Montserrat-Regular", size: 12)
            cell.textLabel?.textColor = UIColor(named: "blue_grey")
            cell.textLabel?.text = self.resultsArray[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        isSelectLocatin = true
        
        
        if self.resultsArray[indexPath.row] != "" {
            tableView.isHidden = true
            address = self.resultsArray[indexPath.row]
            textFieldSearch.text = address
            
            //#3
            //pinImage.isHidden = true
            
            //getting lat long
            let urlpath = "https://maps.googleapis.com/maps/api/geocode/json?address=\(self.resultsArray[indexPath.row])&sensor=false&key=AIzaSyAyAhBLszv_6xK472hyxnSfSFl8IDtylmE".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            isPickingLocation = true
            let url = URL(string: urlpath!)

            let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) -> Void in
                // 3
                self.isPickingLocation = false
                do {
                    if data != nil {
                        let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                        
                        self.latitude =   (((((dic.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lat")) as? Double
                        
                        self.lngitude =   (((((dic.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lng")) as? Double
                        
                        
                        DispatchQueue.main.async { () -> Void in
                            //#1
                            //                        let position = CLLocationCoordinate2DMake(self.latitude!, self.lngitude!)
                            //                        let marker = GMSMarker(position: position)
                            //
                            //                        marker.icon = UIImage(named: "pin-3")
                            //                        marker.map = self.viewOfMaps
                            
                            self.viewOfMaps.animate(toLocation: CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.lngitude!))
                            
                        }
                        
                    }
                    
                }catch {
                    print("Error")
                }
            }
            // 5
            task.resume()
        }
    
    }
    
}

extension WAPickUpLocation: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //#4
        //pinImage.isHidden = true
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if tblView.isHidden && textField.text != nil && (textField.text?.count)! > 0 {
            tblView.isHidden = false
        }
        
        let searchStr = textFieldSearch.text! + string
        gmsFetcher.sourceTextHasChanged(searchStr)
        return true
        
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        tblView.isHidden = true
        return true
    }
    
    
}
