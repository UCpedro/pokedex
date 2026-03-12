import Foundation

/// Utilidad para normalizar texto OCR de patente chilena.
/// - Convierte a mayúsculas
/// - Elimina espacios, saltos de línea y símbolos innecesarios
/// - Elimina la palabra CHILE en cualquier posición (incluso pegada)
enum ChilePlateNormalizer {
    static func normalize(_ input: String) -> String {
        guard !input.isEmpty else { return "" }

        var text = input
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .uppercased()
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: "\t", with: "")

        // Mantener solo caracteres alfanuméricos para robustez frente a OCR ruidoso.
        text = text.replacingOccurrences(
            of: "[^A-Z0-9]",
            with: "",
            options: .regularExpression
        )

        // Eliminar ocurrencias de CHILE aunque estén pegadas al contenido.
        while text.contains("CHILE") {
            text = text.replacingOccurrences(of: "CHILE", with: "")
        }

        return text
    }
}
