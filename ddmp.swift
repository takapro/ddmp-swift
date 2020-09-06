//　Deadlock detector in Swift

typealias Graph<State: Hashable, Event> = [(State, [(Event, State)])]

func unfold<State: Hashable, Event>(_ process: (State) -> [(Event, State)], _ initial: State) -> Graph<State, Event> {
    var graph = Graph<State, Event>()
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

func printDot<State: Hashable, Event>(_ graph: Graph<State, Event>) {
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
