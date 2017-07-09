//
//  Call.swift
//  retrofire
//
//  Created by Rachid Calazans on 09/07/17.
//  Copyright © 2017 Stant. All rights reserved.
//

public class Call<T> {
    private let callback: (Call<T>) -> Void
    private var rsCallback: ((T?) -> Void)?
    private var rfCallback: ((Any?) -> Void)?
    
    init(_ callback: @escaping (Call<T>) -> Void) {
        self.callback = callback
    }
    
    public func call() {
        callback(self)
    }
    
    public func success(result: T?) {
        self.rsCallback!(result)
    }
    
    public func failed(error: Any? = nil) {
        self.rfCallback!(error)
    }
    
    public func onSuccess(_ resultCallback: @escaping (T?) -> Void) -> Call<T> {
        self.rsCallback = resultCallback
        return self
    }
    
    public func onFailed(_ resultCallback: @escaping (Any?) -> Void) -> Call<T> {
        self.rfCallback = resultCallback
        return self
    }
}
