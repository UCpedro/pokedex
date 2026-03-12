import SwiftUI

/// Pantalla de ingreso/edición manual final antes de guardar la ficha.
struct ManualEntryView: View {
    @EnvironmentObject private var repository: InventoryRepository

    private let draft: ScanDraft

    @State private var plate: String
    @State private var brand: String
    @State private var model: String
    @State private var year: String
    @State private var version: String
    @State private var vehicleType: String
    @State private var color: String
    @State private var notes: String

    @State private var showValidation = false
    @State private var goToCollection = false

    private let rarityService = RarityService()

    init(draft: ScanDraft) {
        self.draft = draft
        let lookup = draft.lookupResult

        _plate = State(initialValue: draft.normalizedPlate)
        _brand = State(initialValue: lookup?.brand ?? "")
        _model = State(initialValue: lookup?.model ?? "")
        _year = State(initialValue: lookup?.year.map(String.init) ?? "")
        _version = State(initialValue: lookup?.version ?? "")
        _vehicleType = State(initialValue: lookup?.vehicleType ?? "")
        _color = State(initialValue: lookup?.color ?? "")
        _notes = State(initialValue: lookup?.notes ?? "")
    }

    init(prefilledPlate: String) {
        self.init(draft: ScanDraft(
            plateRawText: "",
            normalizedPlate: prefilledPlate,
            carImagePath: nil,
            plateImagePath: nil,
            lookupResult: nil
        ))
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
        !normalizedPlate.isEmpty && ChilePlateValidator.isValid(normalizedPlate) && !brand.trimmed.isEmpty && !model.trimmed.isEmpty && yearIsValid
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

            Section("Fotos") {
                Label(draft.carImagePath == nil ? "Sin foto de auto" : "Foto de auto adjunta", systemImage: draft.carImagePath == nil ? "xmark.circle" : "checkmark.circle.fill")
                    .foregroundStyle(draft.carImagePath == nil ? .secondary : .green)

                Label(draft.plateImagePath == nil ? "Sin foto de patente" : "Foto de patente adjunta", systemImage: draft.plateImagePath == nil ? "xmark.circle" : "checkmark.circle.fill")
                    .foregroundStyle(draft.plateImagePath == nil ? .secondary : .green)
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
        .navigationTitle("Completar ficha")
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

        let finalCarPath = draft.carImagePath.map(ImageStorageHelper.copyImageToDocumentsIfNeeded)
        let finalPlatePath = draft.plateImagePath.map(ImageStorageHelper.copyImageToDocumentsIfNeeded)

        let newEntry = CarEntry(
            plate: normalizedPlate,
            brand: brand.trimmed,
            model: model.trimmed,
            year: parsedYear,
            version: version.nilIfBlank,
            vehicleType: vehicleType.nilIfBlank,
            color: color.nilIfBlank,
            notes: notes.nilIfBlank,
            rarity: computedRarity,
            points: computedPoints,
            isFavorite: false,
            photoCarPath: finalCarPath,
            photoPlatePath: finalPlatePath,
            sourceType: draft.lookupResult == nil ? .manual : .web
        )

        repository.save(newEntry)
        goToCollection = true
    }
}

private extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var nilIfBlank: String? {
        let value = trimmed
        return value.isEmpty ? nil : value
    }
}

#Preview {
    NavigationStack {
        ManualEntryView(prefilledPlate: "ABCD12")
    }
    .environmentObject(InventoryRepository())
}
