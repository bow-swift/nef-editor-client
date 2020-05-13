import Foundation
import BowEffects

extension URLSession {
    func downloadDataTaskIO(with request: URLRequest) -> IO<Error, Data> {
        IO.async { callback in
            self.downloadTask(with: request) { url, response, error in
                if let url = url, let data = try? Data(contentsOf: url) {
                    callback(.right(data))
                } else if let error = error {
                    callback(.left(error))
                } else {
                    callback(.left(GenerationError.dataCorrupted))
                }
            }.resume()
        }^
    }
}
