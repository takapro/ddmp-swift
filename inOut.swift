// inOut

let InOutRange = [1, 2, 3]

enum InOutEvent {
    case In(_ value: Int)
    case Out(_ value: Int)
}

enum InOutState: Hashable {
    case S0
    case S1(_ value: Int)
}

func process(_ state: InOutState) -> [(InOutEvent, InOutState)] {
    switch state {
    case .S0:
        return InOutRange.map { (.In($0), .S1($0)) }
    case .S1(let value):
        return [(.Out(value), .S0)]
    }
}

func main() {
    printDot(unfold(.S0, process))
}
