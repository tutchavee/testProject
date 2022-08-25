//
//  ViewController.swift
//  TestProject
//
//  Created by Bas on 15/8/2565 BE.
//

import UIKit
import Alamofire
import FirebaseAuth
import FirebaseCore

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        view.endEditing(true)
        LoadingStart(loadingText: .Loading)
        Auth.auth().signIn(withEmail: emailTextField.text ?? "", password: passwordTextField.text ?? "") { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            
            strongSelf.LoadingStop()
            if let _ = authResult {
                strongSelf.dismiss(animated: true)
            } else if let error = error {
                strongSelf.showAlert(alertText: "Error", alertMessage: error.localizedDescription)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
