import SwiftUI

struct ContentView: View {
    @StateObject private var vm = GameViewModel()

    var body: some View {
        GeometryReader { geo in
            let columns = vm.state.columns
            let rows = vm.state.rows
            let boardWidth = geo.size.width
            let cellSize = boardWidth / CGFloat(columns)
            let boardHeight = cellSize * CGFloat(rows)

            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Score bar
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("SCORE")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            Text("\(vm.state.score)")
                                .font(.system(size: 28, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("BEST")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            Text("\(vm.state.highScore)")
                                .font(.system(size: 28, weight: .bold, design: .monospaced))
                                .foregroundColor(Color(red: 1, green: 0.8, blue: 0))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)

                    // Game board
                    GameBoardView(state: vm.state, cellSize: cellSize)
                        .frame(width: boardWidth, height: boardHeight)
                        .gesture(
                            DragGesture(minimumDistance: 20)
                                .onEnded { value in
                                    let dx = value.translation.width
                                    let dy = value.translation.height
                                    if abs(dx) > abs(dy) {
                                        vm.changeDirection(dx > 0 ? .right : .left)
                                    } else {
                                        vm.changeDirection(dy > 0 ? .down : .up)
                                    }
                                }
                        )

                    Spacer()

                    // Controls
                    HStack(alignment: .center) {
                        DPadView { vm.changeDirection($0) }

                        Spacer()

                        VStack(spacing: 16) {
                            if vm.state.status == .playing || vm.state.status == .paused {
                                Button(action: vm.pauseResume) {
                                    Image(systemName: vm.state.status == .paused ? "play.fill" : "pause.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                        .frame(width: 52, height: 52)
                                        .background(Color(white: 0.2))
                                        .clipShape(Circle())
                                }
                            }

                            Button(action: vm.startGame) {
                                Text(vm.state.status == .idle ? "START" : "RESTART")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.black)
                                    .frame(width: 80, height: 36)
                                    .background(Color(red: 0.2, green: 0.9, blue: 0.3))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 32)
                }

                // Overlay screens
                if vm.state.status == .idle {
                    overlayCard(
                        title: "SNAKE",
                        subtitle: "Swipe or use D-pad\nto control the snake",
                        buttonLabel: "START GAME",
                        buttonAction: vm.startGame
                    )
                }

                if vm.state.status == .gameOver {
                    overlayCard(
                        title: "GAME OVER",
                        subtitle: "Score: \(vm.state.score)",
                        buttonLabel: "PLAY AGAIN",
                        buttonAction: vm.startGame
                    )
                }

                if vm.state.status == .paused {
                    Text("PAUSED")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(Color(white: 0.12).opacity(0.95))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func overlayCard(
        title: String,
        subtitle: String,
        buttonLabel: String,
        buttonAction: @escaping () -> Void
    ) -> some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.system(size: 42, weight: .black, design: .rounded))
                .foregroundColor(.white)
            Text(subtitle)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            Button(action: buttonAction) {
                Text(buttonLabel)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                    .frame(width: 180, height: 50)
                    .background(Color(red: 0.2, green: 0.9, blue: 0.3))
                    .clipShape(Capsule())
            }
        }
        .padding(36)
        .background(Color(white: 0.1).opacity(0.97))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.6), radius: 20)
    }
}

#Preview {
    ContentView()
}
