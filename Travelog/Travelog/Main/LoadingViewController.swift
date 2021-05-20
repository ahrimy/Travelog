//
//  LoadingViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/05/20.
//

import UIKit
import FirebaseAuth

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        UserService.shared.authUser(authorizedCompletion: presentMainVC, unAuthorizedCompletion: presentSignInVC)
    }
    
    // MARK: - Methods
    func presentMainVC(){
        if let vc = self.storyboard?.instantiateViewController(identifier: "HomeViewController") {
            self.view.window?.rootViewController = vc
        }
    }
    func presentSignInVC(){
        if let vc = self.storyboard?.instantiateViewController(identifier: "AuthViewController") {
            self.view.window?.rootViewController = vc
        }
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
