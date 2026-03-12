import Foundation
import UIKit
import Vision

/// Servicio OCR para lectura de texto en imágenes usando Vision.
/// Esta fase detecta texto y propone candidatas de patente chilena.
final class OCRService {
    func recognizePlateText(fromImageData data: Data) async -> OCRResult {
        guard let image = UIImage(data: data) else {
            return .empty
        }

        return await recognizePlateText(from: image)
    }

    func recognizePlateText(from image: UIImage) async -> OCRResult {
        guard let cgImage = image.cgImage else {
            return .empty
        }

        return await withCheckedContinuation { continuation in
            let request = VNRecognizeTextRequest { request, _ in
                let observations = (request.results as? [VNRecognizedTextObservation]) ?? []

                let recognizedLines: [String] = observations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }

                let rawText = recognizedLines.joined(separator: "\n")
                let fullNormalized = ChilePlateNormalizer.normalize(rawText)

                let lineCandidates = recognizedLines
                    .map(ChilePlateNormalizer.normalize)
                    .filter { !$0.isEmpty }

                var candidates = Set<String>()
                for candidate in lineCandidates {
                    if ChilePlateValidator.isValid(candidate) {
                        candidates.insert(candidate)
                    }
                }

                // Intento adicional: buscar patrones dentro del texto completo limpio.
                let extractedFromRaw = Self.extractPlateCandidates(from: fullNormalized)
                extractedFromRaw.forEach { candidates.insert($0) }

                let sortedCandidates = Array(candidates).sorted()
                let bestPlate = sortedCandidates.first ?? fullNormalized

                continuation.resume(returning: OCRResult(
                    rawText: rawText,
                    normalizedPlate: bestPlate,
                    isValidPlate: ChilePlateValidator.isValid(bestPlate),
                    candidatePlates: sortedCandidates
                ))
            }

            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = false
            request.minimumTextHeight = 0.02
            request.recognitionLanguages = ["es-CL", "es", "en-US"]

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(returning: .empty)
            }
        }
    }

    private static func extractPlateCandidates(from cleanedText: String) -> [String] {
        guard !cleanedText.isEmpty else { return [] }

        let patterns = [
            "[A-Z]{2}[0-9]{4}",
            "[A-Z]{4}[0-9]{2}"
        ]

        var found: [String] = []
        for pattern in patterns {
            guard let regex = try? NSRegularExpression(pattern: pattern) else { continue }
            let range = NSRange(location: 0, length: cleanedText.utf16.count)
            let matches = regex.matches(in: cleanedText, options: [], range: range)

            for match in matches {
                guard let swiftRange = Range(match.range, in: cleanedText) else { continue }
                let plate = String(cleanedText[swiftRange])
                if ChilePlateValidator.isValid(plate) {
                    found.append(plate)
                }
            }
        }

        return Array(Set(found)).sorted()
    }
}
