//
//  SignUpViewController.swift
//  Travelog
//
//  Created by Ahrim Yang on 2021/05/21.
//

import UIKit

class SignUpViewController: UIViewController {

    // MARK: - Properties
    var isEmailValid = false
    var isPasswordValid = false
    var isPasswordConfirm = false
    var isUsernameValid = false
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!{
        didSet{
            signUpButton.isEnabled = false
        }
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hideKeyboard()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.passwordConfirmTextField.delegate = self
        self.usernameTextField.delegate = self
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
    @IBAction func didTouchCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func didTouchSignUpButton(_ sender: Any) {
        //TODO: format validate
        //TODO: password confirm
        //TODO: check duplicate username
        let data = [
            "email": emailTextField.text! as String,
            "password": passwordTextField.text! as String,
            "username": usernameTextField.text! as String
        ]
        UserService.shared.singUp(data: data, completion: completeSignUp)
    }
    
    // MARK: - Methods
    func completeSignUp(){
//        self.dismiss(animated: true, completion: nil)
        if let vc = self.storyboard?.instantiateViewController(identifier: "HomeViewController") {
            self.view.window?.rootViewController = vc
        }
    }
    func validateEmail() -> Bool {
        let RegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let test = NSPredicate(format: "SELF MATCHES %@", RegEx)
        return test.evaluate(with: emailTextField.text)
    }
    func validatePassword() -> Bool {
        // TODO: password format check
        let RegEx = "\\w{6,}"
        let test = NSPredicate(format: "SELF MATCHES %@", RegEx)
        return test.evaluate(with: passwordTextField.text)
    }
    func confirmPassword() -> Bool {
        return passwordTextField.text == passwordConfirmTextField.text
    }
    func validateUsername() -> Bool {
        let RegEx = "\\w{2,10}"
        let test = NSPredicate(format: "SELF MATCHES %@", RegEx)
        return test.evaluate(with: usernameTextField.text)
    }
    func activateSignUpButton(){
//        print(isEmailValid, isPasswordValid, isPasswordConfirm, isUsernameValid)
        self.signUpButton.isEnabled = isEmailValid && isPasswordValid && isPasswordConfirm && isUsernameValid
    }
}
extension SignUpViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.restorationIdentifier {
        case "email":
            isEmailValid = validateEmail()
            activateSignUpButton()
            return
        case "password":
            isPasswordValid = validatePassword()
            isPasswordConfirm = confirmPassword()
            activateSignUpButton()
            return
        case "passwordConfirm":
            isPasswordConfirm = confirmPassword()
            activateSignUpButton()
            return
        case "username":
            isUsernameValid = validateUsername()
            if isUsernameValid {
                UserService.shared.checkUsernameDuplicate(username: usernameTextField.text!){ isExist in
                    self.isUsernameValid = !isExist
                    self.activateSignUpButton()
                }
            }
            return
        default:
            return
        }
    }
}

