//
//  SelectedLocationViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/04/14.
//

import UIKit

// Location Model 설정
protocol SelectedLocationViewControllerDelegate{
    func setLocation(lat:String, lng:String, title:String, subTitle:String)
}

class SelectedLocationViewController: UIViewController, LocationSearchViewControllerDelegate{
    
    // MARK: - Properties
    
    var isSelected = false
    let locationSearchViewController = LocationSearchViewController()
    
    var selectedLocationViewControllerDelegate: SelectedLocationViewControllerDelegate?

    // MARK: - IBOutlet
    
    @IBOutlet weak var setLocationLabel: UILabel!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let locationSearchViewController = segue.destination as? LocationSearchViewController {
            locationSearchViewController.locationSearchViewControllerDelegate = self
        }
    }
    
    // MARK: - Actions

    
    // MARK: - Methods
    
    func setLocation(lat: String, lng: String, title: String, subTitle: String) {
        setLocationLabel.text = title
        isSelected = true
        
        self.selectedLocationViewControllerDelegate?.setLocation(lat: lat, lng: lng, title: title, subTitle: subTitle)
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
