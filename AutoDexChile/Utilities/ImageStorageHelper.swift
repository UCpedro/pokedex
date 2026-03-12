import Foundation

/// Helper para manejo de imágenes locales (temporal/documentos).
enum ImageStorageHelper {
    static func temporaryImageURL(prefix: String = "image") -> URL {
        let filename = "\(prefix)-\(UUID().uuidString).jpg"
        return FileManager.default.temporaryDirectory.appendingPathComponent(filename)
    }

    @discardableResult
    static func saveTemporaryImageData(_ data: Data, prefix: String = "image") throws -> String {
        let url = temporaryImageURL(prefix: prefix)
        try data.write(to: url, options: .atomic)
        return url.path
    }

    static func copyImageToDocumentsIfNeeded(from path: String) -> String {
        let sourceURL = URL(fileURLWithPath: path)
        let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let docsURL else { return path }

        let destination = docsURL.appendingPathComponent(sourceURL.lastPathComponent)
        let manager = FileManager.default

        do {
            if manager.fileExists(atPath: destination.path) {
                try manager.removeItem(at: destination)
            }
            try manager.copyItem(at: sourceURL, to: destination)
            return destination.path
        } catch {
            return path
        }
    }
}
