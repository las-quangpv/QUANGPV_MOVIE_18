import UIKit

class ChooseLanguageView: UIView {
    lazy private var data: [LanguageModel] = getLanguages()
    
    public static var language: LanguageModel {
        set {
            let str = newValue.toJSONString()
            UserDefaults.standard.set(str, forKey: "subtitle-language-default")
            UserDefaults.standard.synchronize()
        }
        get {
            var lang: LanguageModel?
            if let str = UserDefaults.standard.string(forKey: "subtitle-language-default") {
                lang = instantiate(jsonString: str)
            }
            return lang ?? englishLanguage
        }
    }
    
    public var onSelected: ((_ lang: LanguageModel) -> Void)? = nil
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Choose subtitle language default"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.getImage("baseline_close_white"), for: .normal)
        return button
    }()
    
    private let listTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.backgroundColor = .clear
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        reloadData()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        reloadData()
    }
    
    private func setupUI() {
        backgroundColor = .darkGray
        layer.cornerRadius = 10
        clipsToBounds = true
        
        closeButton.addTarget(self, action: #selector(closeClicked), for: .touchUpInside)
        
        listTable.register(UITableViewCell.self, forCellReuseIdentifier: "identifierCELL")
        listTable.delegate = self
        listTable.dataSource = self
        
        addSubview(titleLabel)
        addSubview(closeButton)
        addSubview(listTable)
        
        closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        closeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 45).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: closeButton.leftAnchor, constant: 0).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        listTable.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        listTable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        listTable.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        listTable.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
    }
    
    private func reloadData() {
        self.listTable.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            let id = ChooseLanguageView.language.id
            if let index = self.data.firstIndex(where: { $0.id == id }) {
                let indexPath = IndexPath(item: index, section: 0)
                self.listTable.scrollToRow(at: indexPath, at: .middle, animated: false)
            }
        }
    }
    
    func showIn(view: UIView) {
        reloadData()
        
        let w: CGFloat = CGFloat.minimum(view.frame.size.width - 100, 450)
        let h: CGFloat = CGFloat.minimum(view.frame.size.height - 50, 350)
        let x: CGFloat = (view.frame.size.width - w) / 2
        let y: CGFloat = (view.frame.size.height - h) / 2
        frame = .init(x: x, y: y, width: w, height: h)
        alpha = 0
        view.addSubview(self)
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        } completion: { _ in
            
        }
    }
    
    @objc func closeClicked() {
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
}

extension ChooseLanguageView: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifierCELL")!
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        var containerView: UIView? = cell.contentView.viewWithTag(1)
        if containerView == nil {
            containerView = UIView()
            containerView?.tag = 1
            containerView?.translatesAutoresizingMaskIntoConstraints = false
            containerView?.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            containerView?.layer.cornerRadius = 8
            containerView?.clipsToBounds = true
            
            let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressView(sender:)))
            gesture.minimumPressDuration = 0.1
            
            containerView?.addGestureRecognizer(gesture)
            cell.contentView.addSubview(containerView!)
            
            containerView?.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 10).isActive = true
            containerView?.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: -10).isActive = true
            containerView?.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 0).isActive = true
            containerView?.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: 0).isActive = true
        }
        
        var checkImage: UIImageView? = containerView?.viewWithTag(2) as? UIImageView
        if checkImage == nil {
            checkImage = UIImageView()
            checkImage?.tag = 2
            checkImage?.translatesAutoresizingMaskIntoConstraints = false
            containerView?.addSubview(checkImage!)
            
            checkImage?.centerYAnchor.constraint(equalTo: containerView!.centerYAnchor, constant: 0).isActive = true
            checkImage?.rightAnchor.constraint(equalTo: containerView!.rightAnchor, constant: -10).isActive = true
            checkImage?.widthAnchor.constraint(equalToConstant: 21).isActive = true
            checkImage?.heightAnchor.constraint(equalToConstant: 21).isActive = true
        }
        
        var label: UILabel? = containerView?.viewWithTag(3) as? UILabel
        if label == nil {
            label = UILabel()
            label?.tag = 3
            label?.translatesAutoresizingMaskIntoConstraints = false
            label?.textColor = .white
            label?.font = UIFont.systemFont(ofSize: 16)
            containerView?.addSubview(label!)
            
            label?.topAnchor.constraint(equalTo: containerView!.topAnchor, constant: 5).isActive = true
            label?.bottomAnchor.constraint(equalTo: containerView!.bottomAnchor, constant: -5).isActive = true
            label?.leftAnchor.constraint(equalTo: containerView!.leftAnchor, constant: 10).isActive = true
            label?.rightAnchor.constraint(equalTo: checkImage!.rightAnchor, constant: -5).isActive = true
        }
        
        let lang = data[indexPath.row]
        let isSelected = lang.id == ChooseLanguageView.language.id
        containerView?.backgroundColor = isSelected ? UIColor.black.withAlphaComponent(0.5) : UIColor.clear
        checkImage?.image = isSelected ? UIImage.getImage("radio_button_checked") : UIImage.getImage("radio_button_uncheck")
        
        label?.text = lang.name
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        
        ChooseLanguageView.language = data[indexPath.row]
        tableView.reloadData()
        onSelected?(ChooseLanguageView.language)
        closeClicked()
    }
    
    @objc func longPressView(sender: UILongPressGestureRecognizer) {
        guard let containerView = sender.view else { return }
        guard let label = containerView.viewWithTag(2) as? UILabel else { return }
        
        switch sender.state {
        case .began, .changed:
            label.textColor = .orange
        case .cancelled, .ended, .failed:
            label.textColor = .white
        default:
            label.textColor = .white
        }
    }
}
