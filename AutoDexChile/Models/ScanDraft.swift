import Foundation

/// Estado temporal del flujo de escaneo.
/// Transporta patente, imágenes y resultado de lookup antes de crear una ficha final.
struct ScanDraft: Codable, Equatable {
    var plateRawText: String
    var normalizedPlate: String
    var carImagePath: String?
    var plateImagePath: String?
    var lookupResult: VehicleLookupResult?

    static let empty = ScanDraft(
        plateRawText: "",
        normalizedPlate: "",
        carImagePath: nil,
        plateImagePath: nil,
        lookupResult: nil
    )
}
