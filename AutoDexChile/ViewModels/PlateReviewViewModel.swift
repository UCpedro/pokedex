import Foundation

/// ViewModel para revisar/corregir patente detectada por OCR.
@MainActor
final class PlateReviewViewModel: ObservableObject {
    let rawText: String
    let candidatePlates: [String]

    @Published var normalizedFromOCR: String
    @Published var editablePlate: String

    init(result: OCRResult) {
        rawText = result.rawText
        candidatePlates = result.candidatePlates
        normalizedFromOCR = result.normalizedPlate
        editablePlate = result.normalizedPlate
    }

    var normalizedEditablePlate: String {
        ChilePlateNormalizer.normalize(editablePlate)
    }

    var isValidPlate: Bool {
        ChilePlateValidator.isValid(normalizedEditablePlate)
    }

    func applyCandidate(_ plate: String) {
        editablePlate = plate
    }
}
