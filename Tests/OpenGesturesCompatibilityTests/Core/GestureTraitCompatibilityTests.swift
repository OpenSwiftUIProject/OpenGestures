//
//  GestureTraitCompatibilityTests.swift
//  OpenGesturesCompatibilityTests

import Testing

// MARK: - GestureTraitCompatibilityTests

@Suite
struct GestureTraitCompatibilityTests {
    @Test
    func initializer() {
        let trait = GestureTrait(id: .longPress, attributes: [:])
        _ = trait
    }

    @Test
    func identifiable() {
        let box: any Identifiable = GestureTrait.tap()
        _ = box.id
    }

    // MARK: - Description

    @Test(arguments: [
        (GestureTrait.pan(), "pan"),
        (GestureTrait.tap(), "tap"),
        (GestureTrait.longPress(), "longPress"),
        (GestureTrait.tap(tapCount: 1), "tap {tapCount: 1}"),
        (GestureTrait.tap(pointCount: 2), "tap {pointCount: 2}"),
        (GestureTrait.longPress(maximumMovement: 10.0), "longPress {maximumMovement: 10.0}"),
    ])
    func description(_ trait: GestureTrait, _ expectedDescription: String) {
        #expect("\(trait)" == expectedDescription)
    }

    @Test
    func descriptionMultipleAttributes() {
        let trait = GestureTrait.tap(tapCount: 1, pointCount: 3)
        let description = "\(trait)"
        // Dictionary ordering of attributes is non-deterministic
        #expect(description == "tap {tapCount: 1, pointCount: 3}" || description == "tap {pointCount: 3, tapCount: 1}")
    }

    // MARK: - GestureTrait Factory Methods

    @Test
    func pan() {
        let trait = GestureTrait.pan()
        #expect(trait.id == .pan)
        #expect(trait.attributes.isEmpty)
    }

    @Test
    func tapDefaults() {
        let trait = GestureTrait.tap()
        #expect(trait.id == .tap)
        #expect(trait.attributes.isEmpty)
    }

    @Test
    func tapWithParameters() {
        let trait = GestureTrait.tap(tapCount: 2, pointCount: 1)
        #expect(trait.id == .tap)
        #expect(trait.attributes[.tapCount] == .int(2))
        #expect(trait.attributes[.pointCount] == .int(1))
    }

    @Test
    func longPressDefaults() {
        let trait = GestureTrait.longPress()
        #expect(trait.id == .longPress)
        #expect(trait.attributes.isEmpty)
    }

    @Test
    func longPressWithParameters() {
        let trait = GestureTrait.longPress(
            pointCount: 1,
            minimumDuration: .seconds(0.5),
            maximumMovement: 10.0
        )
        #expect(trait.id == .longPress)
        #expect(trait.attributes[.pointCount] == .int(1))
        #expect(trait.attributes[.minimumDuration] == .double(0.5))
        #expect(trait.attributes[.maximumMovement] == .double(10.0))
    }

    @Suite
    struct AttributeKeyCompatibilityTests {
        @Test(arguments: [
            (.pointCount, "pointCount"),
            (.tapCount, "tapCount"),
            (.minimumDuration, "minimumDuration"),
            (.maximumMovement, "maximumMovement"),
        ] as [(GestureTrait.AttributeKey, String)])
        func description(_ key: GestureTrait.AttributeKey, _ expected: String) {
            #expect(key.description == expected)
        }
    }

    // MARK: - AttributeValueCompatibilityTests

    @Suite
    struct AttributeValueCompatibilityTests {
        @Test(arguments: [
            (.bool(true), "true"),
            (.bool(false), "false"),
            (.int(42), "42"),
            (.double(1.5), "1.5"),
        ] as [(GestureTrait.AttributeValue, String)])
        func description(_ value: GestureTrait.AttributeValue, _ expected: String) {
            #expect(value.description == expected)
        }
    }
}

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
