//
//  RegisterViewController.swift
//  TestProject
//
//  Created by Bas on 24/8/2565 BE.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.view.superview?.center = CGPoint(x: self?.view.superview?.center.x ?? 414/2, y: (444.5)-100)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.view.superview?.center = CGPoint(x: self?.view.superview?.center.x ?? 414/2, y: 444.5)
            }
        }
    }

    @IBAction func registerAction(_ sender: Any) {
        if emailTextField.text?.count == 0 {
            showAlert(alertText: "Email", alertMessage: "Please input email")
            emailTextField.becomeFirstResponder()
            return
        } else if passwordTextField.text?.count == 0 {
            showAlert(alertText: "Password", alertMessage: "Please input password")
            passwordTextField.becomeFirstResponder()
            return
        } else if passwordTextField.text != rePasswordTextField.text {
            showAlert(alertText: "Re-Password", alertMessage: "Password don't match")
            rePasswordTextField.becomeFirstResponder()
            return
        }
        
        Auth.auth().createUser(withEmail: emailTextField.text ?? "", password: passwordTextField.text ?? "") { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if let _ = authResult {
                strongSelf.navigationController?.popViewController(animated: true)
                strongSelf.showAlert(alertText: "Success", alertMessage: "Register Success")
            } else if let error = error {
                strongSelf.showAlert(alertText: "Error", alertMessage: error.localizedDescription)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
