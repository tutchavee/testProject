//
//  WebViewRouter.swift
//  FoodStory_Owner
//
//  Created by Nuttanai on 18/3/2564 BE.
//  Copyright (c) 2564 BE LivingMobile. All rights reserved.
//

import UIKit

class WebViewRouter: NSObject, WebViewRoutingLogic, WebViewDataPassing {
    weak var viewController: WebViewViewController?
    var dataStore: WebViewDataStore?
}
