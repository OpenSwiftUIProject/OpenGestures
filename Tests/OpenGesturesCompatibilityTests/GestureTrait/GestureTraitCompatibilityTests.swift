//
//  GestureTraitCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import Testing

// MARK: - GestureTraitIDCompatibilityTests

@Suite
struct GestureTraitIDCompatibilityTests {
    @Test
    func staticPropertiesAreUnique() {
        let ids: [GestureTraitID] = [.tap, .longPress, .pan]
        #expect(Set(ids).count == 3)
    }

    @Test
    func equality() {
        let a = GestureTraitID.tap
        let b = GestureTraitID.tap
        #expect(a == b)
        #expect(a != .pan)
    }

    @Test
    func hashable() {
        var set: Set<GestureTraitID> = []
        set.insert(.tap)
        set.insert(.tap)
        #expect(set.count == 1)
    }
}

// MARK: - GestureTraitCollectionCompatibilityTests

@Suite
struct GestureTraitCollectionCompatibilityTests {
    @Test
    func withTrait() {
        let collection = GestureTraitCollection.withTrait(.pan())
        #expect(collection.allTraits.count == 1)
        #expect(collection.allTraits.first?.id == .pan)
    }

    @Test
    func initWithArray() {
        let collection = GestureTraitCollection(traits: [.tap(), .pan()])
        #expect(collection.allTraits.count == 2)
    }

    @Test
    func initDeduplicatesByID() {
        let collection = GestureTraitCollection(traits: [
            .tap(tapCount: 1),
            .tap(tapCount: 2),
        ])
        #expect(collection.allTraits.count == 1)
        #expect(collection.allTraits.first?.attributes[.tapCount] == .int(2))
    }

    @Test
    func containsSubtraits() {
        let full = GestureTraitCollection(traits: [.tap(), .pan()])
        let sub = GestureTraitCollection.withTrait(.tap())
        #expect(full.containsSubtraits(from: sub) == true)
        #expect(sub.containsSubtraits(from: full) == false)
    }

    @Test(arguments: [
        (GestureTraitCollection.withTrait(.pan()), "[pan]"),
        (GestureTraitCollection.withTrait(.tap(tapCount: 1)), "[tap {tapCount: 1}]"),
    ])
    func description(_ collection: GestureTraitCollection, _ expectedDescription: String) {
        #expect("\(collection)" == expectedDescription)
    }

    @Test
    func descriptionMultipleAttributes() {
        let collection = GestureTraitCollection.withTrait(.tap(tapCount: 1, pointCount: 3))
        let description = "\(collection)"
        // Dictionary ordering of attributes is non-deterministic
        #expect(description == "[tap {tapCount: 1, pointCount: 3}]" || description == "[tap {pointCount: 3, tapCount: 1}]")

    }

    @Test
    func descriptionMultipleTraits() {
        let collection = GestureTraitCollection(traits: [.pan(), .tap()])
        let description = "\(collection)"
        // Dictionary ordering of traits is non-deterministic
        #expect(description == "[tap, pan]" || description == "[pan, tap]")
    }
}
