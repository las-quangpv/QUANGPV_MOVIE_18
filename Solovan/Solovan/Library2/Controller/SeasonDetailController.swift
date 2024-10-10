import UIKit

class SeasonDetailController: BVC {
    
    //MARK: -properties
    var episodes: [TvShowEpisode] = [] {
        didSet {
            if seasonTableView != nil {
                seasonTableView.reloadData()
            }
        }
    }
    var tvId: Int = 0
    var seasonNumber: Int = 0
    var seasonName: String = ""
    var episodesCount: Int = 0
    
    var seasons: [TvShowSeason] = []
    var seaEspisode: [Int: [TvShowEpisode]] = [:]
    
    fileprivate var tvDetailVM: TVDetailVM?
    
    //MARK: -outlets
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var seasonTableView: UITableView!
    @IBOutlet weak var seasonListLabel: UILabel!
    
    //MARK: - view models
    fileprivate var tvShowSeasonDetailVM: TVSSeasonDetailVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        
    }
    
    private func setupUI() {
        seasonTableView.register(UINib(nibName: DetailSeasonCell.cellId, bundle: nil), forCellReuseIdentifier: DetailSeasonCell.cellId)
        
        seasonTableView.delegate = self
        seasonTableView.dataSource = self
        seasonLabel.text = seasonName
    }
    
    private func loadData() {
        tvShowSeasonDetailVM = TVSSeasonDetailVM(tvId: tvId, seasonNumber: seasonNumber)
        tvShowSeasonDetailVM?.bindViewModelToController = {
            self.seasonTableView.reloadData()
            self.seasonListLabel.text = "\(self.tvShowSeasonDetailVM?.getSizeData() ?? 0) Episodes"
        }
        tvShowSeasonDetailVM?.loadData()
        
        tvDetailVM = TVDetailVM(id: tvId)
        tvDetailVM?.loadData()
    }
    
    @IBAction func backHandler(_ sender: Any) {
        if DataCommonModel.shared.extraFind("back_inter") == nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            InterstitialHandle.shared.tryToPresent() {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension SeasonDetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvShowSeasonDetailVM?.data?.episodes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailSeasonCell.cellId) as! DetailSeasonCell
        cell.data = tvShowSeasonDetailVM?.data?.episodes?[indexPath.row]
        cell.selectItemBlock = { item in
            self.selectEpisode(item)
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func selectEpisode(_ episode: TvShowEpisode) {
        let isShowReward: Bool? = DataCommonModel.shared.extraFind("is_detail_reward")
        if isShowReward == nil {
            InterstitialHandle.shared.present() {
            self.watchTVShow(episode)
          }
        } else {
            if isShowReward! {
                let alert = UIAlertController(title: title, message: "Watching an ad to watch TV Show", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                alert.addAction(UIAlertAction(title: "Watch ads", style: .default, handler: { _ in
                    AdmobReward.shared.tryToPresentDidEarnReward {
                      self.watchTVShow(episode)
                    }
                }))
            } else {
                InterstitialHandle.shared.present() {
                self.watchTVShow(episode)
              }
            }
        }
    }
    
    private func watchTVShow(_ episode: TvShowEpisode){
        guard let detail = self.tvDetailVM,
              let externalIds = detail.externalIds else { return }
        
        let name = seasonName
        let ss = seasonNumber
        let epi = episode.episode_number ?? 0
        let imdb = externalIds.imdb_id ?? ""
        
        NetworkHelper.shared.loadT(name, season: ss, episode: epi, imdb: imdb) { [weak self] data in
            guard let self = self else { return }
            
            if data.count == 0 {
                self.alertNotLink {
                    NetworkHelper.shared.rport(name: "[S\(ss)E\(epi)] \(name)",
                                               type: MediaType.tv.rawValue,
                                               year: 0,
                                               imdb: imdb,
                                               content: emptylink)
                }
            
                return
            }
            
            let player = ZemPlayerController.makeController()
            player.type = .tv
            player.name = name
            player.tvId = self.tvId
            player.data = data
            player.imdbid = imdb
            player.season = ss
            player.episode = episode
            player.seasons = self.seasons
            player.episodes = self.tvShowSeasonDetailVM!.data == nil ? [] : (self.tvShowSeasonDetailVM!.data!.episodes ?? [])
            self.present(player, animated: true)
        }
    }
}
