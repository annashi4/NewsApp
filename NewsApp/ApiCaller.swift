import Foundation

final class APICaller{
    static let shared = APICaller()
    
    struct Constants {
        static let url = URL(string: "https://newsapi.org/v2/everything?q=Apple&from=2022-07-13&sortBy=popularity&en&apiKey=d22e6b56f2114aff8efc956f789130e5")
    }
    
    private init() {}
    
    public func getNews(complition: @escaping(Result<[Article], Error>) -> Void) {
        guard let url = Constants.url else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                complition(.failure(error))
            } else if let data = data {
                do{
                    let result = try JSONDecoder().decode(AIPResponse.self, from: data)
                    complition(.success(result.articles))
                    
                    print("Articles: \(result.articles.count)")
                } catch {
                    complition(.failure(error))
                }
            }
        }
        task.resume()
    }
}

//MARK: fetching the news

extension ViewController {
    func fetchingNews(){
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
}

// MARK: api model

struct AIPResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
   let source: Source
    let title: String
   let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}
