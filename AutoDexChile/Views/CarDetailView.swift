import SwiftUI

/// Vista de detalle completa de una ficha de auto.
struct CarDetailView: View {
    @EnvironmentObject private var repository: InventoryRepository
    @Environment(\.dismiss) private var dismiss

    let entryID: UUID

    @State private var entry: CarEntry?
    @State private var showEdit = false

    var body: some View {
        Group {
            if let entry {
                List {
                    Section("Resumen") {
                        Text(entry.plate)
                            .font(.title2)
                            .bold()
                        Text("\(entry.brand) \(entry.model)")
                        Text("Año: \(entry.year)")
                    }

                    Section("Detalles") {
                        detailRow("Versión", value: entry.version)
                        detailRow("Color", value: entry.color)
                        detailRow("Tipo", value: entry.vehicleType)
                        detailRow("Notas", value: entry.notes)
                    }

                    Section("Progreso") {
                        detailRow("Rareza", value: entry.rarity)
                        detailRow("Puntos", value: "\(entry.points)")
                        detailRow("Favorito", value: entry.isFavorite ? "Sí" : "No")
                    }

                    Section("Fechas") {
                        detailRow("Creado", value: entry.createdAt.formatted(date: .abbreviated, time: .shortened))
                        detailRow("Actualizado", value: entry.updatedAt.formatted(date: .abbreviated, time: .shortened))
                    }

                    Section {
                        Button(entry.isFavorite ? "Quitar de favoritos" : "Marcar favorito") {
                            repository.toggleFavorite(id: entry.id)
                            refresh()
                        }

                        Button("Editar") {
                            showEdit = true
                        }

                        Button("Borrar", role: .destructive) {
                            repository.delete(id: entry.id)
                            dismiss()
                        }
                    }
                }
                .navigationTitle("Detalle")
                .navigationDestination(isPresented: $showEdit) {
                    EditCarView(entryID: entry.id)
                }
            } else {
                ContentUnavailableView("Auto no encontrado", systemImage: "car")
            }
        }
        .onAppear(perform: refresh)
        .onChange(of: repository.entries) { _, _ in
            refresh()
        }
    }

    @ViewBuilder
    private func detailRow(_ title: String, value: String?) -> some View {
        if let value, !value.isEmpty {
            HStack {
                Text(title)
                Spacer()
                Text(value)
                    .multilineTextAlignment(.trailing)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func refresh() {
        entry = repository.find(by: entryID)
    }
}

#Preview {
    NavigationStack {
        CarDetailView(entryID: UUID())
    }
    .environmentObject(InventoryRepository())
}
