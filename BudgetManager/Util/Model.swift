//
//  Model.swift
//  BudgetManager
//
//  Created by JACK HOGG on 08/11/2023.
//

import Foundation

extension Category 
{
    public var wrappedName: String
    {
        name ?? "unknown"
    }
    

}

extension Transaction
{
    public var wrappedName: String
    {
        name ?? "unknown"
    }

}
