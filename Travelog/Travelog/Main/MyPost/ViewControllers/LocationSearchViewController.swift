//
//  LocationSearchViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/04/07.
//

import UIKit
import MapKit

protocol LocationSearchViewControllerDelegate {
    func setLocation(location:String)
}

class LocationSearchViewController: UIViewController, UISearchBarDelegate, MKLocalSearchCompleterDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.searchTextField.textColor = UIColor.white
            searchBar.searchTextField.leftView?.tintColor = UIColor.white
        }
    }
    @IBOutlet weak var searchResultsTable: UITableView!
    
    // Create a search completer object
    var searchCompleter = MKLocalSearchCompleter()
    
    // These are the results that are returned from the searchCompleter & what we are displaying
    // on the searchResultsTable
    var searchResults = [MKLocalSearchCompletion]()
    
    var delegate: LocationSearchViewControllerDelegate?
   
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //Set up the delegates & the dataSources of both the searchbar & searchResultsTableView
        searchCompleter.delegate = self
        searchBar.delegate = self
        searchResultsTable.delegate = self
        searchResultsTable.dataSource = self
        searchBar.becomeFirstResponder()
    }
    
    
    // MARK: - Methods
    
    // This method declares that whenever the text in the searchbar is change to also update
    // the query that the searchCompleter will search based off of
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // This method declares gets called whenever the searchCompleter has new search results
    // If you wanted to do any filter of the locations that are displayed on the the table view
    // this would be the place to do it.
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // Setting our searchResults variable to the results that the searchCompleter returned
        searchResults = completer.results
        // Reload the tableview with our new searchResults
        searchResultsTable.reloadData()
    }
    
    // This method is called when there was an error with the searchCompleter
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // Error
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}

// Setting up extensions for the table view
extension LocationSearchViewController: UITableViewDataSource {
    // This method declares the number of sections that we want in our table.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // This method declares how many rows are the in the table
    // We want this to be the number of current search results that the
    // searchCompleter has generated for us
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    // This method declares the cells that are table is going to show at a particular index
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the specific searchResult at the particular index
        let searchResult = searchResults[indexPath.row]
        
        //Create  a new UITableViewCell object
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSearchResultCell", for: indexPath) as! LocationSearchTableViewCell
        
        //Set the content of the cell to our searchResult data
        cell.titleLabel?.text = searchResult.title
        cell.subTitleLabel?.text = searchResult.subtitle
        
        //        print(searchResult.title)
        
        return cell
    }
}

extension LocationSearchViewController: UITableViewDelegate {
    // This method declares the behavior of what is to happen when the row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let coordinate = response?.mapItems[0].placemark.coordinate else {
                return
            }
            
            guard let name = response?.mapItems[0].name else {
                return
            }
            
            let lat = coordinate.latitude
            let lon = coordinate.longitude
            
            print(lat)
            print(lon)
            print(name)
            
            self.delegate?.setLocation(location: name)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
