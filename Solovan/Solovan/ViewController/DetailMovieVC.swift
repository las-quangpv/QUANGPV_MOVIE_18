
import UIKit
import CollectionViewWaterfallLayout

class DetailMovieVC: BaseVC {
    
    @IBOutlet weak var btnMedia: UIButton!
    @IBOutlet weak var btnOverVIew: UIButton!
    @IBOutlet weak var clvMedia: UICollectionView!
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var lbOverView: UILabel!
    @IBOutlet weak var viewOverView: UIView!
    @IBOutlet weak var lbUrl: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var clvTag: UICollectionView!
    @IBOutlet weak var ivPoster: BoderUIImageView!
    
    var maxHeightPhoto: [Int] = []
    var photoList: [UIImage] = []
    lazy var cellSizes: [CGSize] = {
        var cellSizes = [CGSize]()
        
        for i in 0...100 {
            let random = Int(arc4random_uniform((UInt32(100))))
            let size = 110 + random
            maxHeightPhoto.append(size)
            cellSizes.append(CGSize(width: 110, height: size))
            
        }
        
        return cellSizes
    }()
    
    var myMovieModel: MyMovieModel!
    var colorList: [ColorModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbName.text = myMovieModel.title
        lbDate.text = myMovieModel.date
        lbOverView.text = myMovieModel.overview
        lbUrl.text = myMovieModel.urlSt
        ivPoster.image = loadImageFromDoc(fileName: myMovieModel.posterStr)
        

        clvTag.delegate = self
        clvTag.dataSource = self
        clvTag.register(UINib(nibName: "TagItemCell", bundle: nil), forCellWithReuseIdentifier: "TagItemCell")
        
        let list = ColorModel.readSaveFileJson()
        let colorStrList = myMovieModel.tags.components(separatedBy: ";")
        list.forEach { colorModel in
            let index = colorStrList.firstIndex { tags in
                return tags == colorModel.tag
            } ?? -1
            if(index != -1) {
                colorList.append(colorModel)
            }
        }
        clvTag.reloadData()
        
        selectOverview()
        setupPhotoList()
    }
    
    func setupPhotoList() {
        let _ = cellSizes
        let flowLayout = CollectionViewWaterfallLayout()
        flowLayout.columnCount = 3
        clvMedia.collectionViewLayout = flowLayout
        clvMedia.register(UINib(nibName: "MediaPhotosCell", bundle: nil), forCellWithReuseIdentifier: "MediaPhotosCell")
        clvMedia.delegate = self
        clvMedia.dataSource = self
        
        let photoStrList = myMovieModel.mediaListStr.components(separatedBy: ";")
        photoList = photoStrList.map({ fileName in
            return loadImageFromDoc(fileName: fileName) ?? UIImage()
        })
        clvMedia.reloadData()
    }
    
    func selectOverview() {
        btnOverVIew.setTitleColor(UIColor(hex: 0x629B28), for: .normal)
        btnMedia.setTitleColor(UIColor(hex: 0xA4CD7B), for: .normal)
        viewOverView.isHidden = false
        mediaView.isHidden = true
    }
    
    func selectMedia() {
        btnMedia.setTitleColor(UIColor(hex: 0x629B28), for: .normal)
        btnOverVIew.setTitleColor(UIColor(hex: 0xA4CD7B), for: .normal)
        viewOverView.isHidden = true
        mediaView.isHidden = false
    }

    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionOverview(_ sender: Any) {
        selectOverview()
    }
    
    @IBAction func actionMedia(_ sender: Any) {
        selectMedia()
    }
    
    @IBAction func actionMore(_ sender: Any) {
        let vc = MorePopupVC()
        vc.morePopupBlock = { [self] style in
            if(style == 0) {
                let vc = CreateMovieVC()
                vc.myMovieModel = myMovieModel
                vc.selectTagList = colorList
                self.navigationController?.pushViewController(vc, animated: true)
                // edit
            }
            
            if(style == 1) {
                // add playlist
            }
            
            if(style == 2) {
                // share
                let title = myMovieModel.title
                let date = myMovieModel.date
                let overview = myMovieModel.overview
                
                
                let v = UIView(frame: CGRect(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT-120, width: 10, height: 1))
                var urls: [Any] = []
                
                if let poster = ivPoster.image {
                    urls = [title, date, overview, poster]
                }else {
                    urls = [title, date, overview]
                }
                
                let share = UIActivityViewController(activityItems: urls, applicationActivities: nil)
                share.popoverPresentationController?.sourceView = v
                self.present(share, animated: true, completion: nil)
                
                    
            }
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
}

extension DetailMovieVC: UICollectionViewDelegate, UICollectionViewDataSource, CollectionViewWaterfallLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(clvMedia == collectionView) {
            return photoList.count
        }
        return colorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(clvMedia == collectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaPhotosCell", for: indexPath) as! MediaPhotosCell
            cell.iv.image = photoList[indexPath.row]
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagItemCell", for: indexPath) as! TagItemCell
        let colorModel = colorList[indexPath.row]
        cell.lb.text = colorModel.tag
        cell.lb.textColor = UIColor(hex: colorModel.colorHex)
        cell.boderView.borderColor = UIColor(hex: colorModel.colorHex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if(collectionView == clvMedia) {
            if(indexPath.row < cellSizes.count) {
                return cellSizes[indexPath.item]
            }else {
                return CGSize(width: 110, height: 110)
            }
        }
        return CGSize(width: 110, height: 110)
        
    }
}
