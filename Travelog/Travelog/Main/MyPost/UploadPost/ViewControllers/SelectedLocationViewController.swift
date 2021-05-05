//
//  SelectedLocationViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/04/14.
//

import UIKit
import MapKit

protocol SelectedLocationViewControllerDelegate{
    func setLocation(placeInfo:[String:String])
    func resetLocation()
}

class SelectedLocationViewController: UIViewController, LocationSearchViewControllerDelegate{
    
    // MARK: - Properties
    
    var isSelected = false
    
    let locationSearchViewController = LocationSearchViewController()
    
    var selectedLocationViewControllerDelegate: SelectedLocationViewControllerDelegate?

    // MARK: - IBOutlet
    
    @IBOutlet weak var setLocationLabel: UILabel!
    @IBOutlet weak var setLocationButton: UIButton!
    @IBOutlet weak var resetLocationButton: UIButton!{
        didSet{
            resetLocationButton.isHidden = true
        }
    }
    @IBOutlet weak var setLocationTapGestureRecognizer: UITapGestureRecognizer!
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

    @IBAction func resetLocation(_ sender: Any) {
        setLocationLabel.text = "위치 추가"
        isSelected = false
        setLocationButton.isHidden = false
        resetLocationButton.isHidden = true
        setLocationTapGestureRecognizer.isEnabled = true
        self.selectedLocationViewControllerDelegate?.resetLocation()
    }
    
    // MARK: - Methods
    
    func setLocation(placeInfo: [String:String]) {
        setLocationLabel.text = placeInfo["name"]!
        isSelected = true
        setLocationButton.isHidden = true
        resetLocationButton.isHidden = false
        setLocationTapGestureRecognizer.isEnabled = false
        self.selectedLocationViewControllerDelegate?.setLocation(placeInfo:placeInfo)
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
