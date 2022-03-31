//
//  Persistence.swift
//  Shared
//
//  Created by Pablo Albella on 8/15/21.
//

import CoreData

struct AdsController {
    static let shared = AdsController()

    let ads: RewardedAd

    init() {
        ads = RewardedAd()
    }
}
