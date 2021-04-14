//
//  SelectedLocationViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/04/14.
//

import UIKit

class SelectedLocationViewController: UIViewController,LocationSearchViewControllerDelegate{
    
    // MARK: - Properties
    
    var isSelected = false
    let locationSearchViewController = LocationSearchViewController()

    @IBOutlet weak var setLocationLabel: UILabel!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let locationSearchViewController = segue.destination as? LocationSearchViewController {
            locationSearchViewController.delegate = self
        }
    }
    
    // MARK: - Actions

    
    // MARK: - Methods
    
    func setLocation(location: String) {
        setLocationLabel.text = location
        isSelected = true
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
