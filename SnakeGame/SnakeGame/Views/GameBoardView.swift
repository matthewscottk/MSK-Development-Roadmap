import SwiftUI

struct GameBoardView: View {
    let state: GameState
    let cellSize: CGFloat

    var body: some View {
        Canvas { context, size in
            // Background
            context.fill(
                Path(CGRect(origin: .zero, size: size)),
                with: .color(Color(white: 0.07))
            )

            // Grid lines (subtle)
            for col in 0...state.columns {
                let x = CGFloat(col) * cellSize
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                context.stroke(path, with: .color(Color(white: 0.12)), lineWidth: 0.5)
            }
            for row in 0...state.rows {
                let y = CGFloat(row) * cellSize
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path, with: .color(Color(white: 0.12)), lineWidth: 0.5)
            }

            // Food
            let foodRect = cellRect(state.food)
            let foodInset = foodRect.insetBy(dx: 2, dy: 2)
            context.fill(
                Path(ellipseIn: foodInset),
                with: .color(.red)
            )

            // Snake body
            for (i, pos) in state.snake.enumerated() {
                let rect = cellRect(pos).insetBy(dx: 1, dy: 1)
                let green = i == 0
                    ? Color(red: 0.2, green: 0.9, blue: 0.3)
                    : Color(red: 0.15, green: 0.65, blue: 0.2)
                context.fill(
                    Path(roundedRect: rect, cornerRadius: i == 0 ? 4 : 2),
                    with: .color(green)
                )
            }
        }
    }

    private func cellRect(_ pos: Position) -> CGRect {
        CGRect(
            x: CGFloat(pos.col) * cellSize,
            y: CGFloat(pos.row) * cellSize,
            width: cellSize,
            height: cellSize
        )
    }
}
