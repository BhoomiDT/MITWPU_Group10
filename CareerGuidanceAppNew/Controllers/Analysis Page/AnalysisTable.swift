import UIKit

class AnalysisTable: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var recommendedPath: UILabel!
    
    @IBOutlet weak var tableViewAnalysis: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appBackground
        tableViewAnalysis.backgroundColor = .appBackground
        
        tableViewAnalysis.dataSource = self
        tableViewAnalysis.delegate = self
        
        tableViewAnalysis.register(UINib(nibName: "AnalysisTableViewCell1", bundle: nil), forCellReuseIdentifier: "cell1")
        tableViewAnalysis.register(UINib(nibName: "AnalysisTableViewCell2", bundle: nil), forCellReuseIdentifier: "cell2")
        tableViewAnalysis.register(UINib(nibName: "AnalysisTableViewCell3", bundle: nil), forCellReuseIdentifier: "cell3")
        
        tableViewAnalysis.separatorStyle = .none
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        
        else if section == 1 { return riasecData.count }
        else { return 3 }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 0 }
        else { return 30 }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        
        let section = indexPath.section
        
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! AnalysisTableViewCell1
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMinYCorner,
                                         .layerMaxXMinYCorner,
                                         .layerMinXMaxYCorner,
                                         .layerMaxXMaxYCorner]
            cell.clipsToBounds = true
            return cell
        }
        
        if section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! AnalysisTableViewCell2
            
            
            let data = riasecData[indexPath.row]
            
           
            cell.labelCategory.text = data.label
            cell.progressBar.progress = data.score
            cell.progressBar.progressTintColor = data.color
            cell.labelScore.text = "\(Int(data.score * 100))%"
            
            applyRoundedCorners(for: cell, indexPath: indexPath, numberOfRows: riasecData.count)
            return cell
        }
        
        if section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! AnalysisTableViewCell3
            applyRoundedCorners(for: cell, indexPath: indexPath, numberOfRows: 3)
            return cell
        }
        
        return UITableViewCell()
    }
    

    
    private func applyRoundedCorners(for cell: UITableViewCell,
                                     indexPath: IndexPath,
                                     numberOfRows: Int) {
        
        if numberOfRows == 1 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMinYCorner,
                                         .layerMaxXMinYCorner,
                                         .layerMinXMaxYCorner,
                                         .layerMaxXMaxYCorner]
        }
        else if indexPath.row == 0 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMinYCorner,
                                         .layerMaxXMinYCorner]
        }
        else if indexPath.row == numberOfRows - 1 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner,
                                         .layerMaxXMaxYCorner]
        }
        else {
            cell.layer.cornerRadius = 0
        }
        
        cell.clipsToBounds = true
    }
    
    
    
    func tableView(_ tableView: UITableView,
                    viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 { return nil }
        
        let headerView = UIView()
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .label
        
        if section == 1 { label.text = "Your Weaknesses" }
        else { label.text = "Your Interests" }
        
        headerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -5)
        ])
        
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .clear
        return footer
    }
}
