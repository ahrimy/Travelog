//
//  SelectedDateViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/04/20.
//

import UIKit

class SelectedDateViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var datePicker: UIDatePicker!{
        didSet{
            datePicker.date = Date()
            datePicker.maximumDate = Date()
        }
    }
    @IBOutlet weak var dateLabel: UILabel!{
        didSet{
            let formatter = DateFormatter() // DateFormatter 클래스 상수 선언
            formatter.dateFormat = "yyyy-MM-dd" // formatter의 dateFormat 속성을 설정
            dateLabel.text = formatter.string(from: datePicker.date)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        datePicker.isHidden = true
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
