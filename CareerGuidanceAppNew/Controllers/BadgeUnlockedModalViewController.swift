//
//  BadgeUnlockedModalViewController.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 11/12/25.
//

import UIKit

class BadgeUnlockedModalViewController: UIViewController {

    var badge: Badge!
    var modalTitleString: String?
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var dismissButtonView: UIView!
    @IBOutlet weak var modalCardCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var modalCardView: UIView!
    @IBOutlet weak var largeIconBackgroundView: UIView!
    @IBOutlet weak var largeIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        largeIconBackgroundView.layoutIfNeeded()
        largeIconBackgroundView.layer.cornerRadius = largeIconBackgroundView.frame.height / 2
        largeIconBackgroundView.layer.masksToBounds = true
                
        UIView.animate(withDuration: 0.3) {
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            }
            modalCardCenterYConstraint.constant = view.bounds.height
            view.layoutIfNeeded()
        
        dismissButtonView.layer.cornerRadius = dismissButton.frame.height / 2
        dismissButtonView.layer.masksToBounds = true
        
        let iconSize: CGFloat = 12
        let iconConfig = UIImage.SymbolConfiguration(pointSize: iconSize, weight: .medium)
        
        let dismissImage = UIImage(systemName: "xmark", withConfiguration: iconConfig)
        dismissButton.setImage(dismissImage, for: .normal)
        setupTapToDismiss()
                configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            self.modalCardCenterYConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }


        func configureUI() {
            guard let badge = badge else {
                print("ERROR: Badge data is missing for modal configuration.")
                return
            }
            headerLabel.text = modalTitleString ?? "Badge Status"
            
            if !badge.isUnlocked {
                    titleLabel.alpha = 0.5
                    subtitleLabel.alpha = 0.5

                }
            subtitleLabel.text = badge.subtitle
            largeIconBackgroundView.backgroundColor = badge.color
            let config = UIImage.SymbolConfiguration(pointSize: 100, weight: .bold)
            largeIconImageView.image = UIImage(systemName: badge.iconName, withConfiguration: config)
            largeIconImageView.tintColor = .white
        }

    func setupTapToDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }

    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {

        let tapLocation = sender.location(in: view)
        if !modalCardView.frame.contains(tapLocation) {
            dismissTapped(self)
        }
    }

        @IBAction func dismissTapped(_ sender: Any) {
            dismiss(animated: true, completion: nil)
        }
}
