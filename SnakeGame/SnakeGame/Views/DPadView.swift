import SwiftUI

struct DPadView: View {
    let onDirection: (Direction) -> Void

    private let size: CGFloat = 130

    var body: some View {
        ZStack {
            // Center circle background
            Circle()
                .fill(Color(white: 0.18))
                .frame(width: size * 0.38, height: size * 0.38)

            // Up
            arrowButton(direction: .up, systemImage: "chevron.up")
                .offset(y: -size * 0.35)

            // Down
            arrowButton(direction: .down, systemImage: "chevron.down")
                .offset(y: size * 0.35)

            // Left
            arrowButton(direction: .left, systemImage: "chevron.left")
                .offset(x: -size * 0.35)

            // Right
            arrowButton(direction: .right, systemImage: "chevron.right")
                .offset(x: size * 0.35)
        }
        .frame(width: size, height: size)
    }

    private func arrowButton(direction: Direction, systemImage: String) -> some View {
        Button {
            onDirection(direction)
        } label: {
            Circle()
                .fill(Color(white: 0.22))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: systemImage)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                )
        }
        .buttonStyle(.plain)
    }
}
