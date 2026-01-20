import UIKit

class ModuleCardCellCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var resourceButton: UIButton!
    @IBOutlet weak var testButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        resourceButton.layer.cornerRadius = 20
        resourceButton.layer.borderWidth = 1
        resourceButton.layer.borderColor = UIColor.systemTeal.cgColor

        
    }

    func configure(with module: LearningModule) {
        titleLabel.text = module.title
        subtitleLabel.text = module.description
    }
}

