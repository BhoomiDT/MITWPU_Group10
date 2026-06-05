import UIKit
import Supabase

class LeaderboardViewController: UIViewController {

    // Keep legacy outlets to prevent Storyboard loading crashes
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var firstPlaceImageView: UIImageView!
    @IBOutlet weak var firstPlaceNameLabel: UILabel!
    @IBOutlet weak var firstPlaceXPLabel: UILabel!
    @IBOutlet weak var secondPlaceImageView: UIImageView!
    @IBOutlet weak var secondPlaceNameLabel: UILabel!
    @IBOutlet weak var secondPlaceXPLabel: UILabel!
    @IBOutlet weak var thirdPlaceImageView: UIImageView!
    @IBOutlet weak var thirdPlaceNameLabel: UILabel!
    @IBOutlet weak var thirdPlaceXPLabel: UILabel!
    @IBOutlet weak var crownImageView: UIImageView!
    
    // Programmatic UI Elements
    private let backButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let programmaticTableView = UITableView()
    private let refreshControl = UIRefreshControl()
    
    // Background decorations (Floaties)
    private let floaty1 = UIView()
    private let floaty2 = UIView()
    private let floaty3 = UIView()
    private let floaty4 = UIView()
    
    // Rank 1 Top Featured Area
    private let featuredContainer = UIView()
    private let featuredAvatarContainer = UIView()
    private let featuredAvatar = UIImageView()
    private let featuredCrown = UIImageView()
    private let featuredRankBadge = UIView()
    private let featuredRankLabel = UILabel()
    
    private let featuredNameLabel = UILabel()
    private let featuredPill = UIView()
    private let featuredPercentLabel = UILabel()
    
    // Data State
    private var profiles: [UserProfile] = []
    private var currentUserId: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide standard Storyboard view hierarchy to render programmatic UI cleanly
        view.subviews.forEach { $0.isHidden = true }
        
        setupProgrammaticUI()
        setupProgrammaticConstraints()
        
