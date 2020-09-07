// inOutSync

let InOutRange = [1, 2]

enum InOutEvent: Equatable {
    case In(_ value: Int)
    case Out(_ value: Int)
    case Sync(_ value: Int)
}

enum InState: Hashable {
    case In0
    case In1(_ value: Int)
}

enum OutState: Hashable {
    case Out0
    case Out1(_ value: Int)
}

func processIn(_ state: InState) -> [(InOutEvent, InState)] {
    switch state {
    case .In0:
        return InOutRange.map { (.Sync($0), .In1($0)) }
    case .In1(let value):
        return [(.In(value), .In0)]
    }
}

func processOut(_ state: OutState) -> [(InOutEvent, OutState)] {
    switch state {
    case .Out0:
        return InOutRange.map { (.Out($0), .Out1($0)) }
    case .Out1(let value):
        return [(.Sync(value), .Out0)]
    }
}

func main() {
    let graphIn = unfold(.In0, processIn)
    let graphOut = unfold(.Out0, processOut)
    printDot(compose(graphIn, graphOut, {
        if case .Sync(_) = $0 { return true } else { return false }
    }))
}
