//
//  UploadPostViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/04/06.
//

import UIKit

class UploadPostViewController: UIViewController {
    
    // MARK: - Properties

    @IBOutlet weak var publicPrivateSegmentedControl: UISegmentedControl!{
        didSet {
            publicPrivateSegmentedControl.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
            publicPrivateSegmentedControl.setTitleTextAttributes([.foregroundColor : UIColor(red: 0.85, green: 0.72, blue: 0.76, alpha: 1.00)], for: .normal)
        }
    }
    
//    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Actions
    
    @IBAction func cancelUpload(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Methods
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
