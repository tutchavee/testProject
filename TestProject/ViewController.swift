//
//  ViewController.swift
//  TestProject
//
//  Created by Bas on 15/8/2565 BE.
//

import UIKit
import Alamofire

class ViewController: UIViewController, SecondViewControllerProtocol {
    func secondViewControllerProtocolDidSendText(text: String?) {
        label?.text = text
    }
    
    
    @IBOutlet weak var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let text = label?.text {
            getTextToNunber(text: text)
        }
        
        guard let text = label?.text else {
            print("error text")
            return
        }
        
        print("acass")
    }
    
    func getTextToNunber(text: String) {
            print(text)
    }
    
    @IBAction func gotoPage1Action(_ sender: Any) {
        guard let url = URL(string: "http://api.nytimes.com/svc/topstories/v2/books.json?api-key=GDrQ2aBDKGj6DELALg9H4JeXLysN1peW") else {
            return
        }
        
        AF.request(url).responseString { response in
            do {
                guard let data = response.data else {
                    return
                }
                
                let responseModel = try JSONDecoder().decode(ModelResponse.self, from: data)
                print("status == \(responseModel.results.count)")
            } catch let error {
                print(error)
            }
        }
    }
}


struct ModelResponse: Codable {
    let status: String
    let copyright: String
    let numberResult: Int
    let lastUpdated: String
    let results: [ResultModel]
    
    enum CodingKeys: String, CodingKey {
        case status
        case copyright
        case results
        case lastUpdated = "last_updated"
        case numberResult = "num_results"
    }
}

struct ResultModel: Codable {
    let section: String
    let title: String
}
