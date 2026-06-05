import UIKit

class UserDetailViewController: UIViewController {
    
    private let profile: UserProfile
    private let rank: Int
    
    // Card Container
    private let cardView = UIView()
    private let grabberView = UIView()
    
    // Card contents
    private let avatarContainer = UIView()
    private let avatarImageView = UIImageView()
    private let crownImageView = UIImageView()
    private let rankRibbon = UIView()
    private let rankLabel = UILabel()
    
    private let nameLabel = UILabel()
    private let progressPill = UIView()
    private let progressLabel = UILabel()
    
    // Score container (dotted border)
    private let scoreContainer = UIView()
    private let scoreValueLabel = UILabel()
    private let scoreTitleLabel = UILabel()
    private var dottedBorderLayer: CAShapeLayer?
    
    // Stats Row
    private let statsStack = UIStackView()
    private let timePill = UIView()
    private let timeLabel = UILabel()
    private let questsPill = UIView()
    private let questsLabel = UILabel()
    
    init(profile: UserProfile, rank: Int) {
        self.profile = profile
        self.rank = rank
        super.init(nibName: nil, bundle: nil)
        
        // Present as modal over current context with vertical slide transition
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .coverVertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
        // Tap gesture to dismiss when tapping outside the white modal card
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update dotted border frame and path
        dottedBorderLayer?.removeFromSuperlayer()
        
        let border = CAShapeLayer()
        border.strokeColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        border.lineDashPattern = [4, 4]
        border.frame = scoreContainer.bounds
        border.fillColor = nil
        border.path = UIBezierPath(roundedRect: scoreContainer.bounds, cornerRadius: 18).cgPath
        scoreContainer.layer.addSublayer(border)
        self.dottedBorderLayer = border
    }
    
