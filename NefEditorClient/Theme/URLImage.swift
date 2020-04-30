import SwiftUI
import Bow
import BowEffects

struct URLImage<Placeholder: View>: View {
    @ObservedObject private var loader: ImageLoader
    private let placeholder: Placeholder?
    
    init(url: URL, placeholder: Placeholder? = nil) {
        loader = ImageLoader(url: url)
        self.placeholder = placeholder
    }
    
    var body: some View {
        image.onAppear(perform: loader.load)
    }
    
    private var image: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .resizable()
            } else {
                placeholder
            }
        }
    }
}

private class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL
    private static let downloadQueue = DispatchQueue(label: "download-images")
    
    init(url: URL) {
        self.url = url
    }
    
    func load() {
        URLSession.shared.downloadTaskIO(with: self.url)
            .flatMap { result in
                IO.invoke {
                    try Data.init(contentsOf: result.url)
                }
            }.map(UIImage.init(data:))
            .handleError { _ in nil }^
            .unsafeRunAsync(on: ImageLoader.downloadQueue) { either in
                DispatchQueue.main.async { [weak self] in
                    self?.image = either.getOrElse(nil)
                }
            }
    }
}
