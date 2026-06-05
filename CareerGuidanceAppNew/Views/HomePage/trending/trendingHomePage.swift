import UIKit

class trendingHomePage: UICollectionViewCell {

    @IBOutlet weak var trendingIcon: UIImageView!
    @IBOutlet weak var trendingLabel: UILabel!
    @IBOutlet weak var trendingDesc: UILabel!

    private let card = UIView()
    private let imageView = UIImageView()
    private let gradientLayer = CAGradientLayer()
    private let titleLbl = UILabel()
    private let descLbl = UILabel()
    private let tagBadge = UIView()
    private let tagLabel = UILabel()

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

        // Image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor { tc in
            tc.userInterfaceStyle == .dark ? UIColor(white: 0.12, alpha: 1) : UIColor(hex: "EEFAFA")
        }
        card.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // Gradient overlay
        let overlay = UIView()
        overlay.isUserInteractionEnabled = false
        card.addSubview(overlay)
        overlay.translatesAutoresizingMaskIntoConstraints = false

        // Tag
        tagBadge.backgroundColor = UIColor.accentTeal.withAlphaComponent(0.85)
        tagBadge.layer.cornerRadius = 8
        tagBadge.clipsToBounds = true
        tagLabel.text = "Trending"
        tagLabel.font = .systemFont(ofSize: 10, weight: .bold)
        tagLabel.textColor = .white
        tagBadge.addSubview(tagLabel)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(tagBadge)
        tagBadge.translatesAutoresizingMaskIntoConstraints = false

        // Text
        titleLbl.font = .systemFont(ofSize: 16, weight: .bold)
        titleLbl.textColor = .textPrimary
        titleLbl.numberOfLines = 1

        descLbl.font = .systemFont(ofSize: 12, weight: .regular)
        descLbl.textColor = .textSecondary
        descLbl.numberOfLines = 2

        let textStack = UIStackView(arrangedSubviews: [titleLbl, descLbl])
        textStack.axis = .vertical
        textStack.spacing = 4
        card.addSubview(textStack)
        textStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: card.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: card.heightAnchor, multiplier: 0.58),
            overlay.topAnchor.constraint(equalTo: card.topAnchor),
            overlay.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            overlay.heightAnchor.constraint(equalTo: card.heightAnchor, multiplier: 0.58),
            tagBadge.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            tagBadge.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            tagLabel.topAnchor.constraint(equalTo: tagBadge.topAnchor, constant: 4),
            tagLabel.bottomAnchor.constraint(equalTo: tagBadge.bottomAnchor, constant: -4),
            tagLabel.leadingAnchor.constraint(equalTo: tagBadge.leadingAnchor, constant: 8),
            tagLabel.trailingAnchor.constraint(equalTo: tagBadge.trailingAnchor, constant: -8),
            textStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            textStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
            textStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
            textStack.bottomAnchor.constraint(lessThanOrEqualTo: card.bottomAnchor, constant: -12),
        ])

        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.55).cgColor]
        gradientLayer.locations = [0.3, 1.0]
        overlay.layer.addSublayer(gradientLayer)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        card.layer.borderColor = UIColor.cardBorder.cgColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = imageView.bounds
    }

    func configure(item: Roadmap) {
        titleLbl.text = item.title
        descLbl.text = item.description
        imageView.image = UIImage(named: item.imageName)
    }
}
