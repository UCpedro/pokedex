import SwiftUI

/// Vista simple para editar una ficha existente.
struct EditCarView: View {
    @EnvironmentObject private var repository: InventoryRepository
    @Environment(\.dismiss) private var dismiss

    let entryID: UUID

    @State private var plate = ""
    @State private var brand = ""
    @State private var model = ""
    @State private var year = ""
    @State private var version = ""
    @State private var color = ""
    @State private var vehicleType = ""
    @State private var notes = ""

    @State private var loaded = false

    private let rarityService = RarityService()

    private var normalizedPlate: String { ChilePlateNormalizer.normalize(plate) }

    var body: some View {
        Form {
            Section("Ficha") {
                TextField("Patente", text: $plate)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
                TextField("Marca", text: $brand)
                TextField("Modelo", text: $model)
                TextField("Año", text: $year)
                    .keyboardType(.numberPad)
            }

            Section("Opcional") {
                TextField("Versión", text: $version)
                TextField("Color", text: $color)
                TextField("Tipo", text: $vehicleType)
                TextField("Notas", text: $notes, axis: .vertical)
                    .lineLimit(2...5)
            }

            Section {
                Button("Guardar cambios") {
                    save()
                }
                .disabled(!isFormValid)
            }
        }
        .navigationTitle("Editar auto")
        .onAppear(perform: load)
    }

    private var isFormValid: Bool {
        guard let parsedYear = Int(year) else { return false }
        return ChilePlateValidator.isValid(normalizedPlate) && !brand.trimmingCharacters(in: .whitespaces).isEmpty && !model.trimmingCharacters(in: .whitespaces).isEmpty && parsedYear >= 1900
    }

    private func load() {
        guard !loaded, let entry = repository.find(by: entryID) else { return }
        plate = entry.plate
        brand = entry.brand
        model = entry.model
        year = String(entry.year)
        version = entry.version ?? ""
        color = entry.color ?? ""
        vehicleType = entry.vehicleType ?? ""
        notes = entry.notes ?? ""
        loaded = true
    }

    private func save() {
        guard let existing = repository.find(by: entryID), let parsedYear = Int(year) else { return }

        let rarity = rarityService.rarity(forBrand: brand, model: model)
        let points = rarityService.points(for: rarity)

        let updated = CarEntry(
            id: existing.id,
            plate: normalizedPlate,
            brand: brand.trimmingCharacters(in: .whitespacesAndNewlines),
            model: model.trimmingCharacters(in: .whitespacesAndNewlines),
            year: parsedYear,
            version: version.nilIfBlank,
            vehicleType: vehicleType.nilIfBlank,
            color: color.nilIfBlank,
            notes: notes.nilIfBlank,
            rarity: rarity,
            points: points,
            isFavorite: existing.isFavorite,
            sourceType: existing.sourceType,
            createdAt: existing.createdAt,
            updatedAt: Date()
        )

        repository.update(updated)
        dismiss()
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
        EditCarView(entryID: UUID())
    }
    .environmentObject(InventoryRepository())
}