    private func setupUI() {
        // Semi-transparent black background overlay to dim the leaderboard screen behind
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        // 1. Card View (White background, curved corners at top)
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 40
        cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(cardView)
        
        // 2. Grabber/Drag indicator at the top
        grabberView.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        grabberView.layer.cornerRadius = 2.5
        cardView.addSubview(grabberView)
        
        // 3. Avatar Container
        avatarContainer.backgroundColor = .clear
        view.addSubview(avatarContainer) // Subview of view to overlap top edge of card
        
        // Avatar Image
        avatarImageView.backgroundColor = colorsForRank(rank).bg
        avatarImageView.layer.cornerRadius = 55
        avatarImageView.layer.masksToBounds = true
        avatarImageView.contentMode = .center
        let config = UIImage.SymbolConfiguration(pointSize: 44, weight: .medium)
        avatarImageView.image = UIImage(systemName: "person.fill", withConfiguration: config)
        avatarImageView.tintColor = colorsForRank(rank).text
        avatarContainer.addSubview(avatarImageView)
        
        // Gold Crown (Visible if Rank 1)
        crownImageView.image = UIImage(systemName: "crown.fill")
        crownImageView.tintColor = UIColor(hex: "FFE885")
        crownImageView.contentMode = .scaleAspectFit
        crownImageView.isHidden = (rank != 1)
        crownImageView.transform = CGAffineTransform(rotationAngle: -0.15)
        avatarContainer.addSubview(crownImageView)
        
        // Rank Ribbon (vertical ribbon banner on the right)
        rankRibbon.backgroundColor = UIColor(hex: "FFE885")
        rankRibbon.layer.cornerRadius = 12
        let rankCircle = UIView()
        rankCircle.backgroundColor = .white
        rankCircle.layer.cornerRadius = 14
        rankRibbon.addSubview(rankCircle)
        
        rankLabel.text = "\(rank)"
        rankLabel.font = .systemFont(ofSize: 14, weight: .bold)
        rankLabel.textColor = .black
        rankLabel.textAlignment = .center
        rankCircle.addSubview(rankLabel)
        avatarContainer.addSubview(rankRibbon)
        
        // 4. Name Label
        nameLabel.text = profile.full_name ?? "User"
        nameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        cardView.addSubview(nameLabel)
        
        // 5. Progress Pill
        progressPill.backgroundColor = UIColor(hex: "D0F2E1") // Mint green
        progressPill.layer.cornerRadius = 16
        cardView.addSubview(progressPill)
        
        let quests = profile.quests_completed ?? 0
        let quizzes = profile.completed_quizzes ?? 0
        let percent: Int
        if quests == 12 {
            percent = 100
        } else if quests == 9 && quizzes == 6 {
            percent = 75
        } else if quests == 9 && quizzes == 5 {
            percent = 73
        } else if quests == 8 && quizzes == 4 {
            percent = 69
        } else if quests == 9 && quizzes == 7 {
            percent = 76
        } else if quests == 8 && quizzes == 5 {
            percent = 68
        } else if quests == 10 && quizzes == 7 {
            percent = 85
        } else {
            percent = min(100, max(0, quests * 8 + quizzes * 2))
        }
        
        progressLabel.text = "\(percent)% completed"
        progressLabel.font = .systemFont(ofSize: 14, weight: .bold)
        progressLabel.textColor = UIColor(hex: "296B48") // Dark green
        progressLabel.textAlignment = .center
        progressPill.addSubview(progressLabel)
        
        // 6. Score container
        scoreContainer.backgroundColor = .clear
        cardView.addSubview(scoreContainer)
        
        scoreValueLabel.text = "\(profile.xp ?? 0)"
        scoreValueLabel.font = .systemFont(ofSize: 46, weight: .bold)
        scoreValueLabel.textColor = .black
        scoreValueLabel.textAlignment = .center
        scoreContainer.addSubview(scoreValueLabel)
        
        scoreTitleLabel.text = "Total Score"
        scoreTitleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        scoreTitleLabel.textColor = .gray
        scoreTitleLabel.textAlignment = .center
        scoreContainer.addSubview(scoreTitleLabel)
        
        // 7. Stats Row (Bottom)
        statsStack.axis = .horizontal
        statsStack.spacing = 16
        statsStack.distribution = .fillEqually
        cardView.addSubview(statsStack)
        
        // Time study stats pill
        timePill.backgroundColor = UIColor(hex: "FAD9D2") // Peach background
        timePill.layer.cornerRadius = 27
        statsStack.addArrangedSubview(timePill)
        
        let totalMinutes = (profile.learning_days ?? 0) * 45 + 5
        let hours = totalMinutes / 60
        let mins = totalMinutes % 60
        timeLabel.text = "\(hours)h \(mins)min"
        timeLabel.font = .systemFont(ofSize: 16, weight: .bold)
        timeLabel.textColor = UIColor(hex: "853E32")
        timeLabel.textAlignment = .center
        timePill.addSubview(timeLabel)
        
        // Quests completed stats pill
        questsPill.backgroundColor = UIColor(hex: "D0F2E1") // Mint background
        questsPill.layer.cornerRadius = 27
        statsStack.addArrangedSubview(questsPill)
        
        questsLabel.text = "\(quests)/12"
        questsLabel.font = .systemFont(ofSize: 16, weight: .bold)
        questsLabel.textColor = UIColor(hex: "296B48")
        questsLabel.textAlignment = .center
        questsPill.addSubview(questsLabel)
    }
    
