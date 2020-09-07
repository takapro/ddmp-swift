// incrMutex

let Range = [0, 1, 2]

enum MutexEvent: Equatable {
    case Lock
    case Unlock
    case Read(_ value: Int)
    case Write(_ value: Int)
}

enum MutexState: Hashable {
    case U, L
}

func processMutex(_ state: MutexState) -> [(MutexEvent, MutexState)] {
    switch state {
    case .U:
        return [(.Lock, .L)]
    case .L:
        return [(.Unlock, .U)]
    }
}

enum ShmState: Hashable {
    case M(_ value: Int)
}

func processShm(_ state: ShmState) -> [(MutexEvent, ShmState)] {
    switch state {
    case .M(let value):
        return [(.Read(value), .M(value))] + Range.map { (.Write($0), .M($0)) }
    }
}

enum IncrState: Hashable, CustomStringConvertible {
    case Sx(_ name: String, _ state: Int)
    case S2(_ name: String, _ value: Int)

    var description: String {
        switch self {
        case .Sx(let name, let state):
            return "\(name)\(state)"
        case .S2(let name, let value):
            return "\(name)2(\(value))"
        }
    }
}

func processIncr(_ state: IncrState) -> [(MutexEvent, IncrState)] {
    switch state {
    case .Sx(let name, 0):
        return [(.Lock, .Sx(name, 1))]
    case .Sx(let name, 1):
        return Range.map { (.Read($0), .S2(name, $0)) }
    case .S2(let name, let value):
        return [(.Write(value + 1), .Sx(name, 3))]
    case .Sx(let name, 3):
        return [(.Unlock, .Sx(name, 4))]
    case .Sx(_, _):
        return []
    }
}

func main() {
    let incrMutex = compose(
        compose(
            unfold(.U, processMutex),
            unfold(.M(Range.first!), processShm),
            { _ in false }
        ),
        compose(
            unfold(.Sx("P", 0), processIncr),
            unfold(.Sx("Q", 0), processIncr),
            { _ in false }
        ),
        { _ in true }
    )
    printDot(incrMutex)
}
