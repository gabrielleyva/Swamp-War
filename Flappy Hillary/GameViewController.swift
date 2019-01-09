//
//  GameViewController.swift
//  Flappy Hillary
//
//  Created by Gabriel I Leyva Merino on 12/18/17.
//  Copyright © 2017 Will Clark. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds
import GameKit

class GameViewController: UIViewController, GADBannerViewDelegate, GKGameCenterControllerDelegate, GADInterstitialDelegate {
    
    var adView: GADBannerView!
    var fullAdView: GADInterstitial!
    @IBOutlet weak var gameCenterButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var bookButton: UIButton!
    
    /* Variables */
    var viewModel: ViewModel!
    var container: SKView?
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    var score = 0
    
    // IMPORTANT: replace the red string below with your own Leaderboard ID (the one you've set in iTunes Connect)
    let LEADERBOARD_ID = "com.pcpublishing.swampwar"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ViewModel()
        viewModel.getUrls()
        
        self.view.isUserInteractionEnabled = true
        
        let gameView = SKView(frame: self.view.bounds)
        gameView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        gameView.layer.position = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height)
        gameView.ignoresSiblingOrder = true
        container = gameView
      
        let scene = GameScene(size: gameView.bounds.size)
        scene.scaleMode = .aspectFill
        scene.viewController = self
        gameView.presentScene(scene)
        self.view.addSubview(gameView)
        
        print("Height: ", self.view.frame.size.height)
        print("Width: ", self.view.frame.size.width)
        
        //self.prepareAdView()
        self.prepareShareButton()
        self.prepareBookButton()
        self.prepareGameCenterButton()
        self.prepareFeatureView()
        //self.fullAdView = self.prepareFullAdView()
        self.authenticateLocalPlayer()
    }
    
    //MARK: Main UI configuration methods
    func prepareFeatureView() {
        self.view.bringSubview(toFront: self.shareButton)
        self.view.bringSubview(toFront: self.gameCenterButton)
        self.view.bringSubview(toFront: self.bookButton)
        
        self.bookButton.isHidden = true
        self.gameCenterButton.isHidden = true
        self.shareButton.isHidden = true
        
    }
    
    func addBannerViewToView() {
        adView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.adView)
        view.addConstraints(
            [NSLayoutConstraint(item: adView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: adView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }

    func prepareAdView() {
        adView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView()
        
        //Production ID:ca-app-pub-4003078411316896/7256033527 -- TEST ID: ca-app-pub-3940256099942544/2934735716
        adView.adUnitID = "ca-app-pub-4003078411316896/7256033527"
        adView.rootViewController = self
        adView.alpha = 0
        
        let request = GADRequest()
        //request.testDevices = [ "bd6230969263c89ac6a919221ca64605", kGADSimulatorID]
        adView.load(request)
        
        adView.delegate = self

    }
    
    func presentFullAdView() {
//        if fullAdView.isReady {
//            fullAdView.present(fromRootViewController: self)
//        } else {
//            print("Ad wasn't ready")
//        }
    }
    
    func prepareFullAdView() -> GADInterstitial {
        //Production ID: ca-app-pub-4003078411316896/2724039376 -- Test ID: ca-app-pub-3940256099942544/4411468910
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-4003078411316896/2724039376")
        interstitial.delegate = self
        
        let request = GADRequest()
        //request.testDevices = [ "bd6230969263c89ac6a919221ca64605", kGADSimulatorID]
        interstitial.load(request)
        
        return interstitial
    }
    
    func prepareGameOverView() {
        shareButton.isHidden = false
        bookButton.isHidden = false
        gameCenterButton.isHidden = false
        UIView.animate(withDuration: 1, animations: {
            self.shareButton.alpha = 1
            self.bookButton.alpha = 1
            self.gameCenterButton.alpha = 1
        })
    }
    
    func hideFeatureView() {
        UIView.animate(withDuration: 1, animations: {
            self.shareButton.alpha = 0
            self.bookButton.alpha = 0
            self.gameCenterButton.alpha = 0
        })
        shareButton.isHidden = true
        bookButton.isHidden = true
        gameCenterButton.isHidden = true
    }
    

    
    func prepareShareButton() {
        shareButton.layer.cornerRadius = 5
        shareButton.layer.borderWidth = 3
        shareButton.layer.borderColor = UIColor.white.cgColor
        
        shareButton.setTitleColor(.white, for: .normal)
        shareButton.titleLabel?.font = UIFont(name: "Funny & Cute", size: 18)
        
        shareButton.isHidden = true
        shareButton.alpha = 0
    }
    
    func prepareGameCenterButton() {
        gameCenterButton.layer.cornerRadius = 5
        gameCenterButton.layer.borderWidth = 3
        gameCenterButton.layer.borderColor = UIColor.white.cgColor
        
        gameCenterButton.setTitleColor(.white, for: .normal)
        gameCenterButton.titleLabel?.font = UIFont(name: "Funny & Cute", size: 18)
        
        gameCenterButton.isHidden = true
        gameCenterButton.alpha = 0
    }
    
    func prepareBookButton() {
        bookButton.layer.cornerRadius = 5
        bookButton.layer.borderWidth = 3
        bookButton.layer.borderColor = UIColor.white.cgColor
        
        bookButton.setTitleColor(.white, for: .normal)
        bookButton.titleLabel?.font = UIFont(name: "Funny & Cute", size: 18)
        
        bookButton.isHidden = true
        bookButton.alpha = 0
    }
    
    //MARK: Game Center
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil {
                        print(error as Any)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error as Any)
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: Actions
    
    @IBAction func getBookButtonPressed(_ sender: Any) {
        if let url = URL(string: viewModel.bookUrl) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        let shareText = "Get the iOS Game Swamp War Now!"
        
        if let image = UIImage(named: "icon1024.png") {
            let myWebsite = URL(string: self.viewModel.shareUrl)
            let vc = UIActivityViewController(activityItems: [shareText, image, myWebsite], applicationActivities: [])
            present(vc, animated: true)
        }
    }
    
    @IBAction func checkGCLeaderboard(_ sender: AnyObject) {
        let highScore = UserDefaults.standard.integer(forKey: "high-score")
        
            let bestScoreInt = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
            bestScoreInt.value = Int64(highScore)
            GKScore.report([bestScoreInt]) { (error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Best Score submitted to your Leaderboard!")
                }
            }
        
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = LEADERBOARD_ID
        present(gcVC, animated: true, completion: nil)
    }
    
    //MARK: AdView Delegates
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("SUCCESS")
        adView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            self.adView.alpha = 1
          //  self.container?.transform = CGAffineTransform(scaleX: 1.0, y: (self.view.frame.size.height - self.adView.frame.size.height) / (self.view.frame.size.height));
            //self.adView.center = CGPoint(x: self.view.frame.size.width / 2.0, y: self.adView.frame.size.height / 2.0)
            
        })
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("FAILED: ", error)
        UIView.animate(withDuration: 1, animations: {
            self.adView.alpha = 0
            //self.container?.transform = CGAffineTransform.identity
            //self.adView.center = CGPoint(x: self.view.frame.size.width / 2.0, y: self.adView.frame.size.height / 2.0)
            
        })
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
    
    //MARK: Game Center Delegate Methods
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: Interstitial Ad View Delegate Methods
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.fullAdView = prepareFullAdView()
    }
}
