//
//  UpdateSchedulerTests.swift
//  OpenGesturesTests

import OpenGestures
import Testing

@Suite
struct UpdateRequestTests {
    @Test(
        arguments: [
            (
                UpdateRequest(
                    id: 42,
                    creationTime: Timestamp(value: .seconds(10)),
                    targetTime: Timestamp(value: .seconds(15)),
                    tag: nil
                ),
                "{ 42, 5.0 seconds }"
            ),
            (
                UpdateRequest(
                    id: 7,
                    creationTime: Timestamp(value: .seconds(0)),
                    targetTime: Timestamp(value: .milliseconds(500)),
                    tag: "timer"
                ),
                #"{ 7 "timer", 0.5 seconds }"#
            )
        ]
    )
    func description(_ req: UpdateRequest, _ expectedDescription: String) {
        #expect(req.description == expectedDescription)
    }
}
