//
//  WebViewConfiguration.swift
//  FoodStory_Owner
//
//  Created by Nuttanai on 18/3/2564 BE.
//  Copyright (c) 2564 BE LivingMobile. All rights reserved.
//

import Foundation

class WebViewConfiguration {
    static let shared: WebViewConfiguration = WebViewConfiguration()
    
    func configure(_ viewController: WebViewViewController) {
        let interactor = WebViewInteractor()
        let presenter = WebViewPresenter()
        let router = WebViewRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
