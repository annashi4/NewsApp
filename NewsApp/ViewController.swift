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
        
        fetchingNews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        newsTableView.frame = view.bounds
    }
}
