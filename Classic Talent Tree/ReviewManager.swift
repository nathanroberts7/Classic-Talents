//
//  ReviewManager.swift
//  Classic Talent Tree
//
//  Created by Nathan Roberts on 4/5/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import StoreKit

class ReviewManager {
    
    private enum Constants {
        static let numberOfReviewAttemptsKey: String = "numberOfReviewAttemptsKey"
        static let lastVersionPromptedForReviewKey: String = "lastVersionPromptedForReviewKey"
        static let minimumAttemptCount: Int = 2
    }
    
    func showReviewPrompt() {
        let reviewAttemptCount = UserDefaults.standard.integer(forKey: Constants.numberOfReviewAttemptsKey)
        UserDefaults.standard.set(reviewAttemptCount + 1, forKey: Constants.numberOfReviewAttemptsKey)
        
        let infoDictionaryKey = kCFBundleVersionKey as String
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String else { return }
        
        let lastVersionPromptedForReview = UserDefaults.standard.string(forKey: Constants.lastVersionPromptedForReviewKey)
        
        // If the current version is the same as the last version or there were not enough attempts, return.
        guard currentVersion != lastVersionPromptedForReview, reviewAttemptCount >= Constants.minimumAttemptCount else { return }
        
        // If we are to show the prompt, update the last version prompted.
        UserDefaults.standard.set(currentVersion, forKey: Constants.lastVersionPromptedForReviewKey)
        
        // Request the Review.
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            SKStoreReviewController.requestReview()
        }
    }
}
