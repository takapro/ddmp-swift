// incrShm

let Range = [0, 1, 2]

enum ShmEvent: Equatable {
    case Read(_ value: Int)
    case Write(_ value: Int)
}

enum ShmState: Hashable {
    case M(_ value: Int)
}

func processShm(_ state: ShmState) -> [(ShmEvent, ShmState)] {
    switch state {
    case .M(let value):
        return [(.Read(value), .M(value))] + Range.map { (.Write($0), .M($0)) }
    }
}

enum IncrState: Hashable, CustomStringConvertible {
    case S0(_ name: String)
    case S1(_ name: String, _ value: Int)
    case S2(_ name: String)

    var description: String {
        switch self {
        case .S0(let name):
            return "\(name)0"
        case .S1(let name, let value):
            return "\(name)1(\(value))"
        case .S2(let name):
            return "\(name)2"
        }
    }
}

func processIncr(_ state: IncrState) -> [(ShmEvent, IncrState)] {
    switch state {
    case .S0(let name):
        return Range.map { (.Read($0), .S1(name, $0)) }
    case .S1(let name, let value):
        return [(.Write(value + 1), .S2(name))]
    case .S2(_):
        return []
    }
}

func main() {
    let incrShm = compose(
        unfold(.M(Range.first!), processShm),
        compose(
            unfold(.S0("P"), processIncr),
            unfold(.S0("Q"), processIncr),
            { _ in false }
        ),
        { _ in true }
    )
    printDot(incrShm)
}
