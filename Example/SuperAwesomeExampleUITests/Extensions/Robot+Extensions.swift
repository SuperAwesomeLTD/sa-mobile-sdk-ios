//
//  Robot.swift
//  SuperAwesomeExampleUITests
//
//  Created by Tom O'Rourke on 18/04/2023.
//

import XCTest
import DominantColor

extension Robot {
    
    /**
     * Method that asserts that an expected color is present on screen
     *
     * - Parameters:
     *  - expectedColor: The expected color as a hex string e.g: "#FFFFFF"
     *  - timeout: The number of pixels to sample from the centre of the screen
     */
    func waitForExpectedColor(
        expectedColor: String,
        image: UIImage,
        timeout: Int = 5,
        file: StaticString = #file,
        line: UInt = #line)
    {
        
        let expectation = XCTestExpectation(description: "Located expected color")
        
        var count = 0
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            
            let locatedColor = self?.findColorInImage(
                expectedColor: expectedColor,
                sampleSize: 5,
                image: image
            )
            
            if(expectedColor == locatedColor) {
                timer.invalidate()
                expectation.fulfill()
                XCTAssertEqual(
                    expectedColor,
                    locatedColor,
                    file: file,
                    line: line
                )
            }
            
            if (count == timeout - 1) {
                timer.invalidate()
            }
            count+=1
        }
        
        let result = XCTWaiter.wait(for: [expectation], timeout: TimeInterval(timeout))
        
        switch result {
        case .completed: break // Assertion made above
        case .timedOut: XCTFail(
            "Timed out waiting for expected color: \(expectedColor)",
            file: file,
            line: line)
        default: XCTFail(
            "Failed to locate expected color: \(expectedColor)",
            file: file,
            line: line)
        }
    }
    
    /**
     * Method that finds an expected color
     *
     * - Parameters:
     *  - expectedColor: The expected color as a hex string e.g: "#FFFFFF"
     *  - sampleSize: The number of pixels to sample from the centre of the image
     *  - image: The image to test, e.g: `closeButton.screenshot().image`
     */
    private func findColorInImage(
        expectedColor: String,
        sampleSize: CGFloat,
        image: UIImage) -> String?
    {
        guard sampleSize > 2 else { return nil }
        
        let crop = image.centreCroppedTo(CGSize(width: sampleSize, height: sampleSize))
        
        return crop.dominantColors()
            .first( where: { $0.hexString() == expectedColor })?
            .hexString()
    }
}
