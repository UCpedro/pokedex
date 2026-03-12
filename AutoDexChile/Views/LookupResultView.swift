import SwiftUI

/// Pantalla de intento de lookup automático con fallback manual.
struct LookupResultView: View {
    @StateObject var viewModel: LookupResultViewModel
    @State private var goToManual = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Buscando datos del vehículo")
                .font(.title3)
                .bold()

            switch viewModel.state {
            case .idle, .loading:
                ProgressView("Intentando búsqueda automática...")
                    .task {
                        guard viewModel.state == .idle else { return }
                        await viewModel.performLookup()
                    }

            case .success(let result):
                Form {
                    Section("Datos encontrados") {
                        row("Patente", result.plate)
                        row("Marca", result.brand)
                        row("Modelo", result.model)
                        row("Año", result.year.map(String.init) ?? "-")
                        row("Versión", result.version ?? "-")
                        row("Color", result.color ?? "-")
                        row("Tipo", result.vehicleType ?? "-")
                    }
                }

                Button("Continuar con estos datos") {
                    goToManual = true
                }
                .buttonStyle(.borderedProminent)

                Button("Editar manualmente") {
                    goToManual = true
                }
                .buttonStyle(.bordered)

            case .failure(let message):
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 42))
                    .foregroundStyle(.orange)

                Text(message)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                Button("Reintentar") {
                    Task { await viewModel.performLookup() }
                }
                .buttonStyle(.bordered)

                Button("Completar manualmente") {
                    goToManual = true
                }
                .buttonStyle(.borderedProminent)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Lookup automático")
        .navigationDestination(isPresented: $goToManual) {
            ManualEntryView(draft: viewModel.draft)
        }
    }

    private func row(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        LookupResultView(viewModel: LookupResultViewModel(draft: .empty))
    }
    .environmentObject(InventoryRepository())
}
