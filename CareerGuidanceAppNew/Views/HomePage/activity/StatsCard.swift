import UIKit

// MARK: - Stats Card (Pure Code — No XIB)
class StatsCard: UICollectionViewCell {

    @IBOutlet weak var activityIcon: UIImageView?
    @IBOutlet weak var activityTitle: UILabel?
    @IBOutlet weak var xpTitle: UILabel?
    @IBOutlet weak var xpValue: UILabel?
    @IBOutlet weak var streakTitle: UILabel?
    @IBOutlet weak var streakValue: UILabel?
    @IBOutlet weak var badgeTitle: UILabel?
    @IBOutlet weak var badgeValue: UILabel?

    private let card = UIView()
    private let accentLine = UIView()
    private let headerLabel = UILabel()
    private let sparkIcon = UIImageView()
    private let xpValLabel = UILabel()
    private let streakValLabel = UILabel()
    private let badgeValLabel = UILabel()

    override init(frame: CGRect) { super.init(frame: frame); build() }
    required init?(coder: NSCoder) { super.init(coder: coder) }
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.subviews.forEach { $0.isHidden = true }
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

        // Teal accent top bar
        accentLine.backgroundColor = .accentTeal
        accentLine.layer.cornerRadius = 2
        card.addSubview(accentLine)
        accentLine.translatesAutoresizingMaskIntoConstraints = false

        // Header
        sparkIcon.image = UIImage(systemName: "sparkles")
        sparkIcon.tintColor = .accentTeal
        sparkIcon.contentMode = .scaleAspectFit

        headerLabel.text = "Activity"
        headerLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        headerLabel.textColor = .accentTeal

        let headerStack = UIStackView(arrangedSubviews: [sparkIcon, headerLabel])
        headerStack.axis = .horizontal
        headerStack.spacing = 6
        headerStack.alignment = .center
        card.addSubview(headerStack)
        headerStack.translatesAutoresizingMaskIntoConstraints = false

        let divider = UIView()
        divider.backgroundColor = .dividerColor
        card.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false

        // Stats
        let xpCol = makeStatColumn(valLabel: xpValLabel, title: "XP Points", icon: "star.fill", color: .systemYellow)
        let streakCol = makeStatColumn(valLabel: streakValLabel, title: "Day Streak", icon: "flame.fill", color: UIColor(hex: "FF6B35"))
        let badgeCol = makeStatColumn(valLabel: badgeValLabel, title: "Badges", icon: "shield.lefthalf.filled", color: UIColor(hex: "B56FE8"))

        let sep1 = makeDivider()
        let sep2 = makeDivider()

        let statsStack = UIStackView(arrangedSubviews: [xpCol, sep1, streakCol, sep2, badgeCol])
        statsStack.axis = .horizontal
        statsStack.distribution = .equalCentering
        statsStack.alignment = .center
        card.addSubview(statsStack)
        statsStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            accentLine.topAnchor.constraint(equalTo: card.topAnchor),
            accentLine.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            accentLine.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            accentLine.heightAnchor.constraint(equalToConstant: 3),
            headerStack.topAnchor.constraint(equalTo: accentLine.bottomAnchor, constant: 16),
            headerStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            sparkIcon.widthAnchor.constraint(equalToConstant: 18),
            sparkIcon.heightAnchor.constraint(equalToConstant: 18),
            divider.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 14),
            divider.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            divider.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            divider.heightAnchor.constraint(equalToConstant: 1),
            statsStack.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 16),
            statsStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            statsStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            statsStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
            sep1.widthAnchor.constraint(equalToConstant: 1),
            sep1.heightAnchor.constraint(equalToConstant: 36),
            sep2.widthAnchor.constraint(equalToConstant: 1),
            sep2.heightAnchor.constraint(equalToConstant: 36),
        ])
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        card.layer.borderColor = UIColor.cardBorder.cgColor
    }

    private func makeDivider() -> UIView {
        let v = UIView()
        v.backgroundColor = .dividerColor
        return v
    }

    private func makeStatColumn(valLabel: UILabel, title: String, icon: String, color: UIColor) -> UIView {
        let iconView = UIImageView(image: UIImage(systemName: icon, withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)))
        iconView.tintColor = color
        iconView.contentMode = .scaleAspectFit
        iconView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 18).isActive = true

        valLabel.font = .systemFont(ofSize: 26, weight: .heavy)
        valLabel.textColor = .textPrimary
        valLabel.textAlignment = .center
        valLabel.text = "0"

        let titleLbl = UILabel()
        titleLbl.text = title
        titleLbl.font = .systemFont(ofSize: 11, weight: .medium)
        titleLbl.textColor = .textSecondary
        titleLbl.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [iconView, valLabel, titleLbl])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }

    func configure(with stats: UserStats) {
        let isComplete = OnboardingManager.shared.isOnboardingCompleted
        let xp = isComplete ? stats.xp : 100
        let streak = isComplete ? stats.streak : 1
        let badges = isComplete ? calcBadges() : 1
        xpValLabel.text = "\(xp)"
        streakValLabel.text = "\(streak)"
        badgeValLabel.text = "\(badges)"
    }

    private func calcBadges() -> Int {
        var count = 0
        for section in allBadgeSections {
            for badge in section.badges {
                if badge.isUnlocked(userXP: UserStats.shared.xp, stats: JourneyModel.shared) { count += 1 }
            }
        }
        return count
    }
}
