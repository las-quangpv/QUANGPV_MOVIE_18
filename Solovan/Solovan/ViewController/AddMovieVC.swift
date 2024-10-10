

import UIKit

class AddMovieVC: BaseVC {
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var clv: UICollectionView!
    
    var movieList: [MyMovieModel] = []
    var movieSelectIdList: [String] = []
    var addMovieBlock: (([String]) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        clv.delegate = self
        clv.dataSource = self
        clv.register(UINib(nibName: "MediaPhotosCell", bundle: nil), forCellWithReuseIdentifier: "MediaPhotosCell")
        
        movieList = MyMovieModel.readSaveFileJson()
        checkEmpty()
        // Do any additional setup after loading the view.
    }
    
    func checkEmpty() {
        if(movieList.count == 0) {
            emptyView.isHidden = false
            clv.isHidden = true
        }else {
            emptyView.isHidden = true
            clv.isHidden = false
            clv.reloadData()
        }
    }

    @IBAction func actionBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionDone(_ sender: Any) {
        if let addMovieBlock = addMovieBlock {
            addMovieBlock(movieSelectIdList)
        }
        self.dismiss(animated: true)
    }
    
}

extension AddMovieVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaPhotosCell", for: indexPath) as! MediaPhotosCell
        
        let myMovieModel = movieList[indexPath.row]
        let image = loadImageFromDoc(fileName: myMovieModel.posterStr)
        cell.iv.image = image
        
        let index = movieSelectIdList.firstIndex { idStr in
            return idStr == myMovieModel.id
        } ?? -1
        if(index == -1) {
            cell.vSelect.isHidden = true
        }else {
            cell.vSelect.isHidden = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let myMovieModel = movieList[indexPath.row]
        
        let index = movieSelectIdList.firstIndex { idStr in
            return idStr == myMovieModel.id
        } ?? -1
        if(index != -1) {
            movieSelectIdList.remove(at: index)
        }else {
            movieSelectIdList.append(myMovieModel.id)
        }
        clv.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (clv.frame.width)/3 - 12, height: 150)
    }
}
