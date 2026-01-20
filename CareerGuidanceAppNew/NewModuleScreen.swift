import UIKit

class NewModuleScreen: UIViewController {

    @IBOutlet weak var collectionNewModules: UICollectionView!

    var selectedDomain: LearningDomain?

    private var modules: [LearningModule] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadModules()
    }

    private func setupCollectionView() {
        collectionNewModules.delegate = self
        collectionNewModules.dataSource = self

        collectionNewModules.register(
            UINib(nibName: "ModuleCardCellCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "ViewCell"
        )

        collectionNewModules.backgroundColor = .systemGroupedBackground
    }

    private func loadModules() {
        let domain = selectedDomain ?? ModuleData.getDomains().first!

        self.title = domain.title
        modules = domain.modules
        collectionNewModules.reloadData()
    }

}

extension NewModuleScreen: UICollectionViewDelegate,
                           UICollectionViewDataSource,
                           UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return modules.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ViewCell",
            for: indexPath
        ) as! ModuleCardCellCollectionViewCell

        let module = modules[indexPath.item]
        cell.configure(with: module)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(
            width: 320,
            height: 160
        )
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

