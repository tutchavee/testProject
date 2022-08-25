//
//  WebViewProtocol.swift
//  FoodStory_Owner
//
//  Created by Nuttanai on 18/3/2564 BE.
//  Copyright (c) 2564 BE LivingMobile. All rights reserved.
//

import Foundation

//MARK: ViewController
protocol WebViewDisplayLogic: class {
}

//MARK: Interactor
protocol WebViewBusinessLogic {
}

//MARK: Presenter
protocol WebViewPresentationLogic {
}

//MARK: Routable
@objc protocol WebViewRoutingLogic {

}

//MARK: DataStore
protocol WebViewDataStore {

}

//MARK: DataPassing
protocol WebViewDataPassing {
    var dataStore: WebViewDataStore? { get }
}
