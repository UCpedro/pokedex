import Foundation

/// Resultado del OCR de patente.
/// Incluye texto crudo, versión normalizada y posibles candidatas detectadas.
struct OCRResult: Codable, Equatable {
    var rawText: String
    var normalizedPlate: String
    var isValidPlate: Bool
    var candidatePlates: [String]

    static let empty = OCRResult(
        rawText: "",
        normalizedPlate: "",
        isValidPlate: false,
        candidatePlates: []
    )
}
