//
//  UploadPostViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/03/30.
//

import UIKit

class UploadPostViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.isHidden = true
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor(red: 0.85, green: 0.72, blue: 0.76, alpha: 1.00)], for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor :        UIColor(red: 0.31, green: 0.16, blue: 0.36, alpha: 1.00)], for: .normal)
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
