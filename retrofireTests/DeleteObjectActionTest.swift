//
//  DeleteObjectActionTest.swift
//  Retrofire
//
//  Created by Stant 02 on 04/05/18.
//  Copyright © 2018 Stant. All rights reserved.
//

import Quick
import Nimble
@testable import Retrofire

class DeleteObjectActionTest: QuickSpec {
    
    override func spec() {
        
        let remoteBaseImpl = RemoteBaseImpl()
        var response: Bool = false
        var result         = ""
        
        describe("Deleting an Object") {
            
            context("When pass an existent id") {
                
                beforeEach {
                    remoteBaseImpl
                        .deletePost(id: 1)
                        .onSuccess() { (responseObject) in
                            response = true
                        }
                        .call()
                }
                
                it("Should delete successfully") {
                    expect(response).toEventually(equal(true))
                }
            }
            
            context("When call delete without body") {
                beforeEach {
                    remoteBaseImpl.deleteWithoutBody()
                        .onSuccess() { (emptyResponse) in
                            if let dataResponse = emptyResponse {
                                result = dataResponse.description
                            }
                    }
                        .call()
                }
                
                it("Should call success with enpty response") {
                    expect(result).toEventually(equal("No content"))
                }
            }
        }        
    }
}
