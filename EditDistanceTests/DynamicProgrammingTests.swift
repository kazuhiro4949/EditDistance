//
//  DynamicProgrammingTests.swift
//  EditDistance
//
//  Copyright (c) 2017 Kazuhiro Hayashi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import XCTest
@testable import EditDistance

class DynamicProgrammingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTwoSameArray() {
        let container = DynamicProgramming().calculate(from: [["a", "b", "c"]], to: [["a", "b", "c"]])
        let expected: [EditScript<String>] = [
            .common(element: "a", indexPath: IndexPath(row: 0, section: 0)),
            .common(element: "b", indexPath: IndexPath(row: 1, section: 0)),
            .common(element: "c", indexPath: IndexPath(row: 2, section: 0))
        ]
        XCTAssertEqual(container.editScripts, expected, "correct output")
    }
    
    func testTwoDifferentArray() {
        do {
            let container = DynamicProgramming().calculate(from: [["a", "b", "c"]], to: [["a", "d", "c"]])
            let expected: [EditScript<String>] = [
                .common(element: "a", indexPath: IndexPath(row: 0, section: 0)),
                .common(element: "c", indexPath: IndexPath(row: 2, section: 0)),
                .delete(element: "b", indexPath: IndexPath(row: 1, section: 0)),
                .add(element: "d", indexPath: IndexPath(row: 1, section: 0))
            ]
            XCTAssertEqual(container.editScripts, expected, "correct output")
        }
        
        do {
            let container = DynamicProgramming().calculate(from: [["a", "b", "e"]], to: [["a", "d", "f"]])
            let expected: [EditScript<String>] = [
                .common(element: "a", indexPath: IndexPath(row: 0, section: 0)),
                .delete(element: "b", indexPath: IndexPath(row: 1, section: 0)),
                .delete(element: "e", indexPath: IndexPath(row: 2, section: 0)),
                .add(element: "d", indexPath: IndexPath(row: 1, section: 0)),
                .add(element: "f", indexPath: IndexPath(row: 2, section: 0)),
                ]
            XCTAssertEqual(container.editScripts, expected, "correct output")
        }
    }
    
    func testDestinationIsLonger() {
        do {
            let container = DynamicProgramming().calculate(from: [["a", "b", "c"]], to: [["a", "b", "c", "d"]])
            let expected: [EditScript<String>] = [
                .common(element: "a", indexPath: IndexPath(row: 0, section: 0)),
                .common(element: "b", indexPath: IndexPath(row: 1, section: 0)),
                .common(element: "c", indexPath: IndexPath(row: 2, section: 0)),
                .add(element: "d", indexPath: IndexPath(row: 3, section: 0)),
                ]
            XCTAssertEqual(container.editScripts, expected, "correct output")
        }
        
        do {
            let container = DynamicProgramming().calculate(from: [["a", "b", "c"]], to: [["a", "b", "d", "e"]])
            let expected: [EditScript<String>] = [
                .common(element: "a", indexPath: IndexPath(row: 0, section: 0)),
                .common(element: "b", indexPath: IndexPath(row: 1, section: 0)),
                .delete(element: "c", indexPath: IndexPath(row: 2, section: 0)),
                .add(element: "d", indexPath: IndexPath(row: 2, section: 0)),
                .add(element: "e", indexPath: IndexPath(row: 3, section: 0)),
                ]
            XCTAssertEqual(container.editScripts, expected, "correct output")
        }
    }
    
    
    func testStartingIsLonger() {
        do {
            let container = DynamicProgramming().calculate(from: [["a", "b", "c", "d"]], to: [["a", "b", "c"]])
            let expected: [EditScript<String>] = [
                .common(element: "a", indexPath: IndexPath(row: 0, section: 0)),
                .common(element: "b", indexPath: IndexPath(row: 1, section: 0)),
                .common(element: "c", indexPath: IndexPath(row: 2, section: 0)),
                .delete(element: "d", indexPath: IndexPath(row: 3, section: 0)),
                ]
            XCTAssertEqual(container.editScripts, expected, "correct output")
        }
        
        do {
            let container = DynamicProgramming().calculate(from: [["a", "b", "d", "e"]], to: [["a", "b", "c"]])
            let expected: [EditScript<String>] = [
                .common(element: "a", indexPath: IndexPath(row: 0, section: 0)),
                .common(element: "b", indexPath: IndexPath(row: 1, section: 0)),
                .delete(element: "d", indexPath: IndexPath(row: 2, section: 0)),
                .delete(element: "e", indexPath: IndexPath(row: 3, section: 0)),
                .add(element: "c", indexPath: IndexPath(row: 2, section: 0)),
                ]
            XCTAssertEqual(container.editScripts, expected, "correct output")
        }
    }
    
    func testPerformanceOfTwentyElementAddedToBottom() {
        let from = Array(repeating: 0, count: 20)
        let to = Array(repeating: 0, count: 20) + Array(repeating: 1, count: 20)
        self.measure {
            let _ = DynamicProgramming().calculate(from: [from], to: [to])
        }
    }
    
    func testPerformanceOfTwentyElementAddedToMiddle() {
        let from = Array(repeating: 0, count: 20) + Array(repeating: 0, count: 20)
        let to = Array(repeating: 0, count: 20) + Array(repeating: 1, count: 20) + Array(repeating: 0, count: 20)
        self.measure {
            let _ = DynamicProgramming().calculate(from: [from], to: [to])
        }
    }
    
    func testPerformanceOfTwentyElementDeleteOnTop() {
        let from = Array(repeating: 0, count: 20) + Array(repeating: 1, count: 20)
        let to = Array(repeating: 1, count: 20)
        self.measure {
            let _ = DynamicProgramming().calculate(from: [from], to: [to])
        }
    }
    
    func testPerformanceOfTwentyElementDeleteOnMiddle() {
        let from = Array(repeating: 0, count: 20) + Array(repeating: 1, count: 20) + Array(repeating: 0, count: 20)
        let to = Array(repeating: 0, count: 20) + Array(repeating: 0, count: 20)
        self.measure {
            let _ = DynamicProgramming().calculate(from: [from], to: [to])
        }
    }
    
}