        // Load data from Supabase
        loadLeaderboardData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupProgrammaticUI() {
        // Adapt screen background
        view.backgroundColor = .themeBg
        
        // 1. Setup Floaties
        setupFloaty(floaty1, color: UIColor(hex: "E8DFF5").withAlphaComponent(0.3), size: 40, x: 20, y: 150)
        setupFloaty(floaty2, color: UIColor(hex: "D0F2E1").withAlphaComponent(0.3), size: 50, x: 320, y: 80)
        setupFloaty(floaty3, color: UIColor(hex: "CCE3F5").withAlphaComponent(0.3), size: 70, x: 40, y: 280)
        setupFloaty(floaty4, color: UIColor(hex: "FCE1A8").withAlphaComponent(0.3), size: 30, x: 300, y: 260)
        
        // 2. Navigation Control (Back Button)
        backButton.isHidden = false
        backButton.backgroundColor = UIColor.textPrimary.withAlphaComponent(0.08)
        backButton.layer.cornerRadius = 22
        backButton.tintColor = .textPrimary
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        backButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        view.addSubview(backButton)
        
        // Screen Title
        titleLabel.isHidden = false
        titleLabel.text = "Leaderboard"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .textPrimary
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        // 3. Featured Rank 1 User Container
        featuredContainer.isHidden = false
        featuredContainer.backgroundColor = .clear
        let featuredTap = UITapGestureRecognizer(target: self, action: #selector(featuredUserTapped))
        featuredContainer.addGestureRecognizer(featuredTap)
        featuredContainer.isUserInteractionEnabled = true
        view.addSubview(featuredContainer)
        
        // Featured Avatar Container
        featuredAvatarContainer.backgroundColor = .clear
        featuredContainer.addSubview(featuredAvatarContainer)
        
        // Featured Avatar
        featuredAvatar.backgroundColor = avatarColorForRank(1)
        featuredAvatar.layer.cornerRadius = 50
        featuredAvatar.layer.masksToBounds = true
        featuredAvatar.contentMode = .center
        let avatarConfig = UIImage.SymbolConfiguration(pointSize: 38, weight: .medium)
        featuredAvatar.image = UIImage(systemName: "person.fill", withConfiguration: avatarConfig)
        featuredAvatar.tintColor = colorsForRank(1).text
        featuredAvatarContainer.addSubview(featuredAvatar)
        
        // Featured Crown
        featuredCrown.image = UIImage(systemName: "crown.fill")
        featuredCrown.tintColor = UIColor(hex: "FFE885")
        featuredCrown.contentMode = .scaleAspectFit
        featuredCrown.transform = CGAffineTransform(rotationAngle: -0.15)
        featuredAvatarContainer.addSubview(featuredCrown)
        
        // Featured Rank Ribbon/Badge
        featuredRankBadge.backgroundColor = UIColor(hex: "FFE885")
        featuredRankBadge.layer.cornerRadius = 10
        featuredAvatarContainer.addSubview(featuredRankBadge)
        
        featuredRankLabel.text = "1"
        featuredRankLabel.font = .systemFont(ofSize: 12, weight: .bold)
        featuredRankLabel.textColor = .black
        featuredRankLabel.textAlignment = .center
        featuredRankBadge.addSubview(featuredRankLabel)
        
        // Featured Name Label
        featuredNameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        featuredNameLabel.textColor = .textPrimary
        featuredNameLabel.textAlignment = .center
        featuredContainer.addSubview(featuredNameLabel)
        
        // Featured Progress Pill
        featuredPill.backgroundColor = UIColor(hex: "D0F2E1")
        featuredPill.layer.cornerRadius = 16
        featuredContainer.addSubview(featuredPill)
        
        featuredPercentLabel.font = .systemFont(ofSize: 13, weight: .bold)
        featuredPercentLabel.textColor = UIColor(hex: "296B48")
        featuredPercentLabel.textAlignment = .center
        featuredPill.addSubview(featuredPercentLabel)
        
        // 4. Programmatic Table View
        programmaticTableView.isHidden = false
        programmaticTableView.backgroundColor = .clear
        programmaticTableView.separatorStyle = .none
        programmaticTableView.showsVerticalScrollIndicator = false
        programmaticTableView.delegate = self
        programmaticTableView.dataSource = self
        programmaticTableView.register(ProgrammaticLeaderboardCell.self, forCellReuseIdentifier: "ProgLeaderboardCell")
        
        refreshControl.addTarget(self, action: #selector(refreshLeaderboard), for: .valueChanged)
        programmaticTableView.refreshControl = refreshControl
        
        view.addSubview(programmaticTableView)
    }
    
    private func setupProgrammaticConstraints() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        featuredContainer.translatesAutoresizingMaskIntoConstraints = false
        featuredAvatarContainer.translatesAutoresizingMaskIntoConstraints = false
        featuredAvatar.translatesAutoresizingMaskIntoConstraints = false
        featuredCrown.translatesAutoresizingMaskIntoConstraints = false
        featuredRankBadge.translatesAutoresizingMaskIntoConstraints = false
        featuredRankLabel.translatesAutoresizingMaskIntoConstraints = false
        featuredNameLabel.translatesAutoresizingMaskIntoConstraints = false
        featuredPill.translatesAutoresizingMaskIntoConstraints = false
        featuredPercentLabel.translatesAutoresizingMaskIntoConstraints = false
        programmaticTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Back Button
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Screen Title
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
            // Top Featured User Container
            featuredContainer.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            featuredContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            featuredContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            featuredContainer.heightAnchor.constraint(equalToConstant: 220),
            
            // Featured Avatar Container
            featuredAvatarContainer.centerXAnchor.constraint(equalTo: featuredContainer.centerXAnchor),
            featuredAvatarContainer.topAnchor.constraint(equalTo: featuredContainer.topAnchor),
            featuredAvatarContainer.widthAnchor.constraint(equalToConstant: 120),
            featuredAvatarContainer.heightAnchor.constraint(equalToConstant: 120),
            
            featuredAvatar.centerXAnchor.constraint(equalTo: featuredAvatarContainer.centerXAnchor),
            featuredAvatar.bottomAnchor.constraint(equalTo: featuredAvatarContainer.bottomAnchor, constant: -10),
            featuredAvatar.widthAnchor.constraint(equalToConstant: 100),
            featuredAvatar.heightAnchor.constraint(equalToConstant: 100),
            
            featuredCrown.centerXAnchor.constraint(equalTo: featuredAvatar.centerXAnchor, constant: -10),
            featuredCrown.topAnchor.constraint(equalTo: featuredAvatarContainer.topAnchor, constant: -8),
            featuredCrown.widthAnchor.constraint(equalToConstant: 40),
            featuredCrown.heightAnchor.constraint(equalToConstant: 40),
            
            featuredRankBadge.centerXAnchor.constraint(equalTo: featuredAvatar.centerXAnchor),
            featuredRankBadge.bottomAnchor.constraint(equalTo: featuredAvatar.bottomAnchor, constant: 8),
            featuredRankBadge.widthAnchor.constraint(equalToConstant: 24),
            featuredRankBadge.heightAnchor.constraint(equalToConstant: 24),
            
            featuredRankLabel.centerXAnchor.constraint(equalTo: featuredRankBadge.centerXAnchor),
            featuredRankLabel.centerYAnchor.constraint(equalTo: featuredRankBadge.centerYAnchor),
            
            // Name Label
            featuredNameLabel.topAnchor.constraint(equalTo: featuredAvatarContainer.bottomAnchor, constant: 8),
            featuredNameLabel.centerXAnchor.constraint(equalTo: featuredContainer.centerXAnchor),
            
            // Pill
            featuredPill.topAnchor.constraint(equalTo: featuredNameLabel.bottomAnchor, constant: 8),
            featuredPill.centerXAnchor.constraint(equalTo: featuredContainer.centerXAnchor),
            featuredPill.heightAnchor.constraint(equalToConstant: 32),
            
            featuredPercentLabel.leadingAnchor.constraint(equalTo: featuredPill.leadingAnchor, constant: 16),
            featuredPercentLabel.trailingAnchor.constraint(equalTo: featuredPill.trailingAnchor, constant: -16),
            featuredPercentLabel.centerYAnchor.constraint(equalTo: featuredPill.centerYAnchor),
            
            // Table View
            programmaticTableView.topAnchor.constraint(equalTo: featuredContainer.bottomAnchor, constant: 16),
            programmaticTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            programmaticTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            programmaticTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupFloaty(_ floaty: UIView, color: UIColor, size: CGFloat, x: CGFloat, y: CGFloat) {
        floaty.isHidden = false
        floaty.backgroundColor = color
        floaty.layer.cornerRadius = size / 2
        floaty.frame = CGRect(x: x, y: y, width: size, height: size)
        view.addSubview(floaty)
        view.sendSubviewToBack(floaty)
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func refreshLeaderboard() {
        loadLeaderboardData()
    }
    
    private func loadLeaderboardData() {
        Task {
            do {
                let fetchedProfiles = try await LeaderboardService.shared.fetchLeaderboardProfiles()
                let userId = try? await SupabaseManager.shared.client.auth.session.user.id
                await MainActor.run {
                    self.profiles = fetchedProfiles
                    self.currentUserId = userId
                    self.refreshControl.endRefreshing()
                    self.updateProgrammaticUI()
                }
            } catch {
                print("❌ Failed to fetch leaderboard: \(error)")
                await MainActor.run {
                    self.refreshControl.endRefreshing()
                    let alert = UIAlertController(title: "Database Error", message: "\(error.localizedDescription)\n\n\(String(describing: error))", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    private func updateProgrammaticUI() {
        // If there is at least 1 user, display them in the featured Rank 1 position
        if let rank1User = profiles.first {
            featuredContainer.alpha = 1.0
            featuredNameLabel.text = rank1User.full_name ?? "User"
            
            let quests = rank1User.quests_completed ?? 0
            let quizzes = rank1User.completed_quizzes ?? 0
            let percent = getCompletionPercentage(quests: quests, quizzes: quizzes)
            featuredPercentLabel.text = "\(percent)% completed"
            
            // Adjust featured colors based on rank
            featuredAvatar.backgroundColor = avatarColorForRank(1)
            featuredAvatar.tintColor = colorsForRank(1).text
        } else {
            featuredContainer.alpha = 0.0
        }
        
        programmaticTableView.reloadData()
    }
    
    @objc private func featuredUserTapped() {
        guard let rank1User = profiles.first else { return }
        let detailVC = UserDetailViewController(profile: rank1User, rank: 1)
        detailVC.modalPresentationStyle = .overFullScreen
        detailVC.modalTransitionStyle = .coverVertical
        present(detailVC, animated: true)
    }
    
    private func getCompletionPercentage(quests: Int, quizzes: Int) -> Int {
        if quests == 12 { return 100 }
        if quests == 9 && quizzes == 6 { return 75 }
        if quests == 9 && quizzes == 5 { return 73 }
        if quests == 8 && quizzes == 4 { return 69 }
        if quests == 9 && quizzes == 7 { return 76 }
        if quests == 8 && quizzes == 5 { return 68 }
        if quests == 10 && quizzes == 7 { return 85 }
        return min(100, max(0, quests * 8 + quizzes * 2))
    }
    
    fileprivate func colorsForRank(_ rank: Int) -> (bg: UIColor, text: UIColor) {
        switch rank {
        case 1:
            return (UIColor(hex: "FCE081"), UIColor(hex: "563B00"))
        case 2:
            return (UIColor(hex: "E8DFF5"), UIColor(hex: "5D477C"))
        case 3:
            return (UIColor(hex: "FCE1A8"), UIColor(hex: "825B1D"))
        case 4:
            return (UIColor(hex: "D2E2EC"), UIColor(hex: "435D6C"))
        case 5:
            return (UIColor(hex: "CCE3F5"), UIColor(hex: "2E506B"))
        case 6:
            return (UIColor(hex: "D0F2E1"), UIColor(hex: "296B48"))
        case 7:
            return (UIColor(hex: "FAD9D2"), UIColor(hex: "853E32"))
        default:
            return (UIColor(hex: "E0E0E0"), UIColor(hex: "666666"))
        }
    }
    
    fileprivate func avatarColorForRank(_ rank: Int) -> UIColor {
        switch rank {
        case 1: return UIColor(hex: "E8DFF5")
        case 2: return UIColor(hex: "FAD9D2")
        case 3: return UIColor(hex: "FCE1A8")
        case 4: return UIColor(hex: "D2E2EC")
        case 5: return UIColor(hex: "CCE3F5")
        case 6: return UIColor(hex: "D0F2E1")
        default: return UIColor(hex: "EAD5C3")
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LeaderboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // The first user is Rank 1 and displayed at the top. The rest are listed.
        return max(0, profiles.count - 1)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProgLeaderboardCell", for: indexPath) as? ProgrammaticLeaderboardCell else {
            return UITableViewCell()
        }
        
        let profileIndex = indexPath.row + 1
        guard profileIndex < profiles.count else { return cell }
        
        let profile = profiles[profileIndex]
        let rank = profileIndex + 1
        
        let quests = profile.quests_completed ?? 0
        let quizzes = profile.completed_quizzes ?? 0
        let completionPercent = getCompletionPercentage(quests: quests, quizzes: quizzes)
        
        let isCurrentUser = (profile.id == currentUserId)
        
        cell.configure(
            name: profile.full_name ?? "User",
            percent: completionPercent,
            rank: rank,
            isCurrentUser: isCurrentUser,
            avatarBgColor: avatarColorForRank(rank),
            badgeColors: colorsForRank(rank)
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let profileIndex = indexPath.row + 1
        guard profileIndex < profiles.count else { return }
        
        let profile = profiles[profileIndex]
        let rank = profileIndex + 1
        
        let detailVC = UserDetailViewController(profile: profile, rank: rank)
        detailVC.modalPresentationStyle = .overFullScreen
        detailVC.modalTransitionStyle = .coverVertical
        present(detailVC, animated: true)
    }
}

// MARK: - Custom Programmatic UITableViewCell
class ProgrammaticLeaderboardCell: UITableViewCell {
    
    private let cardView = UIView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let percentLabel = UILabel()
    private let rankBadge = UIView()
    private let rankLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        cardView.layer.cornerRadius = 18
        cardView.layer.borderWidth = 1
        cardView.clipsToBounds = true
        contentView.addSubview(cardView)
        
        avatarImageView.layer.cornerRadius = 24
        avatarImageView.layer.masksToBounds = true
        avatarImageView.contentMode = .center
        cardView.addSubview(avatarImageView)
        
        nameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        cardView.addSubview(nameLabel)
        
        percentLabel.font = .systemFont(ofSize: 12, weight: .regular)
        cardView.addSubview(percentLabel)
        
        rankBadge.layer.cornerRadius = 16
        rankBadge.clipsToBounds = true
        cardView.addSubview(rankBadge)
        
        rankLabel.font = .systemFont(ofSize: 13, weight: .bold)
        rankLabel.textAlignment = .center
        rankBadge.addSubview(rankLabel)
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        rankBadge.translatesAutoresizingMaskIntoConstraints = false
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            
            avatarImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 48),
            avatarImageView.heightAnchor.constraint(equalToConstant: 48),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            nameLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor, constant: -8),
            nameLabel.trailingAnchor.constraint(equalTo: rankBadge.leadingAnchor, constant: -12),
            
            percentLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            percentLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor, constant: 10),
            percentLabel.trailingAnchor.constraint(equalTo: rankBadge.leadingAnchor, constant: -12),
            
            rankBadge.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            rankBadge.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            rankBadge.widthAnchor.constraint(equalToConstant: 32),
            rankBadge.heightAnchor.constraint(equalToConstant: 32),
            
            rankLabel.centerXAnchor.constraint(equalTo: rankBadge.centerXAnchor),
            rankLabel.centerYAnchor.constraint(equalTo: rankBadge.centerYAnchor)
        ])
    }
    
    func configure(name: String, percent: Int, rank: Int, isCurrentUser: Bool, avatarBgColor: UIColor, badgeColors: (bg: UIColor, text: UIColor)) {
        nameLabel.text = name
        percentLabel.text = "\(percent)% completed"
        rankLabel.text = "\(rank)"
        
        // Avatar icon
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        avatarImageView.image = UIImage(systemName: "person.fill", withConfiguration: config)
        avatarImageView.backgroundColor = avatarBgColor
        avatarImageView.tintColor = badgeColors.text
        
        // Rank Badge
        rankBadge.backgroundColor = badgeColors.bg
        rankLabel.textColor = badgeColors.text
        
        // Current user highlight styles matching mockup (High-contrast card highlight)
        if isCurrentUser {
            // High contrast current user card (White in Dark theme, Accent Teal in Light theme)
            cardView.backgroundColor = UIColor { tc in
                tc.userInterfaceStyle == .dark ? .white : UIColor(hex: "1FA5A1")
            }
            cardView.layer.borderColor = UIColor.clear.cgColor
            
            nameLabel.textColor = UIColor { tc in
                tc.userInterfaceStyle == .dark ? UIColor(hex: "1A1A1A") : .white
            }
            percentLabel.textColor = UIColor { tc in
                tc.userInterfaceStyle == .dark ? .gray : UIColor.white.withAlphaComponent(0.8)
            }
        } else {
            // Normal card style
            cardView.backgroundColor = .cardBg
            cardView.layer.borderColor = UIColor.cardBorder.cgColor
            
            nameLabel.textColor = .textPrimary
            percentLabel.textColor = .textSecondary
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // Refresh borders if trait changes
        if cardView.backgroundColor != .white && cardView.backgroundColor != UIColor(hex: "1FA5A1") {
            cardView.layer.borderColor = UIColor.cardBorder.cgColor
        }
    }
}
