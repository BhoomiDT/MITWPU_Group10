//
//  RoadmapLessonRowCell.swift
//  CareerGuidanceAppNew
//
//  Created by SDC-USER on 09/12/25.
//

import UIKit

protocol RoadmapLessonRowCellDelegate: AnyObject {
    func roadmapLessonRowCell(_ cell: RoadmapLessonRowCell, didTapStatusFor lesson: Lesson)
}

class RoadmapLessonRowCell: UITableViewCell {
    @IBOutlet weak var cardContainerView: UIView!
    @IBOutlet weak var lessonTitleLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
        weak var delegate: RoadmapLessonRowCellDelegate?
        private var lesson: Lesson?
    
    private let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGray5
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        cardContainerView.backgroundColor = .white
        cardContainerView.clipsToBounds = true
        cardContainerView.layer.cornerRadius = 12
        if #available(iOS 15.0, *) {
            statusButton.configuration = nil
        }

        statusButton.setTitleColor(.white, for: .normal)
        statusButton.layer.cornerRadius = 14
        statusButton.clipsToBounds = true

        statusButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14)
        statusButton.titleLabel?.adjustsFontSizeToFitWidth = true
        statusButton.addTarget(self, action: #selector(statusButtonTapped(_:)), for: .touchUpInside)
            
        cardContainerView.addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 12),
            separatorView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -12),
            separatorView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        statusButton.backgroundColor = .clear
        statusButton.setTitleColor(.label, for: .normal)
        statusButton.setTitle("", for: .normal)
    }
    
    func configure(with lesson: Lesson) {
        self.lesson = lesson
        lessonTitleLabel.text = lesson.name

        let hasResult =
            QuizHistoryManager.shared.hasCompletedQuiz(for: lesson.id)

        let title: String
        let bgColor: UIColor
        let textColor: UIColor

        if hasResult {
            title = LessonStatus.seeResults.rawValue
            bgColor = UIColor(hex: "1FA5A1")
            textColor = .white
        } else {
            title = LessonStatus.startTest.rawValue
            bgColor = .systemGray5
            textColor = .darkGray
        }

        statusButton.setTitle(title, for: .normal)
        statusButton.backgroundColor = bgColor
        statusButton.setTitleColor(textColor, for: .normal)
    }

    @objc private func statusButtonTapped(_ sender: UIButton) {
        guard let lesson = lesson else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.configure(with: lesson)
            }

            delegate?.roadmapLessonRowCell(self, didTapStatusFor: lesson)
        }
    func setCorners(topLeft: Bool, topRight: Bool, bottomLeft: Bool, bottomRight: Bool, hideSeparator: Bool) {
        var maskedCorners: CACornerMask = []
        if topLeft { maskedCorners.insert(.layerMinXMinYCorner) }
        if topRight { maskedCorners.insert(.layerMaxXMinYCorner) }
        if bottomLeft { maskedCorners.insert(.layerMinXMaxYCorner) }
        if bottomRight { maskedCorners.insert(.layerMaxXMaxYCorner) }
        cardContainerView.layer.maskedCorners = maskedCorners
        separatorView.isHidden = hideSeparator
    }
}

