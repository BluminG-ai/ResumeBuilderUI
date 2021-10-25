//
//  AppConfig.swift
//  ResumeBuilder
//
//  Created by Apps4Devs on 25/10/21.
//

import Foundation
import GoogleMobileAds

/// Basic app configurations
class AppConfig {

    /// This is the AdMob Interstitial ad id
    /// Test App ID: ca-app-pub-3940256099942544~1458002511
    /// Test Interstitial ID: ca-app-pub-3940256099942544/4411468910
    static let adMobAdID: String = "ca-app-pub-7597138854328701/4335985587"
    
    /// PDF Page size. We will be using the size below * `ScaleFactorType` value to increase the output quality
    static let pageWidth: Double = 8.5 * 75 /// U.S. letter size 8.5 x 11
    static let pageHeight: Double = 11 * 75 /// Multiply the size by 72 points per inch
    
    /// Turn this `true` to see the location where the PDF file is being saved on simulator
    static let showSavedPDFLocation: Bool = true
    
    /// Turn this `true` to hide the ads if necessary during testing
    static let shouldHideAds: Bool = false
}

// MARK: - Google AdMob Interstitial - Support class
class Interstitial: NSObject {
    private var interstitial: GADInterstitialAd?
    private var retryCount: Int = 0
    private let shouldRetryNumberOfTimes: Int = 3
    
    /// Default initializer of interstitial class
    override init() {
        super.init()
        loadInterstitial()
    }
    
    /// Request AdMob Interstitial ads
    func loadInterstitial() {
        GADInterstitialAd.load(withAdUnitID: AppConfig.adMobAdID, request: GADRequest()) { (ad, _) in
            self.interstitial = ad
        }
    }
    
    func showInterstitialAds() {
        if let root = UIApplication.shared.windows.first?.rootViewController, !AppConfig.shouldHideAds {
            interstitial?.present(fromRootViewController: root)
            loadInterstitial()
        }
    }
}
