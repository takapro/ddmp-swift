//　Deadlock detector in Swift

typealias Graph<Event, State: Hashable> = [(State, [(Event, State)])]

extension Array {
    func indexOf<Key: Hashable, Value>(_ key: Key) -> Int? where Element == (Key, Value) {
        return self.firstIndex { $0.0 == key }
    }

    func valueOf<Key: Hashable, Value>(_ key: Key) -> Value? where Element == (Key, Value) {
        return self.first { $0.0 == key }?.1
    }
}

func unfold<Event, State: Hashable>(_ initial: State, _ process: (State) -> [(Event, State)]) -> Graph<Event, State> {
    var graph = Graph<Event, State>()
    var queue = [initial]
    while let state = queue.first {
        queue = Array(queue.dropFirst())
        if graph.indexOf(state) == nil {
            let transitions = process(state)
            graph.append((state, transitions))
            queue.append(contentsOf: transitions.map { $0.1 })
        }
    }
    return graph
}

func printDot<Event, State: Hashable>(_ graph: Graph<Event, State>) {
    print("digraph {")
    for (index, (state, transitions)) in graph.enumerated() {
        let color: String? = transitions.isEmpty ? "pink" : index == 0 ? "cyan" : nil
        let attr = color != nil ? ",color=\(color!),style=filled" : ""
        print("  \(index) [label=\"\(state)\"\(attr)];")
    }
    for (index, (_, transitions)) in graph.enumerated() {
        for (event, state) in transitions {
            print("  \(index) -> \(graph.indexOf(state)!) [label=\"\(event)\"];")
        }
    }
    print("}")
}
