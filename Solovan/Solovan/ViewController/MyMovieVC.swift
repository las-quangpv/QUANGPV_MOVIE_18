

import UIKit

class MyMovieVC: BaseVC {

    @IBOutlet weak var clvMovie: UICollectionView!
    @IBOutlet weak var clvTag: UICollectionView!
    
    @IBOutlet weak var emptyView: UIView!
 
    
    var movieList: [MyMovieModel] = []
    var colorList: [ColorModel] = []
    var colorSelectModel: ColorModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        clvTag.delegate = self
        clvTag.dataSource = self
        clvTag.register(UINib(nibName: "TagCell", bundle: nil), forCellWithReuseIdentifier: "TagCell")
        
        clvMovie.delegate = self
        clvMovie.dataSource = self
        clvMovie.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        colorList = ColorModel.readSaveFileJson()
       if(colorList.count == 0) {
           colorBegin.forEach { colorModel in
               ColorModel.saveFile(colorModel: colorModel)
           }
       }
        
        colorList = ColorModel.readSaveFileJson()
        colorSelectModel = ColorModel(colorHex: 0x629B28, tag: "All")
        colorList.insert(colorSelectModel!, at: 0)
        clvTag.reloadData()
        
        filterMovieListWithTag()
    }
    
    func filterMovieListWithTag() {
        let list = MyMovieModel.readSaveFileJson()
        if(colorSelectModel?.tag == "All") {
            movieList = list
        }else {
            movieList = list.filter({ movieModel in
                return movieModel.tags.contains(colorSelectModel?.tag ?? "")
            })
        }
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

    @IBAction func actionAdd(_ sender: Any) {
        let vc = CreateMovieVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionMenu(_ sender: Any) {
        let vc = PlayListVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyMovieVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (clvMovie == collectionView) {
            return movieList.count
        }
        return colorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (clvMovie == collectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
            
            let myMovieModel = movieList[indexPath.row]
            cell.setData(myMovieModel: myMovieModel)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        let colorModel = colorList[indexPath.row]
        cell.lb.text = colorModel.tag
        if(colorSelectModel?.tag != colorModel.tag) {
            cell.lb.textColor = UIColor(hex: colorModel.colorHex)
            cell.boderView.borderColor = UIColor(hex: colorModel.colorHex)
            cell.boderView.backgroundColor = UIColor.clear
        }else {
            cell.lb.textColor = UIColor(hex: 0xFFFFFF).withAlphaComponent(0.8)
            cell.boderView.borderColor = UIColor(hex: colorModel.colorHex)
            cell.boderView.backgroundColor = UIColor(hex: colorModel.colorHex)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(clvMovie == collectionView) {
            let myMovieModel = movieList[indexPath.row]
            let vc = DetailMovieVC()
            vc.myMovieModel = myMovieModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if(clvTag == collectionView) {
            colorSelectModel = colorList[indexPath.row]
            clvTag.reloadData()
            filterMovieListWithTag()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (clvMovie == collectionView) {
            return CGSize(width: clvMovie.frame.width, height: 150)
        }
        return CGSize(width: 100, height: 40)
    }
}
