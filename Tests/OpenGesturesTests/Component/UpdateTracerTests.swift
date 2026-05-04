//
//  UpdateTracerTests.swift
//  OpenGesturesTests

import OpenGestures
import Testing

// MARK: - TraceRenderingTests

@Suite
struct TraceRenderingTests {
    @Test(arguments: [
        (
            Trace(id: 1),
            [
                Int16(1): traceDataSnapshot(
                    component: "RootComponent<Payload>",
                    state: "State\nroot state",
                    result: "root result\nsecond result"
                ),
            ],
            "P: ",
            "| ",
            #"""
            P: RootComponent
            | root state
            | Output: root result
            | second result
            """# + "\n"
        ),
        (
            Trace(
                id: 10,
                upstreamTraces: [
                    Trace(id: 11),
                    Trace(
                        id: 12,
                        upstreamTraces: [
                            Trace(id: 13),
                        ]
                    ),
                ]
            ),
            [
                Int16(10): traceDataSnapshot(
                    component: "Root<Payload>",
                    state: "State\nroot state",
                    result: "root result"
                ),
                Int16(11): traceDataSnapshot(
                    component: "FirstChild",
                    state: "State\nchild state",
                    result: "child error\nsecond line",
                    isSuccess: false
                ),
                Int16(13): traceDataSnapshot(
                    component: "GrandChild"
                ),
            ],
            "",
            "",
            #"""
            Root
            root state
            Output: root result
            ↑
            │
            ├── FirstChild
            │   child state
            │   Error: child error
            │   second line
            │
            └── UnknownComponent

                ↑
                │
                └── GrandChild

            """# + "\n"
        ),
    ])
    func rendered(
        _ trace: Trace,
        _ snapshots: [Int16: TraceDataSnapshot],
        _ prefix: String,
        _ childPrefix: String,
        _ expectedString: String
    ) {
        #expect(
            trace.rendered(
                using: snapshots,
                prefix: prefix,
                childPrefix: childPrefix
            ) == expectedString
        )
    }
}

private func traceDataSnapshot(
    component: String,
    state: String = "",
    result: String = "",
    isSuccess: Bool = true
) -> TraceDataSnapshot {
    TraceDataSnapshot(
        component: { component },
        result: { result },
        state: { state },
        isSuccess: isSuccess
    )
}
