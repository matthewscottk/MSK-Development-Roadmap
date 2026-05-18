import Foundation

enum Direction {
    case up, down, left, right

    var opposite: Direction {
        switch self {
        case .up: return .down
        case .down: return .up
        case .left: return .right
        case .right: return .left
        }
    }
}

enum GameStatus {
    case idle, playing, paused, gameOver
}

struct Position: Equatable, Hashable {
    var col: Int
    var row: Int
}

struct GameState {
    let columns: Int
    let rows: Int

    var snake: [Position]
    var food: Position
    var direction: Direction
    var nextDirection: Direction
    var status: GameStatus
    var score: Int
    var highScore: Int

    init(columns: Int = 20, rows: Int = 35) {
        self.columns = columns
        self.rows = rows

        let startCol = columns / 2
        let startRow = rows / 2
        snake = [
            Position(col: startCol, row: startRow),
            Position(col: startCol, row: startRow + 1),
            Position(col: startCol, row: startRow + 2),
        ]
        direction = .up
        nextDirection = .up
        status = .idle
        score = 0
        highScore = 0
        food = Position(col: 0, row: 0)
        food = randomFood()
    }

    mutating func randomFood() -> Position {
        var candidate: Position
        repeat {
            candidate = Position(
                col: Int.random(in: 0..<columns),
                row: Int.random(in: 0..<rows)
            )
        } while snake.contains(candidate)
        return candidate
    }

    mutating func tick() {
        guard status == .playing else { return }
        direction = nextDirection

        let head = snake[0]
        let newHead: Position
        switch direction {
        case .up:    newHead = Position(col: head.col, row: head.row - 1)
        case .down:  newHead = Position(col: head.col, row: head.row + 1)
        case .left:  newHead = Position(col: head.col - 1, row: head.row)
        case .right: newHead = Position(col: head.col + 1, row: head.row)
        }

        // Wall collision
        if newHead.col < 0 || newHead.col >= columns || newHead.row < 0 || newHead.row >= rows {
            status = .gameOver
            return
        }

        // Self collision (ignore tail since it will move)
        if snake.dropLast().contains(newHead) {
            status = .gameOver
            return
        }

        snake.insert(newHead, at: 0)

        if newHead == food {
            score += 10
            if score > highScore { highScore = score }
            food = randomFood()
        } else {
            snake.removeLast()
        }
    }

    mutating func reset() {
        let saved = highScore
        self = GameState(columns: columns, rows: rows)
        highScore = saved
    }
}
