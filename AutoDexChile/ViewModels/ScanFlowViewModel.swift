import Foundation

/// ViewModel del flujo de escaneo de patente.
/// Orquesta OCR y navegación a revisión manual.
@MainActor
final class ScanFlowViewModel: ObservableObject {
    @Published var selectedImageData: Data?
    @Published var ocrResult: OCRResult = .empty
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var shouldNavigateToReview: Bool = false

    private let ocrService: OCRService

    init(ocrService: OCRService = OCRService()) {
        self.ocrService = ocrService
    }

    func runOCR() async {
        guard let selectedImageData else {
            errorMessage = "Selecciona una imagen de patente primero."
            return
        }

        isLoading = true
        errorMessage = nil

        let result = await ocrService.recognizePlateText(fromImageData: selectedImageData)
        ocrResult = result
        isLoading = false
        shouldNavigateToReview = true
    }

    func resetNavigation() {
        shouldNavigateToReview = false
    }
}
