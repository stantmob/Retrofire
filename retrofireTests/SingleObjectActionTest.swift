//
//  SingleObjectActionTest.swift
//  Retrofire
//
//  Created by Stant 02 on 04/05/18.
//  Copyright © 2018 Stant. All rights reserved.
//

import Quick
import Nimble
@testable import Retrofire

class SingleObjectActionTest: QuickSpec {
    
    override func spec() {
        
        let remoteBaseImpl = RemoteBaseImpl()
        var response: ResponseObject?
        
        describe("Access the api for a result a Single Object") {
            
            context("When has a existent object to find") {
                
                beforeEach {
                    remoteBaseImpl.findPost(id: 1)
                        .onSuccess() { responseObject in
                            response = responseObject
                        }
                        .call()
                }
                
                it("Should return a single response object") {
                    expect(response?.id).toEventually(equal(1))
                }
            }
        }
    }
}
