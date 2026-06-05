import UIKit

class roadmapScrollCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var subtitleLabel: UILabel?
    @IBOutlet weak var circularProgressContainer: UIView?
    @IBOutlet weak var percentageLabel: UILabel?
    @IBOutlet weak var milestoneValueLabel: UILabel?

    private let shapeLayer  = CAShapeLayer()
    private let trackLayer  = CAShapeLayer()

    private let card        = UIView()
    private let titleLbl    = UILabel()
    private let subtitleLbl = UILabel()
    private let pctLbl      = UILabel()
    private let milestoneLbl = UILabel()
    private let ringContainer = UIView()

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

        // Left text
        titleLbl.font = .systemFont(ofSize: 18, weight: .bold)
        titleLbl.textColor = .textPrimary
        titleLbl.numberOfLines = 2

        subtitleLbl.font = .systemFont(ofSize: 12, weight: .regular)
        subtitleLbl.textColor = .textSecondary
        subtitleLbl.numberOfLines = 1

        let milestoneIcon = UIImageView(image: UIImage(systemName: "flag.fill"))
        milestoneIcon.tintColor = .accentTeal
        milestoneIcon.contentMode = .scaleAspectFit
        milestoneIcon.widthAnchor.constraint(equalToConstant: 12).isActive = true
        milestoneIcon.heightAnchor.constraint(equalToConstant: 12).isActive = true

        milestoneLbl.font = .systemFont(ofSize: 11, weight: .semibold)
        milestoneLbl.textColor = .accentTeal
        milestoneLbl.numberOfLines = 1

        let milestoneRow = UIStackView(arrangedSubviews: [milestoneIcon, milestoneLbl])
        milestoneRow.axis = .horizontal; milestoneRow.spacing = 5; milestoneRow.alignment = .center

        let leftStack = UIStackView(arrangedSubviews: [titleLbl, subtitleLbl, milestoneRow])
        leftStack.axis = .vertical; leftStack.spacing = 6; leftStack.alignment = .leading

        // Ring
        ringContainer.backgroundColor = .clear
        pctLbl.font = .systemFont(ofSize: 15, weight: .heavy)
        pctLbl.textColor = .textPrimary
        pctLbl.textAlignment = .center
        ringContainer.addSubview(pctLbl)
        pctLbl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pctLbl.centerXAnchor.constraint(equalTo: ringContainer.centerXAnchor),
            pctLbl.centerYAnchor.constraint(equalTo: ringContainer.centerYAnchor),
        ])

        let hStack = UIStackView(arrangedSubviews: [leftStack, UIView(), ringContainer])
        hStack.axis = .horizontal; hStack.spacing = 16; hStack.alignment = .center

        card.addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        ringContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 18),
            hStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            hStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            hStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -18),
            ringContainer.widthAnchor.constraint(equalToConstant: 72),
            ringContainer.heightAnchor.constraint(equalToConstant: 72),
        ])
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        card.layer.borderColor = UIColor.cardBorder.cgColor
        trackLayer.strokeColor = UIColor.progressTrackBg.cgColor
    }

    // Ring drawing
    override func layoutSubviews() {
        super.layoutSubviews()
        drawRingIfNeeded()
    }

    private var didDrawRing = false
    private func drawRingIfNeeded() {
        guard !didDrawRing, ringContainer.bounds.width > 0 else { return }
        didDrawRing = true

        let centre = CGPoint(x: ringContainer.bounds.midX, y: ringContainer.bounds.midY)
        let radius = ringContainer.bounds.width / 2 - 6
        let start  = -CGFloat.pi / 2
        let end    = start + 2 * .pi
        let path   = UIBezierPath(arcCenter: centre, radius: radius, startAngle: start, endAngle: end, clockwise: true)

        trackLayer.path        = path.cgPath
        trackLayer.strokeColor = UIColor.progressTrackBg.cgColor
        trackLayer.lineWidth   = 7
        trackLayer.fillColor   = UIColor.clear.cgColor
        trackLayer.lineCap     = .round
        ringContainer.layer.addSublayer(trackLayer)

        shapeLayer.path        = path.cgPath
        shapeLayer.strokeColor = UIColor.accentTeal.cgColor
        shapeLayer.lineWidth   = 7
        shapeLayer.fillColor   = UIColor.clear.cgColor
        shapeLayer.lineCap     = .round
        shapeLayer.strokeEnd   = 0
        ringContainer.layer.addSublayer(shapeLayer)
    }

    func configure(title: String, subtitle: String, percentage: Int, milestone: String) {
        titleLbl.text     = title
        subtitleLbl.text  = subtitle
        pctLbl.text       = "\(percentage)%"
        milestoneLbl.text = milestone

        let pct = CGFloat(percentage) / 100.0
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.toValue              = pct
        anim.duration             = 0.9
        anim.timingFunction       = CAMediaTimingFunction(name: .easeOut)
        anim.fillMode             = .forwards
        anim.isRemovedOnCompletion = false
        shapeLayer.add(anim, forKey: "progress")
    }
}
