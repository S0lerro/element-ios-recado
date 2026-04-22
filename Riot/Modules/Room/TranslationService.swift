import Foundation

final class TranslationService {
    static let shared = TranslationService()
    
    private init() {}
    
    struct Response: Decodable {
        let oks: String
    }
    
    enum TranslationError: Error {
        case invalidURL
        case invalidResponse
        case emptyResult
    }
    
    func translateToPortuguese(text: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard var components = URLComponents(string: "https://coding96.ru/012/index.php") else {
            completion(.failure(TranslationError.invalidURL))
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "mes", value: text)
        ]
        
        guard let url = components.url else {
            completion(.failure(TranslationError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(TranslationError.invalidResponse))
                return
            }
            
            let raw = String(data: data, encoding: .utf8) ?? ""

            let cleaned = raw
                .replacingOccurrences(of: "{'oks':'", with: "")
                .replacingOccurrences(of: "'}", with: "")
            
            completion(.success(cleaned))
            
        }.resume()
    }
}
