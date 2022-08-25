//
//  WebViewInteractor.swift
//  FoodStory_Owner
//
//  Created by Nuttanai on 18/3/2564 BE.
//  Copyright (c) 2564 BE LivingMobile. All rights reserved.
//

import UIKit

class WebViewInteractor {
    var presenter: WebViewPresentationLogic?
    var worker: WebViewWorker?

    required init() {
        worker = WebViewWorker()
    }
}

extension WebViewInteractor: WebViewDataStore, WebViewBusinessLogic {
}
