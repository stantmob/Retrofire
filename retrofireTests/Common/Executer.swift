//
//  Executer.swift
//  Retrofire
//
//  Created by Stant 02 on 04/05/18.
//  Copyright © 2018 Stant. All rights reserved.
//

import Foundation

struct Action {
    let block: () -> ()
    
    func call() {
        block()
    }
}

func execute(action: Action, _ setup: () -> () ) {
    setup()
    action.block()
}
