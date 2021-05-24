//
//  LoginViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/05/20.
//

import UIKit

class SignInViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - IBOutlet
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - IBAction
    @IBAction func didTouchLoginButton(_ sender: Any) {
        UserService.shared.signIn(email: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: completeSignIn)
    }
    @IBAction func didTouchCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods
    func completeSignIn(){
        if let vc = self.storyboard?.instantiateViewController(identifier: "HomeViewController") {
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
