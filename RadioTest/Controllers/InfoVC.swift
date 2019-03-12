//
//  InfoVC.swift
//  RadioTest
//
//  Created by Amir Daliri on 12.03.2019.
//  Copyright © 2019 AmirDaliri. All rights reserved.
//

import UIKit

class InfoVC: UIViewController {

    @IBOutlet weak var dismissButton: UIButton! {
        didSet {
            dismissButton.layer.cornerRadius = dismissButton.frame.height/2
        }
    }
    
    @IBOutlet weak var popupContentContainerView: UIView!
    @IBOutlet weak var popupMainView: UIView! {
        didSet {
            popupMainView.layer.cornerRadius = 10
        }
    }
    
    var customBlurEffectStyle: UIBlurEffect.Style!
    var customInitialScaleAmmount: CGFloat!
    var customAnimationDuration: TimeInterval!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return customBlurEffectStyle == .dark ? .lightContent : .default
    }

    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // I'm Here...
        modalPresentationCapturesStatusBarAppearance = true
    }
    
    // MARK: - Actio Methode

    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: - MIBlurPopupDelegate

extension InfoVC: MIBlurPopupDelegate {
    
    var popupView: UIView {
        return popupContentContainerView ?? UIView()
    }
    
    var blurEffectStyle: UIBlurEffect.Style {
        return customBlurEffectStyle
    }
    
    var initialScaleAmmount: CGFloat {
        return customInitialScaleAmmount
    }
    
    var animationDuration: TimeInterval {
        return customAnimationDuration
    }
    
}

