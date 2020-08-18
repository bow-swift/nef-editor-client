import Foundation
import Bow
import BowEffects
import NefEditorError

enum DownloadTaskError<Reason: Codable>: Error {
    case malformedURL
    case dataCorrupted
    case serverError
    case errorResponse(Reason)
}


extension URLSession {
    func downloadDataTaskIO<Reason: Codable>(with request: URLRequest) -> IO<DownloadTaskError<Reason>, Data> {
        func downloadTaskHandler(data: Data, statusCode: Int) -> Either<DownloadTaskError<Reason>, Data> {
            switch statusCode {
            case 200 ..< 300:
                return .right(data)
            default:
                if let error = try? JSONDecoder().decode(ErrorResponse<Reason>.self, from: data) {
                    return .left(.errorResponse(error.reason))
                } else {
                    return .left(.serverError)
                }
            }
        }
        
        return IO.async { callback in
            self.downloadTask(with: request) { url, response, error in
                guard let httpResponse = response as? HTTPURLResponse else {
                    callback(.left(.malformedURL)); return
                }
                
                guard let url = url, let data = try? Data(contentsOf: url) else {
                    callback(.left(.dataCorrupted)); return
                }
                
                let either = downloadTaskHandler(data: data, statusCode: httpResponse.statusCode)
                return callback(either)
            }.resume()
        }^
    }
}
