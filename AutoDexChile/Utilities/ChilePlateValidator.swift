import Foundation

/// Utilidad para validar formatos típicos de patente chilena.
/// Formatos soportados:
/// - AA1111
/// - AAAA11
enum ChilePlateValidator {
    private static let regexes: [NSRegularExpression] = {
        let patterns = [
            "^[A-Z]{2}[0-9]{4}$",
            "^[A-Z]{4}[0-9]{2}$"
        ]

        return patterns.compactMap { try? NSRegularExpression(pattern: $0) }
    }()

    static func isValid(_ plate: String) -> Bool {
        let normalized = ChilePlateNormalizer.normalize(plate)
        let range = NSRange(location: 0, length: normalized.utf16.count)

        return regexes.contains { regex in
            regex.firstMatch(in: normalized, options: [], range: range) != nil
        }
    }
}
