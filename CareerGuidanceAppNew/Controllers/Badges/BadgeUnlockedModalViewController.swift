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
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                self.modalCardCenterYConstraint.constant = 0
                self.view.layoutIfNeeded()
            }) { _ in
                self.triggerBadgeFlip()
            }
    }
    private func createConfetti() {
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: view.center.x, y: view.center.y - 50)
        emitter.emitterShape = .point
        emitter.emitterSize = CGSize(width: 10, height: 10)
        
        let colors: [UIColor] = [.systemYellow, .systemPink, .systemBlue, .systemGreen, .systemOrange]
        
        let cells: [CAEmitterCell] = colors.map { color in
            let cell = CAEmitterCell()
            cell.birthRate = 15
            cell.lifetime = 2.0
            cell.velocity = 200
            cell.velocityRange = 100
            cell.emissionRange = .pi * 2
            cell.spin = 4
            cell.scale = 0.1
            cell.scaleRange = 0.05
            cell.contents = drawConfettiShape()?.cgImage
            cell.color = color.cgColor
            return cell
        }
        
        emitter.emitterCells = cells
        view.layer.insertSublayer(emitter, below: modalCardView.layer)
        
        // Stop emitting after a brief burst
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            emitter.birthRate = 0
        }
    }

    private func drawConfettiShape() -> UIImage? {
        let size = CGSize(width: 10, height: 10)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    private func triggerBadgeFlip() {
        // 1. Add Perspective
        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0 / 500.0 // The lower the value, the more intense the 3D effect
        
        // 2. Create the Flip Animation
        let flipAnim = CABasicAnimation(keyPath: "transform")
        flipAnim.fromValue = NSValue(caTransform3D: CATransform3DRotate(perspective, 0, 0, 1, 0))
        flipAnim.toValue = NSValue(caTransform3D: CATransform3DRotate(perspective, .pi * 2, 0, 1, 0))
        flipAnim.duration = 1.2
        flipAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // 3. Create a Scale "Pop" (Duolingo Style)
        let scaleAnim = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnim.values = [1.0, 1.2, 1.0]
        scaleAnim.keyTimes = [0, 0.5, 1.0]
        scaleAnim.duration = 1.2
        
        // Group them
        let group = CAAnimationGroup()
        group.animations = [flipAnim, scaleAnim]
        group.duration = 1.2
        
        largeIconBackgroundView.layer.add(group, forKey: "fitnessFlip")
        
        // Trigger Confetti if the badge is unlocked
        if badge.isUnlocked {
            createConfetti()
        }
        
        // Premium Haptics
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
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
            // Adds depth to the badge for the flip animation
            largeIconBackgroundView.layer.shadowColor = UIColor.black.cgColor
            largeIconBackgroundView.layer.shadowOpacity = 0.3
            largeIconBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 10)
            largeIconBackgroundView.layer.shadowRadius = 10
            largeIconBackgroundView.layer.shouldRasterize = true
            largeIconBackgroundView.layer.rasterizationScale = UIScreen.main.scale

            // Optional: Rotate the icon slightly during the slide up for more energy
            largeIconBackgroundView.transform = CGAffineTransform(rotationAngle: -0.2)
            UIView.animate(withDuration: 0.5) {
                self.largeIconBackgroundView.transform = .identity
            }
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
