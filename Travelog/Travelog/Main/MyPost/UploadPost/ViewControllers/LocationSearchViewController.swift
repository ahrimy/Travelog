//
//  LocationSearchViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/04/07.
//

import UIKit
import MapKit

protocol LocationSearchViewControllerDelegate {
    func setLocation(info:[String:Any])
}

class LocationSearchViewController: UIViewController, UISearchBarDelegate, MKLocalSearchCompleterDelegate {
    
    // MARK: - Properties
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    // Delegate
    var locationSearchViewControllerDelegate: LocationSearchViewControllerDelegate?
   
   // MARK: - IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.searchTextField.textColor = UIColor.white
            searchBar.searchTextField.leftView?.tintColor = UIColor.white
        }
    }
    @IBOutlet weak var searchResultsTable: UITableView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        searchCompleter.delegate = self
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        searchResultsTable.delegate = self
        searchResultsTable.dataSource = self
    }
    
    // MARK: - Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTable.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // TODO: Error
    }

}

extension LocationSearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSearchResultCell", for: indexPath) as! LocationSearchTableViewCell
        cell.titleLabel?.text = searchResult.title
        cell.subTitleLabel?.text = searchResult.subtitle
                
        return cell
    }
}

extension LocationSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let name = response?.mapItems[0].name else{
                return
            }
            guard let placemark = response?.mapItems[0].placemark else {
                return
            }
            let coordinate = CLLocation(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
            
            let placeInfo = [
                "name" : name,
                "address" : placemark.title ?? "",
                "postalCode" : placemark.postalCode ?? "",
                "country": placemark.country ?? "",
                "coordinate":coordinate
            ] as [String : Any]
            
//            print("name: " + (placeInfo["name"] as? String ?? "No Data" ))
//            print("address: " + (placeInfo["address"] as? String ?? "No Data" ))
//            print("postal: " + (placeInfo["postalCode"] as? String ?? "No Data" ))
//            print("country: " + (placeInfo["country"]as? String  ?? "No Data"))
            
            self.locationSearchViewControllerDelegate?.setLocation(info: placeInfo)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
