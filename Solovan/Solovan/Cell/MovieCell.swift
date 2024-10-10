

import UIKit

class MovieCell: UICollectionViewCell {
    @IBOutlet weak var lbUrl: UILabel!
    
    @IBOutlet weak var clvTag: UICollectionView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var ivPoster: BoderUIImageView!
    
    var colorList = [ColorModel]()
    override func awakeFromNib() {
        super.awakeFromNib()
        clvTag.delegate = self
        clvTag.dataSource = self
        clvTag.register(UINib(nibName: "TagItemCell", bundle: nil), forCellWithReuseIdentifier: "TagItemCell")
        
        
        
    }
    
    func setData(myMovieModel: MyMovieModel) {
        lbName.text = myMovieModel.title
        lbUrl.text = myMovieModel.urlSt
        lbDate.text = myMovieModel.date
        
        let image = loadImageFromDoc(fileName: myMovieModel.posterStr)
        ivPoster.image = image
        
        let list = ColorModel.readSaveFileJson()
        colorList = list.filter({ colorModel in
            let a = myMovieModel.tags.replacingOccurrences(of: " ", with: "").lowercased()
            let b = colorModel.tag.replacingOccurrences(of: " ", with: "").lowercased()
            print("\(a), \(b)")
            return a.contains(b)
        })
        
        if(colorList.count == 1) {
            let color = ColorModel(colorHex: 0x000000, tag: "")
            colorList.append(color)
        }
      
        clvTag.reloadData()
    }
}

extension MovieCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagItemCell", for: indexPath) as! TagItemCell
        let colorModel = colorList[indexPath.row]
        if(colorModel.tag.isEmpty) {
            cell.lb.textColor = UIColor.clear
            cell.boderView.borderColor = UIColor.clear
        }else {
            cell.lb.textColor = UIColor(hex: colorModel.colorHex)
            cell.boderView.borderColor = UIColor(hex: colorModel.colorHex)
        }
        cell.lb.text = colorModel.tag
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 40)
    }
}
