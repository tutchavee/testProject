//
//  LoginModel.swift
//  TestProject
//
//  Created by Bas on 24/8/2565 BE.
//

import Foundation
import FirebaseAuth

class LoginModel {
    static var userID: String {
        return Auth.auth().currentUser?.uid ?? ""
    }
}
