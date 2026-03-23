
import UIKit

class aiCellView: UITableViewCell {
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var bubbleWidthConstraint: NSLayoutConstraint!
    @IBOutlet var bubbleLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var bubbleTrailingConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()

        bubbleView.layer.cornerRadius = 16
        bubbleView.layer.masksToBounds = true

        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear

        messageLabel.numberOfLines = 0
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        bubbleLeadingConstraint.isActive = false
        bubbleTrailingConstraint.isActive = false
    }

    func configure(with message: ChatMessage) {

        messageLabel.text = message.text

        if message.isUser {

            bubbleView.backgroundColor = UIColor(hex: "C4ECEB")
            messageLabel.textColor = .label

            bubbleLeadingConstraint.isActive = false
            bubbleTrailingConstraint.isActive = true

        } else {

            bubbleView.backgroundColor = .systemGray5
            messageLabel.textColor = .label

            bubbleTrailingConstraint.isActive = false
            bubbleLeadingConstraint.isActive = true
        }

        layoutIfNeeded()
    }
}
