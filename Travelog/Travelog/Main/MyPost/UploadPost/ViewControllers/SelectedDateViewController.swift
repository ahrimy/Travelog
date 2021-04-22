//
//  SelectedDateViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/04/20.
//

import UIKit

protocol SelectedDateViewControllerDelegate {
    func setDate(date: String)
}

class SelectedDateViewController: UIViewController {
    
    // MARK: - Properties
    var selectedDateViewControllerDelegate: SelectedDateViewControllerDelegate?
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var datePicker: UIDatePicker!{
        didSet{
            datePicker.date = Date()
            datePicker.maximumDate = Date()
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBAction
    
    @IBAction func dateValueChanged(_ sender: Any) {
        print(datePicker.date)
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
