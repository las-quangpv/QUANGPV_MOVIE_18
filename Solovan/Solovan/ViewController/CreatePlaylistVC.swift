import UIKit

class CreatePlaylistVC: BaseVC {
    @IBOutlet weak var constrantHeightListMovie: NSLayoutConstraint!
    @IBOutlet weak var clvMovie: UICollectionView!
    @IBOutlet weak var colorPagerView: FSPagerView!
    @IBOutlet weak var pagerView: FSPagerView!
    
    @IBOutlet weak var tf: EnterTextView!
    @IBOutlet weak var emptyView: UIView!
    var indexIconPager: Int = 0
    var indexColorPager: Int = 0
    var selectMovieIdStr = ""
    
    var movieList: [MyMovieModel] = []
    var colors: [Int] = [0x629B28, 0x289B56, 0x289B9B, 0x28799B, 0x28569B, 0x3F289B, 0x62289B, 0x84289B, 0x9B2890, 0x9B286D, 0x9B284B, 0x9B2828, 0x9B4B28, 0x9B6D28, 0x9B9028, 0x849B28, 0x47622D, 0x2D6162, 0x113F53, 0x111753, 0x331153, 0x53114C, 0x531124, 0x533911]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPagerView()
    }
    
    func setupPagerView() {
        pagerView.delegate = self
        pagerView.dataSource = self
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pagerView.itemSize = CGSize(width: 150, height: 150)
        pagerView.interitemSpacing = 25
        pagerView.isInfinite = true
        
        colorPagerView.delegate = self
        colorPagerView.dataSource = self
        colorPagerView.transformer = FSPagerViewTransformer(type: .linear)
        colorPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        colorPagerView.itemSize = CGSize(width: 150, height: 150)
        colorPagerView.interitemSpacing = 25
        colorPagerView.isInfinite = true
        
        clvMovie.delegate = self
        clvMovie.dataSource = self
        clvMovie.register(UINib(nibName: "MediaPhotosCell", bundle: nil), forCellWithReuseIdentifier: "MediaPhotosCell")
        
        checkEmpty()
    }
    
    func checkEmpty() {
        if(movieList.count == 0) {
            emptyView.isHidden = false
            clvMovie.isHidden = true
        }else {
            emptyView.isHidden = true
            clvMovie.isHidden = false
            clvMovie.reloadData()
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionAddMovie(_ sender: Any) {
        let vc = AddMovieVC()
        vc.addMovieBlock = { [self] selectListId in
            selectMovieIdStr = selectListId.joined(separator: ";")
            movieList = MyMovieModel.readSaveFileJson().filter({ myMovieModel in
                return selectMovieIdStr.contains(myMovieModel.id)
            })
            checkEmpty()
            
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    @IBAction func actionSave(_ sender: Any) {
        let id = "\(Date().timeIntervalSince1970)"
        let title = tf.getText()
        if(title.isEmpty) {
            showMessage(message: "You have not entered a name for the playlist!")
            return
        }
        
        var iconName = ""
        if let imageIcon = UIImage(named: "ic_\(indexIconPager + 1)") {
            imageToDoc(image: imageIcon) { fileName in
                iconName = fileName
            }
        }
        let color = colors[indexColorPager]
        let playListModel = PlaylistModel(id: id, icon: iconName, title: title, color: color, movieStrList: selectMovieIdStr)
        PlaylistModel.saveFile(playListModel: playListModel)
        showMessage(message: "Playlist created successfully")
        self.navigationController?.popViewController(animated: true)
    }
}

extension CreatePlaylistVC :FSPagerViewDataSource,FSPagerViewDelegate{
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        if(pagerView == colorPagerView) {
            return colors.count
        }
        return 24
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        if(pagerView == colorPagerView) {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
            // Kiểm tra xem đã có iconView trong contentView hay chưa
            var colorView: ColorView!
            if let existingIconView = cell.contentView.subviews.first(where: { $0 is ColorView }) as? ColorView {
                colorView = existingIconView
            } else {
                // Nếu chưa có thì tạo mới
                colorView = ColorView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
                cell.contentView.addSubview(colorView)
            }
            
            // Cập nhật hình ảnh và borderWidth
            let color = colors[index]
            colorView.circleView.backgroundColor = UIColor(hex: color)
            
            if indexColorPager == index {
                colorView.boderView.borderWidth = 3
            } else {
                colorView.boderView.borderWidth = 0
            }
            
            return cell
        }
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        // Kiểm tra xem đã có iconView trong contentView hay chưa
        var iconView: IconView!
        if let existingIconView = cell.contentView.subviews.first(where: { $0 is IconView }) as? IconView {
            iconView = existingIconView
        } else {
            // Nếu chưa có thì tạo mới
            iconView = IconView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
            cell.contentView.addSubview(iconView)
        }
        
        // Cập nhật hình ảnh và borderWidth
        let icon = "ic_\(index + 1)"
        iconView.imv.image = UIImage(named: icon)
        
        if indexIconPager == index {
            iconView.viewBoder.borderWidth = 3
        } else {
            iconView.viewBoder.borderWidth = 0
        }
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if(pagerView == colorPagerView) {
            indexColorPager = index
            colorPagerView.scrollToItem(at: indexColorPager, animated: true)
            colorPagerView.reloadData()
        }else {
            indexIconPager = index
            self.pagerView.scrollToItem(at: indexIconPager, animated: true)
            self.pagerView.reloadData()
        }
        
    }

    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        if(pagerView == colorPagerView) {
            indexColorPager = targetIndex
            colorPagerView.reloadData()
        }else {
            indexIconPager = targetIndex
            self.pagerView.reloadData()
        }
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        
    }
}


extension CreatePlaylistVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaPhotosCell", for: indexPath) as! MediaPhotosCell
        
        let myMovieModel = movieList[indexPath.row]
        let image = loadImageFromDoc(fileName: myMovieModel.posterStr)
        cell.iv.image = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let myMovieModel = movieList[indexPath.row]
        let vc = DetailMovieVC()
        vc.myMovieModel = myMovieModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (clvMovie.frame.width)/3 - 12, height: 150)
    }
}
