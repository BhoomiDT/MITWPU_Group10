import UIKit

class viewBadges: UICollectionViewCell {

    @IBOutlet weak var badgesChevron: UIButton?
    @IBOutlet weak var badgesIcon: UIImageView?
    var onChevronTapped: (() -> Void)?
    private let card = UIView()

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
        card.layer.cornerRadius = 18
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor.cardBorder.cgColor
        card.clipsToBounds = true
        contentView.addSubview(card)
        card.pin(to: contentView)

        let iconBg = makeIconBubble(systemName: "shield.lefthalf.filled.badge.checkmark", color: UIColor(hex: "B56FE8"))
        let titleLabel = UILabel()
        titleLabel.text = "Badges & Rewards"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .textPrimary

        let subLabel = UILabel()
        subLabel.text = "Your achievements"
        subLabel.font = .systemFont(ofSize: 12, weight: .regular)
        subLabel.textColor = .textSecondary

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subLabel])
        textStack.axis = .vertical; textStack.spacing = 2

        let arrow = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrow.tintColor = .textSecondary
        arrow.contentMode = .scaleAspectFit
        arrow.widthAnchor.constraint(equalToConstant: 14).isActive = true

        let row = UIStackView(arrangedSubviews: [iconBg, textStack, UIView(), arrow])
        row.axis = .horizontal; row.spacing = 14; row.alignment = .center

        card.addSubview(row)
        row.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            row.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            row.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            row.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
        ])
        card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        card.layer.borderColor = UIColor.cardBorder.cgColor
    }

    private func makeIconBubble(systemName: String, color: UIColor) -> UIView {
        let bg = UIView()
        bg.backgroundColor = UIColor.iconBubbleBg(color)
        bg.layer.cornerRadius = 14
        let img = UIImageView(image: UIImage(systemName: systemName))
        img.tintColor = color; img.contentMode = .scaleAspectFit
        bg.addSubview(img)
        img.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            img.centerXAnchor.constraint(equalTo: bg.centerXAnchor),
            img.centerYAnchor.constraint(equalTo: bg.centerYAnchor),
            img.widthAnchor.constraint(equalToConstant: 20),
            img.heightAnchor.constraint(equalToConstant: 20),
            bg.widthAnchor.constraint(equalToConstant: 46),
            bg.heightAnchor.constraint(equalToConstant: 46),
        ])
        return bg
    }

    @objc private func tapped() { onChevronTapped?() }
    @IBAction func badgesOpen(_ sender: Any) { onChevronTapped?() }
}
