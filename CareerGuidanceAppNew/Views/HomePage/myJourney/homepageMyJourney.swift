import UIKit

class homepageMyJourney: UICollectionViewCell {

    @IBOutlet weak var overviewLabel: UILabel?
    @IBOutlet weak var overviewIcon: UIImageView?
    @IBOutlet weak var row1ImageView: UIImageView?
    @IBOutlet weak var row2ImageView: UIImageView?
    @IBOutlet weak var row3ImageView: UIImageView?
    @IBOutlet weak var row1ValueLabel: UILabel!
    @IBOutlet weak var row2ValueLabel: UILabel!
    @IBOutlet weak var row3ValueLabel: UILabel!
    @IBOutlet weak var chevronImageView: UIButton!

    var onChevronTapped: (() -> Void)?

    private let card = UIView()
    private let v1 = UILabel()
    private let v2 = UILabel()
    private let v3 = UILabel()

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

        // Header
        let headerIcon = UIImageView(image: UIImage(systemName: "chart.line.uptrend.xyaxis"))
        headerIcon.tintColor = .accentTeal
        headerIcon.contentMode = .scaleAspectFit
        headerIcon.setContentHuggingPriority(.required, for: .horizontal)
        headerIcon.widthAnchor.constraint(equalToConstant: 17).isActive = true
        headerIcon.heightAnchor.constraint(equalToConstant: 17).isActive = true

        let headerLabel = UILabel()
        headerLabel.text = "My Journey"
        headerLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        headerLabel.textColor = .accentTeal

        let arrowIcon = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrowIcon.tintColor = .textSecondary
        arrowIcon.contentMode = .scaleAspectFit
        arrowIcon.setContentHuggingPriority(.required, for: .horizontal)
        arrowIcon.widthAnchor.constraint(equalToConstant: 13).isActive = true

        let headerRow = UIStackView(arrangedSubviews: [headerIcon, headerLabel, UIView(), arrowIcon])
        headerRow.axis = .horizontal
        headerRow.spacing = 8
        headerRow.alignment = .center
        headerRow.isUserInteractionEnabled = true
        headerRow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chevronTapped)))

        let divider = UIView()
        divider.backgroundColor = .dividerColor
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true

        let r1 = makeRow(icon: "calendar", title: "Learning Days", subtitle: "Consistency matters", valLabel: v1, color: UIColor(hex: "4A90D9"))
        let r2 = makeRow(icon: "checkmark.circle.fill", title: "Quizzes Taken", subtitle: "Knowledge is power", valLabel: v2, color: UIColor(hex: "1fa5a1"))
        let r3 = makeRow(icon: "trophy.fill", title: "Modules Done", subtitle: "Keep the momentum!", valLabel: v3, color: UIColor(hex: "F5A623"))

        let mainStack = UIStackView(arrangedSubviews: [headerRow, divider, r1, r2, r3])
        mainStack.axis = .vertical
        mainStack.spacing = 14
        mainStack.alignment = .fill

        card.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
        ])
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        card.layer.borderColor = UIColor.cardBorder.cgColor
    }

    private func makeRow(icon: String, title: String, subtitle: String, valLabel: UILabel, color: UIColor) -> UIView {
        let iconBg = UIView()
        iconBg.backgroundColor = UIColor.iconBubbleBg(color)
        iconBg.layer.cornerRadius = 11
        iconBg.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([iconBg.widthAnchor.constraint(equalToConstant: 38), iconBg.heightAnchor.constraint(equalToConstant: 38)])

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = color
        iconView.contentMode = .scaleAspectFit
        iconBg.addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: iconBg.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconBg.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 17),
            iconView.heightAnchor.constraint(equalToConstant: 17),
        ])

        let titleLbl = UILabel()
        titleLbl.text = title
        titleLbl.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLbl.textColor = .textPrimary

        let subLbl = UILabel()
        subLbl.text = subtitle
        subLbl.font = .systemFont(ofSize: 11, weight: .regular)
        subLbl.textColor = .textSecondary

        let textStack = UIStackView(arrangedSubviews: [titleLbl, subLbl])
        textStack.axis = .vertical
        textStack.spacing = 2

        valLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        valLabel.textColor = .textPrimary
        valLabel.textAlignment = .right
        valLabel.text = "0"
        valLabel.isHidden = false
        valLabel.removeFromSuperview()
        valLabel.setContentHuggingPriority(.required, for: .horizontal)

        let row = UIStackView(arrangedSubviews: [iconBg, textStack, UIView(), valLabel])
        row.axis = .horizontal
        row.spacing = 12
        row.alignment = .center
        return row
    }

    @objc private func chevronTapped() { onChevronTapped?() }

    func configure(days: String, quizzes: String, quests: String) {
        v1.text = days; v2.text = quizzes; v3.text = quests
        row1ValueLabel?.text = days; row2ValueLabel?.text = quizzes; row3ValueLabel?.text = quests
    }
}
