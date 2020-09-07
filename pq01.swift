// pq01

enum Event {
    case a, b, c
}

enum PState {
    case P0, P1, P2
}

enum QState {
    case Q0, Q1, Q2
}

func processP(_ state: PState) -> [(Event, PState)] {
    switch state {
    case .P0:
        return [(.a, .P1), (.b, .P2)]
    default:
        return []
    }
}

func processQ(_ state: QState) -> [(Event, QState)] {
    switch state {
    case .Q0:
        return [(.a, .Q1), (.c, .Q2)]
    default:
        return []
    }
}

func main() {
    let graphP = unfold(.P0, processP)
    let graphQ = unfold(.Q0, processQ)
    printDot(compose(graphP, graphQ, { $0 == .a }))
}
