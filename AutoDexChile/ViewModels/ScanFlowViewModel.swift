import Foundation
import UIKit

/// ViewModel del flujo completo de escaneo:
/// foto auto -> foto patente -> OCR -> revisión.
@MainActor
final class ScanFlowViewModel: ObservableObject {
    @Published var draft: ScanDraft = .empty

    @Published var carImageData: Data?
    @Published var plateImageData: Data?

    @Published var carPreview: UIImage?
    @Published var platePreview: UIImage?

    @Published var ocrResult: OCRResult = .empty
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var shouldNavigateToReview: Bool = false

    private let ocrService: OCRService

    init(ocrService: OCRService = OCRService()) {
        self.ocrService = ocrService
    }

    var hasCarPhoto: Bool {
        carImageData != nil
    }

    var hasPlatePhoto: Bool {
        plateImageData != nil
    }

    func setCarImageData(_ data: Data) {
        carImageData = data
        carPreview = UIImage(data: data)

        do {
            draft.carImagePath = try ImageStorageHelper.saveTemporaryImageData(data, prefix: "car")
        } catch {
            errorMessage = "No se pudo guardar temporalmente la foto del auto."
        }
    }

    func setPlateImageData(_ data: Data) {
        plateImageData = data
        platePreview = UIImage(data: data)

        do {
            draft.plateImagePath = try ImageStorageHelper.saveTemporaryImageData(data, prefix: "plate")
        } catch {
            errorMessage = "No se pudo guardar temporalmente la foto de la patente."
        }
    }

    func runOCR() async {
        guard let plateImageData else {
            errorMessage = "Primero agrega una foto de la patente."
            return
        }

        isLoading = true
        errorMessage = nil

        let result = await ocrService.recognizePlateText(fromImageData: plateImageData)

        ocrResult = result
        draft.plateRawText = result.rawText
        draft.normalizedPlate = result.normalizedPlate

        isLoading = false
        shouldNavigateToReview = true
    }
}
