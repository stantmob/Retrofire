//
//  RemoteBaseImpl.swift
//  Retrofire
//
//  Created by Stant 02 on 03/05/18.
//  Copyright © 2018 Stant. All rights reserved.
//

import Foundation
import SwiftyJSON
@testable import Retrofire

class RemoteBaseImpl: RemoteBase {
    
    func constructionSites() -> Call<[ResponseObject]> {
        let path = "http://stage.stant.com.br/api/v1/construction_sites"
        let request = RequestBuilder(path: path)
            .headers(["Authorization": "Beare some-beaerer"])
            .build()
        return self
            .withCustomErrorClass(CustomErrorResponse.self)
            .callList(request: request)
    }
    
    func posts() -> Call<[ResponseObject]> {
        let path = "https://jsonplaceholder.typicode.com/posts"
        let request = RequestBuilder(path: path).build()
        return self.callList(request: request)
    }
    
    func postComments(postId: Int) -> Call<[ResponseObject]> {
        let path = "http://jsonplaceholder.typicode.com/comments"
        let request = RequestBuilder(path: path)
            .queryParameters(["postId": postId.description])
            .build()
        return self.callList(request: request)
    }
    
    func postsComments(postId: Int, email: String) -> Call<[ResponseObject]> {
        let path = "http://jsonplaceholder.typicode.com/comments"
        let request = RequestBuilder(path: path)
            .queryParameters(["postId": postId.description, "email": email])
            .build()
        return self.callList(request: request)
    }
    
    func findPost(id: Int) -> Call<ResponseObject> {
        let path = "http://jsonplaceholder.typicode.com/posts/\(id)/"
        let request = RequestBuilder(path: path)
            .build()
        return self.callSingle(request: request)
    }
    
    func createPost(userId: Int, title: String, body: String) -> Call<ResponseObject> {
        let path = "http://jsonplaceholder.typicode.com/posts"
        let request = RequestBuilder(path: path)
            .method(.post)
            .bodyParameters(["userId": userId, "title": title, "body": body])
            .build()
        return self.callSingle(request: request)
    }
    
    func updatePost(id: Int, userId: Int, title: String, body: String) -> Call<ResponseObject> {
        let path = "http://jsonplaceholder.typicode.com/posts/\(id)"
        let request = RequestBuilder(path: path)
            .method(.put)
            .bodyParameters(["userId": userId, "title": title, "body": body])
            .build()
        return self.callSingle(request: request)
    }
    
    func deletePost(id: Int) -> Call<Default> {
        let path = "http://jsonplaceholder.typicode.com/posts/\(id)"
        let request = RequestBuilder(path: path)
            .method(.delete)
            .build()
        return self.callSingle(request: request)
    }
    
    func deleteWithoutBody() -> Call<DefaultWithoutContent> {
        let path = "http://www.mocky.io/v2/5aecb5de3200005300fa49da"
        let request = RequestBuilder(path: path)
            .method(.delete)
            .build()
        return self.callSingle(request: request)
    }
}
