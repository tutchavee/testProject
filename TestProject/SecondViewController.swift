//
//  SecondViewController.swift
//  TestProject
//
//  Created by Bas on 19/8/2565 BE.
//

import UIKit

protocol SecondViewControllerProtocol {
    func secondViewControllerProtocolDidSendText(text: String?)
}

class SecondViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    
    var delegate: SecondViewControllerProtocol?
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        label.text = text
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func gotoPage2Action(_ sender: Any) {
        delegate?.secondViewControllerProtocolDidSendText(text: textField.text)
        self.dismiss(animated: true)
    }

    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
//    view > present > secondview > present > view
//    view > present > secondview < view
}
