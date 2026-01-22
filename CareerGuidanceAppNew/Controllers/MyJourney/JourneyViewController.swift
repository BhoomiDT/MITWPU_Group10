import UIKit

class JourneyViewController: UIViewController,UITableViewDelegate{


    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private var sections: [JourneySection] = JourneyData.milestones

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        tableView.backgroundColor = .systemGroupedBackground
        setupUI()
        setupTableView()
    }

  
    private func setupUI() {
        if segmentedControl.numberOfSegments == 2 {
            segmentedControl.setTitle("Milestone History", forSegmentAt: 0)
            segmentedControl.setTitle("Learned Skills", forSegmentAt: 1)
        }
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.label
        ], for: .normal)

        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.white
        ], for: .selected)
    }

    private func setupTableView() {
        let nib = UINib(nibName: "JourneyTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "JourneyTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderTopPadding = 8
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
            view.backgroundColor = .systemGroupedBackground

    }


    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            sections = JourneyData.milestones
        } else {
            sections = JourneyData.skills
        }
        tableView.reloadData()
    }
}


extension JourneyViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "JourneyTableViewCell",
            for: indexPath
        ) as? JourneyTableViewCell else {
            return UITableViewCell()
        }

        let item = sections[indexPath.section].items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}

