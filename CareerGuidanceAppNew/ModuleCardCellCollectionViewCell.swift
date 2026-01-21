import UIKit

class ModuleCardCellCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var resourceButton: UIButton!
    @IBOutlet weak var testButton: UIButton!

    // Callback closure
    var onSeeResourcesTapped: (() -> Void)?
    var lesson: Lesson?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        resourceButton.layer.cornerRadius = 20
        resourceButton.layer.borderWidth = 1
        resourceButton.layer.borderColor = UIColor.systemTeal.cgColor

        
    }
    
    var onTestTapped: (() -> Void)?

    @IBAction func testButtonTapped(_ sender: Any) {
        onTestTapped?()
    }
    
    @IBAction func seeResourceButton(_ sender: Any) {
        onSeeResourcesTapped?()
    }
    // Inside your Cell's configure method
//    func configure(with lesson: Lesson) {
//        titleLabel.text = lesson.name
//        subtitleLabel.text = lesson.subtitle // Added this
//        testButton.setTitle(lesson.status.rawValue, for: .normal)
//    }
    
//
//    func configure(with lesson: Lesson) {
//        self.lesson = lesson
//        titleLabel.text = lesson.name
//        subtitleLabel.text = lesson.subtitle
//        let hasResult =
//            QuizHistoryManager.shared.hasCompletedQuiz(for: lesson.id)
//
//        let title: String
//        let bgColor: UIColor
//        let textColor: UIColor
//
//        if hasResult {
//            title = LessonStatus.seeResults.rawValue
//            bgColor = UIColor(hex: "1FA5A1")
//            textColor = .white
//        } else {
//            title = LessonStatus.startTest.rawValue
//            bgColor = .systemGray5
//            textColor = .darkGray
//        }
//
//        testButton.setTitle(title, for: .normal)
//        testButton.backgroundColor = bgColor
//        testButton.setTitleColor(textColor, for: .normal)
//        
//        if #available(iOS 15.0, *) {
//                var config = UIButton.Configuration.filled() // or .tinted()
//                
//                // Set the background color
//                config.baseBackgroundColor = bgColor
//                
//                // Set the text color and title
//                var titleAttr = AttributedString(title)
//                titleAttr.foregroundColor = textColor
//                titleAttr.font = .systemFont(ofSize: 14, weight: .bold)
//                config.attributedTitle = titleAttr
//                
//                // Corner radius
//                config.background.cornerRadius = 20
//                
//                testButton.configuration = config
//            } else {
//                // Fallback for older iOS versions
//                testButton.setTitle(title, for: .normal)
//                testButton.backgroundColor = bgColor
//                testButton.setTitleColor(textColor, for: .normal)
//                testButton.layer.cornerRadius = 20
//            }
//    }
    func configure(with lesson: Lesson, isCompleted: Bool, isCurrentActive: Bool, isLocked: Bool) {
        self.lesson = lesson
        titleLabel.text = lesson.name
        subtitleLabel.text = lesson.subtitle

        let titleText: String
        let brandColor = UIColor(hex: "#1FA5A1")
        let buttonBG: UIColor
        let titleColor: UIColor
        
        // Determine State Visuals
        if isCompleted {
            titleText = "See Results"
            buttonBG = brandColor
            titleColor = .white
        } else if isCurrentActive {
            titleText = "Start Test"
            buttonBG = brandColor
            titleColor = .white
        } else {
            titleText = "Start Test"
            buttonBG = .systemGray5
            titleColor = .systemGray
        }

        // MODERN FIX: Use UIButton.Configuration
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = buttonBG
            
            // Setup Attributed Title to ensure color and font are applied
            var attrTitle = AttributedString(titleText)
            attrTitle.foregroundColor = titleColor
            //attrTitle.font = .systemFont(ofSize: 14, weight: .bold)
            config.attributedTitle = attrTitle
            
            config.cornerStyle = .capsule // Rounded corners
            testButton.configuration = config
        } else {
            // Fallback for older iOS versions
            testButton.setTitle(titleText, for: .normal)
            testButton.backgroundColor = buttonBG
            testButton.setTitleColor(titleColor, for: .normal)
            testButton.layer.cornerRadius = testButton.frame.height / 2
        }

        testButton.isUserInteractionEnabled = true        //self.contentView.alpha = isLocked ? 0.6 : 1.0
    }
}

