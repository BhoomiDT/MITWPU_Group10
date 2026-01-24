import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var viewForIcon: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    private let sections = ProfileSection.sampleData
    private let user = UserProfile.currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCloseButton()
    }

    private func setupCloseButton() {
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            let config = UIImage.SymbolConfiguration(pointSize: 17, weight: .medium)
            
            let image = UIImage(
                systemName: "xmark",
                withConfiguration: config
            )
            
            button.setImage(image, for: .normal)
            button.tintColor = .label
            button.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.85)
            button.layer.cornerRadius = 20
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.08
            button.layer.shadowRadius = 6
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
           
            view.addSubview(button)
            button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
            
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.widthAnchor.constraint(equalToConstant: 40),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        }
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        nameLabel.text = user.name
        emailLabel.text = user.email
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        profileImage.image = UIImage(systemName: user.imageName, withConfiguration: config)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let title = sections[indexPath.section].options[indexPath.row]
        cell.textLabel?.text = title
        cell.textLabel?.font = .systemFont(ofSize: 16)
        
        if title == "Log Out" {
            cell.textLabel?.textColor = .systemRed
            cell.backgroundColor = .white
            cell.textLabel?.textAlignment = .center
            cell.accessoryType = .none
        } else {
            cell.textLabel?.textColor = .label
            cell.textLabel?.textAlignment = .left
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if sections[indexPath.section].options[indexPath.row] == "Log Out" {
            print("Logout Tapped")
        }
    }
}
