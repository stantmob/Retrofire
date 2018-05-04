//
//  CustomErrorActionTest.swift
//  Retrofire
//
//  Created by Stant 02 on 04/05/18.
//  Copyright © 2018 Stant. All rights reserved.
//

import Quick
import Nimble
@testable import Retrofire

class CustomErrorActionTest: QuickSpec {
    
    override func spec() {
        
        let remoteBaseImpl = RemoteBaseImpl()
        var response: CustomErrorResponse?
        
        describe("When pass custom Error class") {
            
            beforeEach {
                remoteBaseImpl.constructionSites()
                    .onFailed() { error in
                        response = error as? CustomErrorResponse
                    }
                    .call()
            }
            
            it("Should return error response object") {
                expect(response?.responseType).toEventually(equal("error"))
                expect(response?.message).toEventually(equal("OAuth error: unauthorized"))                
            }
        }
    }
}
