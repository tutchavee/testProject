//
//  ProgressDialog.swift
//  TestProject
//
//  Created by Bas on 24/8/2565 BE.
//

import Foundation
import UIKit

struct ProgressDialog {
    static var alert = UIAlertController()
    static var progressView = UIProgressView()
    static var progressPoint : Float = 0{
        didSet{
            if(progressPoint == 1){
                ProgressDialog.alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}
