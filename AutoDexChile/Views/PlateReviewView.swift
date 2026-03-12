import SwiftUI

/// Vista de revisión OCR antes de intentar lookup automático.
struct PlateReviewView: View {
    @StateObject var viewModel: PlateReviewViewModel
    @State private var goToLookup = false

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
                        Button(plate) { viewModel.applyCandidate(plate) }
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
                Button("Continuar y buscar datos") {
                    goToLookup = true
                }
                .disabled(viewModel.normalizedEditablePlate.isEmpty)
            }
        }
        .navigationTitle("Revisar patente")
        .navigationDestination(isPresented: $goToLookup) {
            LookupResultView(viewModel: LookupResultViewModel(draft: viewModel.confirmedDraft()))
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
                ),
                draft: .empty
            )
        )
    }
    .environmentObject(InventoryRepository())
}
