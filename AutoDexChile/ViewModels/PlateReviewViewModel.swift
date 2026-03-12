import Foundation

/// ViewModel para revisar/corregir patente detectada por OCR.
@MainActor
final class PlateReviewViewModel: ObservableObject {
    @Published var draft: ScanDraft
    let candidatePlates: [String]

    @Published var editablePlate: String

    init(result: OCRResult, draft: ScanDraft) {
        var updatedDraft = draft
        updatedDraft.plateRawText = result.rawText
        updatedDraft.normalizedPlate = result.normalizedPlate

        self.draft = updatedDraft
        self.candidatePlates = result.candidatePlates
        self.editablePlate = result.normalizedPlate
    }

    var rawText: String {
        draft.plateRawText
    }

    var normalizedFromOCR: String {
        draft.normalizedPlate
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

    func confirmedDraft() -> ScanDraft {
        var updated = draft
        updated.normalizedPlate = normalizedEditablePlate
        return updated
    }
}
