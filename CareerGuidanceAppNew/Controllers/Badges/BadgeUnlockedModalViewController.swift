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
    private var floatingCloseButton: UIButton?
    @IBOutlet weak var headerLabel: UILabel!
    //@IBOutlet weak var dismissButtonView: UIView!
    @IBOutlet weak var modalCardCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var modalCardView: UIView!
    @IBOutlet weak var largeIconBackgroundView: UIView!
    @IBOutlet weak var largeIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var mainStackView: UIStackView!
    
    // Programmatic UI Elements
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let progressLabel = UILabel()
    private let reasonLabel = UILabel()
    private let earnedDateLabel = UILabel()
    
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
        
        setupAdditionalUI()
        setupCloseButton()
        setupTapToDismiss()
        configureUI()
    }
    
    private func setupAdditionalUI() {
        // Configure new labels and progress view
        headerLabel.font = .systemFont(ofSize: 12, weight: .bold)
        headerLabel.textColor = .secondaryLabel
        headerLabel.alpha = 0.8
        
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .label
        
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        
        reasonLabel.font = .systemFont(ofSize: 13, weight: .regular)
        reasonLabel.textColor = .tertiaryLabel
        reasonLabel.textAlignment = .center
        reasonLabel.numberOfLines = 0
        
        progressView.progressTintColor = UIColor(hex: "#1fa5a1")
        progressView.trackTintColor = .systemGray6
        progressView.layer.cornerRadius = 3
        progressView.clipsToBounds = true
        
        progressLabel.font = .systemFont(ofSize: 13, weight: .bold)
        progressLabel.textColor = .label
        progressLabel.textAlignment = .center
        
        earnedDateLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        earnedDateLabel.textColor = .secondaryLabel
        earnedDateLabel.textAlignment = .center
        
        // Progress container to add padding
        let progressContainer = UIStackView(arrangedSubviews: [progressView, progressLabel])
        progressContainer.axis = .vertical
        progressContainer.spacing = 6
        progressContainer.alignment = .fill
        
        // Add to existing mainStackView
        mainStackView.addArrangedSubview(reasonLabel)
        mainStackView.addArrangedSubview(progressContainer)
        mainStackView.addArrangedSubview(earnedDateLabel)
        
        // Refined spacing
        mainStackView.spacing = 20
        mainStackView.setCustomSpacing(40, after: largeIconBackgroundView)
        mainStackView.setCustomSpacing(10, after: titleLabel)
        mainStackView.setCustomSpacing(30, after: reasonLabel)
        
        // Hide redundant labels for a minimal look
        headerLabel.isHidden = true
        subtitleLabel.isHidden = true
        earnedDateLabel.isHidden = true
        
        NSLayoutConstraint.activate([
            progressView.heightAnchor.constraint(equalToConstant: 6),
            progressContainer.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, constant: -60)
        ])
    }

    private func setupCloseButton() {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        let image = UIImage(systemName: "xmark", withConfiguration: config)
        
        button.setImage(image, for: .normal)
        button.tintColor = .secondaryLabel
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 14
        button.alpha = 0
        
        self.floatingCloseButton = button
        modalCardView.addSubview(button)
        button.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: modalCardView.topAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: modalCardView.trailingAnchor, constant: -16),
            button.widthAnchor.constraint(equalToConstant: 28),
            button.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                self.modalCardCenterYConstraint.constant = 0
                self.floatingCloseButton?.alpha = 1
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
        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0 / 500.0
        
        let flipAnim = CABasicAnimation(keyPath: "transform")
        flipAnim.fromValue = NSValue(caTransform3D: CATransform3DRotate(perspective, 0, 0, 1, 0))
        flipAnim.toValue = NSValue(caTransform3D: CATransform3DRotate(perspective, .pi * 2, 0, 1, 0))
        flipAnim.duration = 1.2
        flipAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let scaleAnim = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnim.values = [1.0, 1.08, 1.0]
        scaleAnim.keyTimes = [0, 0.5, 1.0]
        scaleAnim.duration = 1.2
        
        let group = CAAnimationGroup()
        group.animations = [flipAnim, scaleAnim]
        group.duration = 1.2
        
        largeIconBackgroundView.layer.add(group, forKey: "fitnessFlip")
        
        if badge.isUnlocked(userXP: UserStats.shared.xp, stats: JourneyModel.shared) {
            createConfetti()
        }
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
    }
    func configureUI() {
        guard let badge = badge else {
            print("ERROR: Badge data is missing for modal configuration.")
            return
        }
        titleLabel.text = badge.title
        reasonLabel.text = badge.unlockReason
        
        let userXP = UserStats.shared.xp
        let journeyStats = JourneyModel.shared
        let unlocked = badge.isUnlocked(userXP: userXP, stats: journeyStats)

        let progress = badge.calculateProgress(userXP: userXP, stats: journeyStats)
        progressView.setProgress(progress, animated: false)
        progressLabel.text = badge.getProgressText(userXP: userXP, stats: journeyStats)
        
        // Large Icon Handling
        if badge.isCustomImage {
            let originalImage = UIImage(named: badge.iconName)
            if !unlocked {
                largeIconImageView.image = originalImage?.grayscale()
                largeIconImageView.alpha = 0.6
            } else {
                largeIconImageView.image = originalImage
                largeIconImageView.alpha = 1.0
            }
            largeIconImageView.tintColor = nil
            largeIconImageView.contentMode = .scaleAspectFit
            
            // Standardized scale to prevent layout distortion
            largeIconImageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        } else {
            // Standard symbols should be centered and not too huge
            let config = UIImage.SymbolConfiguration(pointSize: 60, weight: .bold)
            largeIconImageView.image = UIImage(systemName: badge.systemIconName, withConfiguration: config)
            largeIconImageView.tintColor = unlocked ? .white : .systemGray2
            largeIconImageView.contentMode = .center
            largeIconImageView.transform = .identity
        }
        
        largeIconImageView.clipsToBounds = false
        largeIconBackgroundView.clipsToBounds = false
        
        stylePremiumBadgeContainer(isUnlocked: unlocked)
        
        if unlocked {
            startPremiumAnimations()
            titleLabel.alpha = 1.0
            reasonLabel.alpha = 1.0
            largeIconBackgroundView.alpha = 1.0
        } else {
            largeIconImageView.layer.removeAllAnimations()
            largeIconBackgroundView.layer.removeAllAnimations()
            titleLabel.alpha = 0.5
            reasonLabel.alpha = 0.5
            largeIconBackgroundView.alpha = 0.7
        }
    }

    private func stylePremiumBadgeContainer(isUnlocked: Bool) {
        largeIconBackgroundView.layer.cornerRadius = largeIconBackgroundView.frame.height / 2
        largeIconBackgroundView.layer.cornerCurve = .continuous
        
        if badge.isCustomImage {
            // Completely transparent container for custom assets
            largeIconBackgroundView.backgroundColor = .clear
            largeIconBackgroundView.layer.shadowOpacity = 0
            return 
        }
        
        if isUnlocked {
            // Gradient Background only for standard symbols
            let gradient = CAGradientLayer()
            gradient.frame = largeIconBackgroundView.bounds
            gradient.colors = [
                UIColor(hex: "#1fa5a1").cgColor,
                UIColor(hex: "#15716E").cgColor
            ]
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 1)
            gradient.cornerRadius = largeIconBackgroundView.frame.height / 2
            largeIconBackgroundView.layer.insertSublayer(gradient, at: 0)
            
            largeIconBackgroundView.layer.shadowColor = UIColor(hex: "#1fa5a1").cgColor
            largeIconBackgroundView.layer.shadowOpacity = 0.5
            largeIconBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 12)
            largeIconBackgroundView.layer.shadowRadius = 16
        } else {
            largeIconBackgroundView.backgroundColor = .systemGray4
            largeIconBackgroundView.layer.shadowOpacity = 0.1
        }
    }

    private func startPremiumAnimations() {
        // Clear any existing animations first
        largeIconImageView.layer.removeAllAnimations()
        largeIconBackgroundView.layer.removeAllAnimations()
        
        startFloatingAnimation()
        startPulseGlow()
        startSlowRotation() // New 360 rotation
    }

    private func startFloatingAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.translation.y")
        animation.fromValue = 0
        animation.toValue = -20
        animation.duration = 2.5
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        largeIconImageView.layer.add(animation, forKey: "floating")
    }

    private func startPulseGlow() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 1.05
        animation.duration = 1.5
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        largeIconImageView.layer.add(animation, forKey: "pulse")
    }

    private func startSlowRotation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.duration = 12.0 // Very slow and elegant
        animation.repeatCount = .infinity
        largeIconImageView.layer.add(animation, forKey: "slowRotation")
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

// MARK: - UIImage Extension for Grayscale
extension UIImage {
    func grayscale() -> UIImage? {
        let context = CIContext(options: nil)
        guard let currentFilter = CIFilter(name: "CIPhotoEffectMono") else { return nil }
        currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        if let output = currentFilter.outputImage,
           let cgImage = context.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
}
