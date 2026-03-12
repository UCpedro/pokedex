import Foundation

/// Helper stub para manejo de imágenes locales.
/// TODO: Implementar guardado/carga/borrado en directorios de la app.
enum ImageStorageHelper {
    static func imageURL(for id: UUID) -> URL {
        FileManager.default.temporaryDirectory.appendingPathComponent("\(id.uuidString).jpg")
    }
}
