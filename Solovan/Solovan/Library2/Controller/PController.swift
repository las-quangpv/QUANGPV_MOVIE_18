import UIKit
import CRRefresh

class PController: BVC {
    //MARK: -properties
    fileprivate let columns: CGFloat = UIDevice.current.is_iPhone ? 3 : 5
    fileprivate let padding: CGFloat = UIDevice.current.is_iPhone ? 20 : 20
    
    //MARK: -view models
    fileprivate var peopleListVM: PPopularVM?
    
    
    //MARK: -outlets
    @IBOutlet weak var peopleCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadData()
    }
    
    private func setupUI() {
        peopleCollectionView.register(UINib(nibName: PListCell.cellId, bundle: nil), forCellWithReuseIdentifier: PListCell.cellId)
        peopleCollectionView.delegate = self
        peopleCollectionView.dataSource = self
        
        peopleCollectionView.cr.addFootRefresh {
            // load more
            if self.peopleListVM?.isLoading ?? false { return }
            self.peopleListVM?.loadData()
        }
        
    }
    private func loadData() {
        peopleListVM = PPopularVM()
        peopleListVM?.bindViewModelToController = {
            self.peopleCollectionView.cr.endLoadingMore()
            self.peopleCollectionView.reloadData()
        }
        peopleListVM?.loadData()
    }
    
    @IBAction func menuAction(_ sender: Any) {
        if DataCommonModel.shared.extraFind("back_inter") == nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            InterstitialHandle.shared.tryToPresent() {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func searchAction(_ sender: Any) {
        self.openSearch(type: .actor)
    }
    
}

extension PController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return peopleListVM?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PListCell.cellId, for: indexPath) as! PListCell
        cell.people = peopleListVM?.data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let people = peopleListVM?.data[indexPath.row] {
            self.openPeopleDetail(people.id)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: padding, bottom: padding, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding/2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding/2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w: CGFloat = CGFloat(Int((collectionView.bounds.size.width - 2 * padding - ((columns - 1) * padding/2)) / columns))
       // let w: CGFloat = 104
        let h: CGFloat = w * 1.8
        return .init(width: w, height: h)
    }
    
}
