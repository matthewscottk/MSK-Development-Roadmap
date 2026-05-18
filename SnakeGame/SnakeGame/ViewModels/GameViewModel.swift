import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published var state: GameState
    private var timer: AnyCancellable?
    private var tickInterval: TimeInterval = 0.15

    init() {
        state = GameState()
    }

    var speedInterval: TimeInterval {
        // Speed up gradually as score increases
        max(0.07, tickInterval - Double(state.score / 50) * 0.005)
    }

    func startGame() {
        state.reset()
        state.status = .playing
        startTimer()
    }

    func pauseResume() {
        switch state.status {
        case .playing:
            state.status = .paused
            timer?.cancel()
        case .paused:
            state.status = .playing
            startTimer()
        default:
            break
        }
    }

    func changeDirection(_ newDir: Direction) {
        guard state.status == .playing else { return }
        if newDir != state.direction.opposite {
            state.nextDirection = newDir
        }
    }

    private func startTimer() {
        timer?.cancel()
        timer = Timer.publish(every: speedInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.state.tick()
                if self?.state.status == .gameOver {
                    self?.timer?.cancel()
                }
            }
    }
}
