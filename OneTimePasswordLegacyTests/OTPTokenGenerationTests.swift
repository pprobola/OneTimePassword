//
//  OTPTokenGenerationTests.swift
//  OneTimePassword
//
//  Copyright (c) 2013 Matt Rubin
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import XCTest
@testable import OneTimePassword

class OTPTokenGenerationTests: XCTestCase {
    // From Google Authenticator for iOS
    // https://code.google.com/p/google-authenticator/source/browse/mobile/ios/Classes/TOTPGeneratorTest.m
    func testTOTPGoogleValues() {
        let secret = "12345678901234567890".dataUsingEncoding(NSASCIIStringEncoding)!

        let intervals: [NSTimeInterval] = [
            1111111111,
            1234567890,
            2000000000,
        ]
        let algorithms: [Generator.Algorithm] = [
            .SHA1,
            .SHA256,
            .SHA512,
        ]
        let results = [
            // SHA1    SHA256    SHA512
            "050471", "584430", "380122", // date1
            "005924", "829826", "671578", // date2
            "279037", "428693", "464532", // date3
        ]

        var j = 0
        for i in 0..<intervals.count {
            for algorithm in algorithms {
                let generator = Generator(factor: .Timer(period: 30), secret: secret, algorithm: algorithm, digits: 6)
                XCTAssertEqual(results[j],
                               try! generator.passwordAtTimeIntervalSince1970(intervals[i]),
                               "Invalid result \(i), \(algorithm), \(intervals[i])")
                j++
            }
        }
    }
}
