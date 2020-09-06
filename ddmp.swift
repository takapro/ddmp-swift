//　Deadlock detector in Swift

enum Range: Int, CaseIterable, CustomDebugStringConvertible {
    case v1 = 1, v2, v3

    var debugDescription: String {
        return "\(self.rawValue)"
    }
}

enum Event: Equatable, CustomDebugStringConvertible {
    case In(_ value: Range)
    case Out(_ value: Range)

    var debugDescription: String {
        switch self {
        case .In(let value):
            return "In(\(value))"
        case .Out(let value):
            return "Out(\(value))"
        }
    }
}

enum State: Hashable, CustomDebugStringConvertible {
    case S0
    case S1(_ value: Range)

    var debugDescription: String {
        switch self {
        case .S0:
            return "S0"
        case .S1(let value):
            return "S1(\(value))"
        }
    }
}

func process(_ state: State) -> [(Event, State)] {
    switch state {
    case .S0:
        return Range.allCases.map { (.In($0), .S1($0)) }
    case .S1(let value):
        return [(.Out(value), .S0)]
    }
}

typealias Graph = [(State, [(Event, State)])]

func unfold(_ process: (State) -> [(Event, State)], _ initial: State) -> Graph {
    var graph = Graph()
    var queue = [initial]
    var visited = Set<State>()
    while let state = queue.first {
        queue = Array(queue.dropFirst())
        if !visited.contains(state) {
            let transitions = process(state)
            graph.append((state, transitions))
            transitions.forEach { queue.append($0.1) }
            visited.insert(state)
        }
    }
    return graph
}

func printDot(_ graph: Graph) {
    print("digraph {")
    var indexOf = [State: Int]()
    for (index, (state, _)) in graph.enumerated() {
        indexOf[state] = index
        print("  \(index) [label=\"\(state)\"];")
    }
    for (from, transitions) in graph {
        for (event, to) in transitions {
            print("  \(indexOf[from]!) -> \(indexOf[to]!) [label=\"\(event)\"];")
        }
    }
    print("}")
}

printDot(unfold(process, .S0))
