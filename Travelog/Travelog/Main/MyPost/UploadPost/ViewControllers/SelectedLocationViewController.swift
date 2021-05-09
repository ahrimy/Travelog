//
//  SelectedLocationViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/04/14.
//

import UIKit
import MapKit

protocol SelectedLocationViewControllerDelegate{
    func activateUploadButton()
}

class SelectedLocationViewController: UIViewController, LocationSearchViewControllerDelegate{
    
    // MARK: - Properties
    var isSelected = false
    var location = Location()
    
    // Delegate
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
        setLocationButton.isHidden = false
        resetLocationButton.isHidden = true
        setLocationTapGestureRecognizer.isEnabled = true
        
        self.isSelected = false
        self.selectedLocationViewControllerDelegate?.activateUploadButton()
    }
    
    // MARK: - Methods

    func setLocation(info: [String:Any]) {
        setLocationLabel.text = info["name"] as? String
        setLocationButton.isHidden = true
        resetLocationButton.isHidden = false
        setLocationTapGestureRecognizer.isEnabled = false
        
        self.isSelected = true
        self.location.updateLocation(info: info)
        self.selectedLocationViewControllerDelegate?.activateUploadButton()
    }

}
