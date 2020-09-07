// incr

enum IncrEvent {
    case Read
    case Incr
    case Write
}

enum IncrState: Hashable {
    case S0(_ x: Int)
    case S1(_ x: Int, _ t: Int)
    case S2(_ x: Int, _ t: Int)
    case S3(_ x: Int)
}

func process(_ state: IncrState) -> [(IncrEvent, IncrState)] {
    switch state {
    case .S0(let x):
        return [(.Read, .S1(x, x))]
    case .S1(let x, let t):
        return [(.Incr, .S2(x, t + 1))]
    case .S2(_, let t):
        return [(.Write, .S3(t))]
    case .S3(_):
        return []
    }
}

func main() {
    printDot(unfold(.S0(1), process))
}
