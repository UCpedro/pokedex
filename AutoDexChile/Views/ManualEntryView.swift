import SwiftUI

/// Pantalla de ingreso manual para crear una ficha inicial de auto.
struct ManualEntryView: View {
    @EnvironmentObject private var repository: InventoryRepository

    @State private var plate: String
    @State private var brand: String = ""
    @State private var model: String = ""
    @State private var year: String = ""
    @State private var version: String = ""
    @State private var vehicleType: String = ""
    @State private var color: String = ""
    @State private var notes: String = ""

    @State private var showValidation = false
    @State private var goToCollection = false

    private let rarityService = RarityService()

    init(prefilledPlate: String) {
        _plate = State(initialValue: prefilledPlate)
    }

    private var normalizedPlate: String {
        ChilePlateNormalizer.normalize(plate)
    }

    private var parsedYear: Int? {
        Int(year)
    }

    private var yearIsValid: Bool {
        guard let parsedYear else { return false }
        let currentYear = Calendar.current.component(.year, from: Date())
        return (1900...(currentYear + 1)).contains(parsedYear)
    }

    private var formIsValid: Bool {
        !normalizedPlate.isEmpty && ChilePlateValidator.isValid(normalizedPlate) && !brand.trimmingCharacters(in: .whitespaces).isEmpty && !model.trimmingCharacters(in: .whitespaces).isEmpty && yearIsValid
    }

    var body: some View {
        Form {
            Section("Ficha base") {
                TextField("Patente", text: $plate)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()

                Text("Patente limpia: \(normalizedPlate)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                TextField("Marca (ej: Toyota)", text: $brand)
                TextField("Modelo (ej: Yaris)", text: $model)
                TextField("Año (ej: 2020)", text: $year)
                    .keyboardType(.numberPad)
            }

            Section("Detalles opcionales") {
                TextField("Versión", text: $version)
                TextField("Color", text: $color)
                TextField("Tipo de vehículo", text: $vehicleType)
                TextField("Notas", text: $notes, axis: .vertical)
                    .lineLimit(2...5)
            }

            if showValidation && !formIsValid {
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Revisa los datos requeridos:")
                            .bold()
                        Text("• Patente válida (AA1111 o AAAA11)")
                        Text("• Marca y modelo obligatorios")
                        Text("• Año entre 1900 y actual + 1")
                    }
                    .font(.footnote)
                    .foregroundStyle(.red)
                }
            }

            Section {
                Button("Guardar") {
                    handleSave()
                }
            }
        }
        .navigationTitle("Ingreso manual")
        .navigationDestination(isPresented: $goToCollection) {
            CollectionView()
        }
    }

    private func handleSave() {
        guard formIsValid, let parsedYear else {
            showValidation = true
            return
        }

        let computedRarity = rarityService.rarity(forBrand: brand, model: model)
        let computedPoints = rarityService.points(for: computedRarity)

        let newEntry = CarEntry(
            plate: normalizedPlate,
            brand: brand.trimmingCharacters(in: .whitespacesAndNewlines),
            model: model.trimmingCharacters(in: .whitespacesAndNewlines),
            year: parsedYear,
            version: version.nilIfBlank,
            vehicleType: vehicleType.nilIfBlank,
            color: color.nilIfBlank,
            notes: notes.nilIfBlank,
            rarity: computedRarity,
            points: computedPoints,
            isFavorite: false,
            sourceType: .manual
        )

        repository.save(newEntry)
        goToCollection = true
    }
}

private extension String {
    var nilIfBlank: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}

#Preview {
    NavigationStack {
        ManualEntryView(prefilledPlate: "ABCD12")
    }
    .environmentObject(InventoryRepository())
}
