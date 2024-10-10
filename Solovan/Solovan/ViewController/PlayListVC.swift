

import UIKit

class PlayListVC: BaseVC {
    
    @IBOutlet weak var clv: UICollectionView!
    
    var playLists: [PlaylistModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        

        clv.delegate = self
        clv.dataSource = self
        clv.register(UINib(nibName: "PlayListCell", bundle: nil), forCellWithReuseIdentifier: "PlayListCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playLists = PlaylistModel.readSaveFileJson()
        playLists.insert(PlaylistModel(id: "-1", icon: "ic_add_playlist", title: "New Playlist",color: 0xE6FFCD, movieStrList: ""), at: 0)
        clv.reloadData()
    }

    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionFile(_ sender: Any) {
        let vc = ExportVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension PlayListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayListCell", for: indexPath) as! PlayListCell
        let playlistModel = playLists[indexPath.row]
        if(playlistModel.id == "-1") {
            cell.iv.image = UIImage(named: "ic_add_playlist")
            cell.lb.textColor = UIColor(hex: 0x629B28)
        }else {
            cell.iv.image = loadImageFromDoc(fileName: playlistModel.icon)
            cell.lb.textColor = UIColor(hex: 0xFFFFFF).withAlphaComponent(0.8)
        }
       
        cell.lb.text = playlistModel.title
        cell.boderView.backgroundColor = UIColor(hex: playlistModel.color)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.row == 0) {
            let vc = CreatePlaylistVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let playlistModel = playLists[indexPath.row]
            let vc = DetailPlayListVC()
            vc.playListModel = playlistModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(isPad()) {
            let size = clv.frame.width/3 - 8
            return CGSize(width: size, height: size)
        }
        let size = clv.frame.width/2 - 8
        return CGSize(width: size, height: size)
    }
}
