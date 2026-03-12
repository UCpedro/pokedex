import Foundation

/// Calcula rareza y puntaje base según marca/modelo.
final class RarityService {
    private let commonBrands: Set<String> = ["CHEVROLET", "KIA", "HYUNDAI", "NISSAN", "SUZUKI", "TOYOTA"]
    private let rareBrands: Set<String> = ["MAZDA", "SUBARU", "PEUGEOT", "RENAULT", "VOLKSWAGEN", "FORD"]
    private let epicBrands: Set<String> = ["BMW", "MERCEDES", "AUDI", "VOLVO", "LEXUS", "MINI"]
    private let legendaryBrands: Set<String> = ["FERRARI", "LAMBORGHINI", "MCLAREN", "PORSCHE", "ASTONMARTIN", "BUGATTI"]

    private let legendaryModelKeywords: [String] = ["GT3", "TURBO S", "AVENTADOR", "HURACAN", "488", "720S"]

    func rarity(forBrand brand: String, model: String) -> String {
        let normalizedBrand = brand.uppercased().replacingOccurrences(of: " ", with: "")
        let normalizedModel = model.uppercased()

        if legendaryBrands.contains(normalizedBrand) || legendaryModelKeywords.contains(where: { normalizedModel.contains($0) }) {
            return "Legendario"
        }

        if epicBrands.contains(normalizedBrand) {
            return "Épico"
        }

        if rareBrands.contains(normalizedBrand) {
            return "Raro"
        }

        if commonBrands.contains(normalizedBrand) {
            return "Común"
        }

        return "Raro"
    }

    func points(for rarity: String) -> Int {
        switch rarity {
        case "Común":
            return 5
        case "Raro":
            return 20
        case "Épico":
            return 50
        case "Legendario":
            return 150
        default:
            return 5
        }
    }
}
