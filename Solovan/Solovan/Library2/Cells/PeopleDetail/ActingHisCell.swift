import UIKit

class ActingHisCell: UITableViewCell {
    //MARK: -properties
    static let heigth: CGFloat = UITableView.automaticDimension
    
    var actings: [ActingHisNew] = [] {
        didSet {
            if actingTableView != nil {
                actingTableView.reloadData()
            }
        }
    }
    
    //MARK: -outlets
    @IBOutlet weak var actingTableView: UITableView!
    @IBOutlet weak var viewMoreLabel: UILabel!
    @IBOutlet weak var viewMoreImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        actingTableView.register(UINib(nibName: ActingHisItemCell.cellId, bundle: nil), forCellReuseIdentifier: ActingHisItemCell.cellId)
        actingTableView.delegate = self
        actingTableView.dataSource = self
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
extension ActingHisCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return actings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actings[section].title.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActingHisItemCell.cellId) as! ActingHisItemCell
        if indexPath.row == 0 {
            cell.yearStr = actings[indexPath.section].yearText
        }
        else {
            cell.yearStr = ""
        }
        
        cell.title = actings[indexPath.section].title[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 1))
        
        let view1 = UIView.init(frame: CGRect.init(x: 32, y: 0, width: tableView.frame.width - 64, height: 1))
        view1.backgroundColor = .clear
        
        headerView.addSubview(view1)
        
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}
