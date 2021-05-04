import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AVPlayerItem_PublishersTests.allTests),
        testCase(PlayheadProgressPublisherTests.allTests),
        testCase(AVAsset_CommonMetadataPublisherTests.allTests)
    ]
}
#endif
