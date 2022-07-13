import UIKit

class ViewController: UIViewController {
    
     let newsTableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    
    var articles = [Article]()
    var viewModels = [NewsTableViewCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        view.addSubview(newsTableView)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "News"
        
        APICaller.shared.getNews { [ weak self ] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title,
                                               subtitle: $0.description ?? "",
                                               imageURL: URL (string: $0.urlToImage ?? "")
                    )
                })
                DispatchQueue.main.async {
                    self?.newsTableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        newsTableView.frame = view.bounds
    }
}
