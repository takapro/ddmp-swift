// Concurrent composition

struct ComposedState<State1: Hashable, State2: Hashable>: Hashable, CustomStringConvertible {
    let state1: State1
    let state2: State2

    init(_ state1: State1, _ state2: State2) {
        self.state1 = state1
        self.state2 = state2
    }

    var description: String {
        return "\(state1)\\n\(state2)"
    }
}

func compose<Event: Equatable, State1: Hashable, State2: Hashable>(
    _ graph1: Graph<Event, State1>,
    _ graph2: Graph<Event, State2>,
    _ isSync: (Event) -> Bool
) -> Graph<Event, ComposedState<State1, State2>> {
    return unfold(ComposedState(graph1.first!.0, graph2.first!.0), { state in
        var merged = [(Event, ComposedState<State1, State2>)]()
        let transitions1 = graph1.valueOf(state.state1)!
        let transitions2 = graph2.valueOf(state.state2)!
        for (event, state1) in transitions1 {
            if isSync(event) {
                for (_, state2) in transitions2.filter({ $0.0 == event }) {
                    merged.append((event, ComposedState(state1, state2)))
                }
            } else {
                merged.append((event, ComposedState(state1, state.state2)))
            }
        }
        for (event, state2) in transitions2 {
            if !isSync(event) {
                merged.append((event, ComposedState(state.state1, state2)))
            }
        }
        return merged
    })
}
