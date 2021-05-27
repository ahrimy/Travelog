//
//  SettingViewController.swift
//  Travelog
//
//  Created by 강예나 on 2021/03/23.
//

import UIKit

class SettingViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var LogOutButton: UIButton!{
        didSet{
            LogOutButton.layer.cornerRadius = 10
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Settings"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Actions
    @IBAction func didTouchLogOutButton(_ sender: Any) {
        UserService.shared.signOut(completion: completeSignOut)
    }
    
    // MARK: - Methods
    func completeSignOut(){
        if let vc = self.storyboard?.instantiateViewController(identifier: "AuthViewController") {
            self.view.window?.rootViewController = vc
        }
    }
}
