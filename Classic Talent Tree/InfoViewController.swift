//
//  InfoViewController.swift
//  Classic Talent Tree
//
//  Created by Nathan Roberts on 3/28/20.
//  Copyright © 2020 Nathan Roberts. All rights reserved.
//

import UIKit
import Toast_Swift

class InfoViewController: UIViewController {
    
    private enum Constants {
        static let websiteURL: String = "https://nathanroberts.me/"
        static let emailAddress: String = "support@nathanroberts.me"
        static let redditURL: String = "https://www.reddit.com/user/00setes/"
        static let deviantArtURL: String = "https://www.deviantart.com/setes7s"
        static let icons8URL: String = "https://icons8.com"
        static let copiedMessage: String = "Copied to Clipboard."
    }
    
    @IBAction func copyWebsiteURL(_ sender: UIButton) {
        copyToClipboard(text: Constants.websiteURL)
    }
    
    @IBAction func copyEmailAddress(_ sender: UIButton) {
        copyToClipboard(text: Constants.emailAddress)
    }
    
    @IBAction func copyRedditURL(_ sender: Any) {
        copyToClipboard(text: Constants.redditURL)
    }
    
    @IBAction func copyDeviantArtURL(_ sender: Any) {
        copyToClipboard(text: Constants.deviantArtURL)
    }
    
    @IBAction func copyIcons8URL(_ sender: UIButton) {
        copyToClipboard(text: Constants.icons8URL)
    }
    
    private func copyToClipboard(text: String) {
        UIPasteboard.general.string = text
        notify()
    }
    
    private func notify() {
        self.view.makeToast(Constants.copiedMessage, duration: 1.5, position: .bottom)
    }
}
