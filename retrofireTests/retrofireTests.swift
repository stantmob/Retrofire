//
//  retrofireTests.swift
//  retrofireTests
//
//  Created by Rachid Calazans on 09/07/17.
//  Copyright © 2017 Stant. All rights reserved.
//

import Quick
import Nimble

@testable import retrofire

class retrofireTestsBdd: QuickSpec {
    override func spec() {
        
        describe("Describing something to test") {
            
            
            context("When use some configuration") {
                
                it("Should return something") {
                    expect(1 + 1).to(equal(2))
                }
            }
            
        }
    }
}
