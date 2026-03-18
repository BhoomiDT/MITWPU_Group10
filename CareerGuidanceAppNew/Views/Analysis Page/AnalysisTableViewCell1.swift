import UIKit

class AnalysisTableViewCell1: UITableViewCell {
    
    @IBOutlet weak var domainName: UILabel!
    @IBOutlet weak var domainDescription: UILabel!
    @IBOutlet weak var domainExplore: UIButton!
    
    var onExploreTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        domainExplore.addTarget(self, action: #selector(exploreButtonTapped), for: .touchUpInside)
    }

    @IBAction func exploreButtonTapped(_ sender: Any) {
        onExploreTapped?()
    }
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Provide consistent vertical padding to separate the cards (bottom only)
        // Ensure we DO NOT override any horizontal padding applied elsewhere (willDisplay/NIBs)
        contentView.frame = CGRect(x: contentView.frame.origin.x,
                                   y: contentView.frame.origin.y,
                                   width: contentView.frame.width,
                                   height: bounds.height - 20)
        
        self.layer.shadowOpacity = 0
    }
}
