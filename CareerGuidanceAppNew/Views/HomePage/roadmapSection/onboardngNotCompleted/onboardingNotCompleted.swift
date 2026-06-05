import UIKit

class onboardingNotCompleted: UICollectionViewCell {

    @IBOutlet weak var progressBarOnboarding: UIProgressView!
    @IBOutlet weak var continuePersonalisationButton: UIButton!

    private let card = UIView()
    private let progressTrack = UIView()
    private let progressFill = UIView()
    private let pctLabel = UILabel()
    private let ctaButton = UIButton(type: .custom)
    private var progressFillWidth: NSLayoutConstraint?

    override init(frame: CGRect) { super.init(frame: frame); build() }
    required init?(coder: NSCoder) { super.init(coder: coder) }
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.subviews.forEach { $0.isHidden = true }
        continuePersonalisationButton.isHidden = false
        continuePersonalisationButton.alpha = 0
        build()
    }

    private func build() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        card.backgroundColor = .cardBg
        card.layer.cornerRadius = 22
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor.cardBorder.cgColor
        card.clipsToBounds = true
        contentView.addSubview(card)
        card.pin(to: contentView)

        let headingLabel = UILabel()
        headingLabel.text = "Almost there!"
        headingLabel.font = .systemFont(ofSize: 20, weight: .bold)
        headingLabel.textColor = .textPrimary

        let subLabel = UILabel()
        subLabel.text = "Personalise your roadmap in a few more steps."
        subLabel.font = .systemFont(ofSize: 13, weight: .regular)
        subLabel.textColor = .textSecondary
        subLabel.numberOfLines = 2

        progressTrack.backgroundColor = .progressTrackBg
        progressTrack.layer.cornerRadius = 4
        progressTrack.clipsToBounds = true

        progressFill.backgroundColor = .accentTeal
        progressFill.layer.cornerRadius = 4
        progressTrack.addSubview(progressFill)
        progressFill.translatesAutoresizingMaskIntoConstraints = false

        pctLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        pctLabel.textColor = .accentTeal
        pctLabel.text = "0%"
        pctLabel.setContentHuggingPriority(.required, for: .horizontal)

        let progressRow = UIStackView(arrangedSubviews: [progressTrack, pctLabel])
        progressRow.axis = .horizontal
        progressRow.spacing = 10
        progressRow.alignment = .center

        ctaButton.backgroundColor = .accentTeal
        ctaButton.setTitle("Continue Setup", for: .normal)
        ctaButton.setTitleColor(.white, for: .normal)
        ctaButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        ctaButton.layer.cornerRadius = 14
        ctaButton.clipsToBounds = true
        ctaButton.addTarget(self, action: #selector(ctaTapped), for: .touchUpInside)

        let vStack = UIStackView(arrangedSubviews: [headingLabel, subLabel, progressRow, ctaButton])
        vStack.axis = .vertical
        vStack.spacing = 14

        card.addSubview(vStack)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        ctaButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            vStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            vStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            vStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20),
            progressTrack.heightAnchor.constraint(equalToConstant: 8),
            ctaButton.heightAnchor.constraint(equalToConstant: 48),
            progressFill.topAnchor.constraint(equalTo: progressTrack.topAnchor),
            progressFill.bottomAnchor.constraint(equalTo: progressTrack.bottomAnchor),
            progressFill.leadingAnchor.constraint(equalTo: progressTrack.leadingAnchor),
        ])
        progressFillWidth = progressFill.widthAnchor.constraint(equalToConstant: 0)
        progressFillWidth?.isActive = true
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        card.layer.borderColor = UIColor.cardBorder.cgColor
    }

    @objc private func ctaTapped() {
        continuePersonalisationButton.sendActions(for: .touchUpInside)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let p = progressBarOnboarding { setProgress(p.progress) }
    }

    private func setProgress(_ value: Float) {
        let w = progressTrack.frame.width
        guard w > 0 else { return }
        progressFillWidth?.constant = CGFloat(value) * w
        pctLabel.text = "\(Int(value * 100))%"
    }
}
