import SwiftUI

/// Vista de revisión de resultado OCR y edición manual de patente.
struct PlateReviewView: View {
    @StateObject var viewModel: PlateReviewViewModel

    @State private var goToManualEntry = false

    var body: some View {
        Form {
            Section("Texto OCR crudo") {
                Text(viewModel.rawText.isEmpty ? "Sin texto detectado" : viewModel.rawText)
                    .font(.footnote)
            }

            Section("Patente normalizada") {
                Text(viewModel.normalizedFromOCR.isEmpty ? "Sin candidata" : viewModel.normalizedFromOCR)
                    .font(.headline)
            }

            if !viewModel.candidatePlates.isEmpty {
                Section("Candidatas detectadas") {
                    ForEach(viewModel.candidatePlates, id: \.self) { plate in
                        Button(plate) {
                            viewModel.applyCandidate(plate)
                        }
                    }
                }
            }

            Section("Corrección manual") {
                TextField("Ingresa o corrige la patente", text: $viewModel.editablePlate)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()

                Text("Limpia: \(viewModel.normalizedEditablePlate)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                HStack {
                    Text("Estado")
                    Spacer()
                    Text(viewModel.isValidPlate ? "Válida" : "No válida")
                        .foregroundStyle(viewModel.isValidPlate ? .green : .orange)
                        .bold()
                }
            }

            Section {
                Button("Continuar") {
                    goToManualEntry = true
                }
                .disabled(viewModel.normalizedEditablePlate.isEmpty)
            }
        }
        .navigationTitle("Revisar patente")
        .navigationDestination(isPresented: $goToManualEntry) {
            ManualEntryView(prefilledPlate: viewModel.normalizedEditablePlate)
        }
    }
}

#Preview {
    NavigationStack {
        PlateReviewView(
            viewModel: PlateReviewViewModel(
                result: OCRResult(
                    rawText: "AB CD 12 CHILE",
                    normalizedPlate: "ABCD12",
                    isValidPlate: true,
                    candidatePlates: ["ABCD12"]
                )
            )
        )
    }
    .environmentObject(InventoryRepository())
}