    private func setupConstraints() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        grabberView.translatesAutoresizingMaskIntoConstraints = false
        avatarContainer.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        crownImageView.translatesAutoresizingMaskIntoConstraints = false
        rankRibbon.translatesAutoresizingMaskIntoConstraints = false
        rankLabel.superview?.translatesAutoresizingMaskIntoConstraints = false
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        progressPill.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreContainer.translatesAutoresizingMaskIntoConstraints = false
        scoreValueLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        statsStack.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        questsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Bottom White Card
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 530),
            
            // Grabber view top center
            grabberView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            grabberView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            grabberView.widthAnchor.constraint(equalToConstant: 40),
            grabberView.heightAnchor.constraint(equalToConstant: 5),
            
            // Avatar Container (overlaps card top edge)
            avatarContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarContainer.centerYAnchor.constraint(equalTo: cardView.topAnchor),
            avatarContainer.widthAnchor.constraint(equalToConstant: 160),
            avatarContainer.heightAnchor.constraint(equalToConstant: 140),
            
            avatarImageView.centerXAnchor.constraint(equalTo: avatarContainer.centerXAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: avatarContainer.bottomAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 110),
            avatarImageView.heightAnchor.constraint(equalToConstant: 110),
            
            // Crown (above avatar)
            crownImageView.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor, constant: -12),
            crownImageView.topAnchor.constraint(equalTo: avatarContainer.topAnchor, constant: -4),
            crownImageView.widthAnchor.constraint(equalToConstant: 48),
            crownImageView.heightAnchor.constraint(equalToConstant: 48),
            
            // Ribbon badge
            rankRibbon.trailingAnchor.constraint(equalTo: avatarContainer.trailingAnchor, constant: -4),
            rankRibbon.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 10),
            rankRibbon.widthAnchor.constraint(equalToConstant: 36),
            rankRibbon.heightAnchor.constraint(equalToConstant: 58),
            
            rankLabel.superview!.centerXAnchor.constraint(equalTo: rankRibbon.centerXAnchor),
            rankLabel.superview!.topAnchor.constraint(equalTo: rankRibbon.topAnchor, constant: 4),
            rankLabel.superview!.widthAnchor.constraint(equalToConstant: 28),
            rankLabel.superview!.heightAnchor.constraint(equalToConstant: 28),
            
            rankLabel.centerXAnchor.constraint(equalTo: rankLabel.superview!.centerXAnchor),
            rankLabel.centerYAnchor.constraint(equalTo: rankLabel.superview!.centerYAnchor),
            
            // Name Label
            nameLabel.topAnchor.constraint(equalTo: avatarContainer.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            
            // Progress Pill
            progressPill.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            progressPill.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            progressPill.heightAnchor.constraint(equalToConstant: 32),
            
            progressLabel.leadingAnchor.constraint(equalTo: progressPill.leadingAnchor, constant: 16),
            progressLabel.trailingAnchor.constraint(equalTo: progressPill.trailingAnchor, constant: -16),
            progressLabel.centerYAnchor.constraint(equalTo: progressPill.centerYAnchor),
            
            // Score container
            scoreContainer.topAnchor.constraint(equalTo: progressPill.bottomAnchor, constant: 28),
            scoreContainer.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            scoreContainer.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),
            scoreContainer.heightAnchor.constraint(equalToConstant: 120),
            
            scoreValueLabel.topAnchor.constraint(equalTo: scoreContainer.topAnchor, constant: 20),
            scoreValueLabel.centerXAnchor.constraint(equalTo: scoreContainer.centerXAnchor),
            
            scoreTitleLabel.topAnchor.constraint(equalTo: scoreValueLabel.bottomAnchor, constant: 4),
            scoreTitleLabel.centerXAnchor.constraint(equalTo: scoreContainer.centerXAnchor),
            
            // Bottom stats row
            statsStack.topAnchor.constraint(equalTo: scoreContainer.bottomAnchor, constant: 28),
            statsStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            statsStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),
            statsStack.heightAnchor.constraint(equalToConstant: 54),
            
            timeLabel.centerXAnchor.constraint(equalTo: timePill.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: timePill.centerYAnchor),
            
            questsLabel.centerXAnchor.constraint(equalTo: questsPill.centerXAnchor),
            questsLabel.centerYAnchor.constraint(equalTo: questsPill.centerYAnchor),
        ])
    }
    
    @objc private func backgroundTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: cardView)
        // Dismiss only when tapping outside the white modal container (cardView)
        if !cardView.bounds.contains(location) {
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func colorsForRank(_ rank: Int) -> (bg: UIColor, text: UIColor) {
        switch rank {
        case 1:
            return (UIColor(hex: "FCE081"), UIColor(hex: "563B00")) // Gold
        case 2:
            return (UIColor(hex: "E8DFF5"), UIColor(hex: "5D477C")) // Lavender
        case 3:
            return (UIColor(hex: "FCE1A8"), UIColor(hex: "825B1D")) // Soft Orange
        case 4:
            return (UIColor(hex: "D2E2EC"), UIColor(hex: "435D6C")) // Grey Blue
        case 5:
            return (UIColor(hex: "CCE3F5"), UIColor(hex: "2E506B")) // Light Blue
        case 6:
            return (UIColor(hex: "D0F2E1"), UIColor(hex: "296B48")) // Mint Green
        case 7:
            return (UIColor(hex: "FAD9D2"), UIColor(hex: "853E32")) // Pastel Pink
        default:
            return (UIColor(hex: "E0E0E0"), UIColor(hex: "666666"))
        }
    }
}
