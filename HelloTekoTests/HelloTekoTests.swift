//
//  HelloTekoTests.swift
//  HelloTekoTests
//
//  Created by thien on 3/27/21.
//  Copyright © 2021 thiennq. All rights reserved.
//

import XCTest
@testable import HelloTeko

class HelloTekoTests: XCTestCase {
}

// MARK: - Empty Search String
extension HelloTekoTests {

    func test_emptySearchStringMatchesAnything() {
        test("", matches: "")
        test("", matches: "hello")
        test("", matches: "hello, world")
    }
}

// MARK: - Single Word Search String
extension HelloTekoTests {

    func test_singleWordSearchStringMatchesPrefixes() {
        test("acer", matches: "acer")
        test("acer", matches: "acerlaptop")
    }

    func test_singleWordSearchStringMatchesCaseInsensitive() {
        test("acer", matches: "AceR")
        test("aCeR", matches: "acEr")
    }

    func test_singleWordSearchStringDoesNotMatchNonPrefixes() {
        test("w", doesNotMatch: "acer")
        test("op", doesNotMatch: "laptop")
    }
    
    func test_singleWordSearchStringMatchesDiacriticCaseInsensitive() {
        test("séarch", matches: "search")
        test("search", matches: "sÉarch")
    }
}

// MARK: - Multiple Word Search String
extension HelloTekoTests {

    func test_multipleWordSearchStringMatchesSingleWordPrefixes() {
        test("l", matches: "acer laptop")
        test("ac", matches: "acer laptop")
        test("la", matches: "acer laptop")
    }

    func test_multipleWordSearchStringMatchesMultipleWordPrefixes() {
        test("s s", matches: "search seaside")
        test("sea s", matches: "search seaside")
        test("sea sea", matches: "search seaside")
        test("seas sea", matches: "search seaside")
        test("sear sea", matches: "search seaside")
        test("sea sear", matches: "search seaside")
        test("seas sear", matches: "search seaside")

        // This tests that "sea" matches against "seaside" (as it is the longer token)
        test("sea search", matches: "search seaside")

        test("search sea", matches: "search seaside")
        test("seaside se", matches: "search seaside")
        test("s seaside", matches: "search seaside")
    }

    func test_multipleWordSearchStringDoesNotMatchNonPrefixes() {
        test("x", doesNotMatch: "search string")
        test("se se", doesNotMatch: "search string")
        test("search se", doesNotMatch: "search string")
    }

    func test_multipleWordSearchStringDoesNotMatchExcessSearchTermTokens() {
        test("s s s", doesNotMatch: "search string")
        test("st sea s", doesNotMatch: "search string")
    }
}

// MARK: - Space Stripping
extension HelloTekoTests {

    func test_searchStringIsSpaceStripped() {
        test("s", matches: "  search  string    ")
        test("sea", matches: "  search  string    ")
        test("st", matches: "  search  string    ")
        test("str sear", matches: "  search  string    ")
    }

    func test_searchMatchIgnoresExtraSpaces() {
        test(" s", matches: "search string")
        test(" s  ", matches: "search string")
        test(" str  sea  ", matches: "search string")
    }
}

// MARK: - Private Helpers
extension HelloTekoTests {

    private func test(_ searchString: String,
                      matches matchString: String,
                      file: StaticString = #file,
                      line: UInt = #line) {
        let sut = SmartSearchMatcher(searchString: searchString)

        XCTAssertTrue(sut.matches(matchString), file: file, line: line)
    }

    private func test(_ searchString: String,
                      doesNotMatch matchString: String,
                      file: StaticString = #file,
                      line: UInt = #line) {
        let sut = SmartSearchMatcher(searchString: searchString)

        XCTAssertFalse(sut.matches(matchString), file: file, line: line)
    }
}
