import UIKit

class PDetailController: BVC {
    //MARK: -properties
    var peopleId: Int = 0
    var cast: MovieCast?
    
    fileprivate var layout: [String] = [
        PDetailCell.cellId,
        POverViewCell.cellId,
        PKnownForCell.cellId,
        ActingHisCell.cellId
    ]
    
    //MARK: -view model
    fileprivate var peopleDetailVM: PDetailVM?
    fileprivate var peopleCreditVM: PCreditVM!
    
    //MARK: -outlets
    @IBOutlet weak var peopleDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadData()
    }
    
    private func setupUI() {
        peopleDetailTableView.separatorStyle = .none
        peopleDetailTableView.register(UINib(nibName: PDetailCell.cellId, bundle: nil), forCellReuseIdentifier: PDetailCell.cellId)
        peopleDetailTableView.register(UINib(nibName: POverViewCell.cellId, bundle: nil), forCellReuseIdentifier: POverViewCell.cellId)
        peopleDetailTableView.register(UINib(nibName: PKnownForCell.cellId, bundle: nil), forCellReuseIdentifier: PKnownForCell.cellId)
        peopleDetailTableView.register(UINib(nibName: ActingHisCell.cellId, bundle: nil), forCellReuseIdentifier: ActingHisCell.cellId)
        
        peopleDetailTableView.delegate = self
        peopleDetailTableView.dataSource = self
    }
    
    private func loadData() {
        self.peopleDetailVM = PDetailVM(id: peopleId)
        self.peopleDetailVM?.bindViewModelToController = {
            self.peopleDetailTableView.reloadData()
            let item = self.peopleDetailVM!.data!
            self.cast = MovieCast(id: item.id, character: item.biography!, name: item.name, known_for_department: item.known_for_department, profile_path: item.profile_path)
            
        }
        self.peopleDetailVM?.loadData()
        
        self.peopleCreditVM = PCreditVM(id: peopleId)
        self.peopleCreditVM.bindViewModelToController = {
            self.peopleDetailTableView.reloadData()
        }
        self.peopleCreditVM.loadData()
    }
    
    @IBAction func backAction(_ sender: Any) {
        if DataCommonModel.shared.extraFind("back_inter") == nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            InterstitialHandle.shared.tryToPresent() {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension PDetailController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch layout[indexPath.row] {
        case PDetailCell.cellId:
            return PDetailCell.height
        case POverViewCell.cellId:
            return POverViewCell.height
        case PKnownForCell.cellId:
            return PKnownForCell.height
        case ActingHisCell.cellId:
            if peopleCreditVM == nil || peopleCreditVM?.actings == nil || peopleCreditVM?.actings.count == 0 {
                return 72
            } else {
                return  CGFloat(peopleCreditVM!.actings.count) * 50 + 72 +                      CGFloat(peopleCreditVM.actingList.count)
                
            }
        default:
            return 0
        }
    }
}

extension PDetailController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return layout.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch layout[indexPath.row] {
        case PDetailCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: PDetailCell.cellId) as! PDetailCell
            cell.people = peopleDetailVM?.data
            return cell
        case POverViewCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: POverViewCell.cellId) as! POverViewCell
            if peopleDetailVM?.data != nil {
                cell.people = peopleDetailVM?.data
            }
            return cell
        case PKnownForCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: PKnownForCell.cellId) as! PKnownForCell
            cell.source = peopleCreditVM.data
            cell.selectItemBlock = { item in
                if let movie = item as? Movie {
                    self.openDetail(movie)
                }
                if let tvShow = item as? TvShow {
                    self.openDetail(tvShow)
                }
            }
            return cell
        case ActingHisCell.cellId:
            let cell = tableView.dequeueReusableCell(withIdentifier: ActingHisCell.cellId) as! ActingHisCell
            cell.actings = peopleCreditVM?.actingList ?? []
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}
