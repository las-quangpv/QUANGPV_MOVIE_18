

import UIKit
import Alamofire
class MovieVC: BaseVC {

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var clv: UICollectionView!
    
    var movies = [MovieModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        clv.delegate = self
        clv.dataSource = self
        clv.register(UINib(nibName: "MovieDbCell", bundle: nil), forCellWithReuseIdentifier: "MovieDbCell")
        
        getMoviePlayNow()
    }
    
    func checkEmpty() {
        if(movies.count == 0) {
            clv.isHidden = true
            emptyView.isHidden = false
        }else {
            clv.isHidden = false
            emptyView.isHidden = true
            clv.reloadData()
        }
    }
    
     func getMoviePlayNow() {
        let urlStr = "https://api.themoviedb.org/3/movie/now_playing"
        let params: Dictionary = ["api_key": "2785b2e97ff3d7949d8182eed4cad51c", "page": 1]
        let headers: HTTPHeaders? =  nil
         AF.request(urlStr, method: .get,parameters: params,headers: headers)
            .validate()
            .response { [self] response in
                switch response.result {
                case .success(let data):
                    if let httpResponse = response.response {
                        print("HTTP Status Code: \(httpResponse.statusCode)")
                    }
                    if let responseData = data{
                        if let json = self.convertDataToJSON(data: responseData) as? Dictionary {
                            if let list = json["results"] as? [Dictionary] {
                                for item in list {
                                    let movie = MovieModel(item)
                                    movies.append(movie)
                                }
                                checkEmpty()
                            }
                        }
                    }
                  
                case .failure(let error):
                    print("Error: \(error)")
                    
                }
            }
    }
    
    func convertDataToJSON(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: [])
        } catch { }
        return nil
    }

    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MovieVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieDbCell", for: indexPath) as! MovieDbCell
        
        let movieModel = movies[indexPath.row]
        cell.lbDate.text = movieModel.releaseDate
        cell.lbTitle.text = movieModel.title
        cell.iv.setImage(urlStr: movieModel.posterPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieModel = movies[indexPath.row]
        let text = "Create movie \( movieModel.title)"
       
        showLoading()
        showMessageLong(message: "Creating video. It may take a few minutes to create, please wait.")
        NetworkManager.newInstance.createVideo(txt: text) { dataSucessV2Model in
            DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
                if let dataSucessV2Model = dataSucessV2Model {
                    print("trungnc: id: \(dataSucessV2Model.id)")
                    NetworkManager.newInstance.fetchDreambooth(requestID: "\(dataSucessV2Model.id)") { textToVideoModel in
                        if let textToVideoModel = textToVideoModel {
                            if(textToVideoModel.output.count > 0) {
                                let urlStr = textToVideoModel.output[0]
                                print("\(textToVideoModel.output[0])")
                                NetworkManager.newInstance.downloadVideo(urlString: urlStr) { fileName, urlFinish in
                                    DispatchQueue.main.sync {
                                        self.hideLoading()
                                    }
                                    
                                    if(!fileName.isEmpty) {
                                        DispatchQueue.main.sync {
                                            if let urlFinish = urlFinish {
                                                let vc = CreateVideoAI()
                                                vc.fileName = fileName
                                                vc.videoUrl = urlFinish
                                                vc.movieModel = movieModel
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }else {
                                                self.showMessage(message: "Invalid content. Please try again.")
                                            }
                                           
                                        }
                                    }
                                }
                            }
                        }else {
                            DispatchQueue.main.sync {
                                self.hideLoading()
                            }
                        }
                        
                    }
                }else {
                    self.showMessage(message: "Invalid content. Please try again.")
                }
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = clv.frame.width/2 - 8
        return CGSize(width: size, height: size)
    }
}
