import SwiftUI

/// Tarjeta reutilizable para mostrar un auto en la colección.
struct CarCardView: View {
    let entry: CarEntry
    var onFavoriteTap: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.plate)
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
                Button {
                    onFavoriteTap?()
                } label: {
                    Image(systemName: entry.isFavorite ? "star.fill" : "star")
                        .foregroundStyle(entry.isFavorite ? .yellow : .secondary)
                }
                .buttonStyle(.plain)
            }

            Text("\(entry.brand) \(entry.model)")
                .font(.subheadline)
                .lineLimit(1)

            Text("Año \(entry.year)")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack {
                Text(entry.rarity)
                    .font(.caption2)
                    .bold()
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(rarityColor.opacity(0.2))
                    .clipShape(Capsule())

                Spacer()

                Text("\(entry.points) pts")
                    .font(.caption)
                    .bold()
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private var rarityColor: Color {
        switch entry.rarity {
        case "Común":
            return .gray
        case "Raro":
            return .blue
        case "Épico":
            return .purple
        case "Legendario":
            return .orange
        default:
            return .gray
        }
    }
}
