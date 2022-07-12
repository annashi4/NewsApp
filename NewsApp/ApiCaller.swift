import Foundation

final class APICaller{
    static let shared = APICaller()
    
    struct Constants {
        static let url = URL(string: "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=d22e6b56f2114aff8efc956f789130e5")
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

// MARK: api model

struct AIPResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
   let source: Source
    let title: String
   let description: String?
    let url: String
    let urlToImage: String
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}
