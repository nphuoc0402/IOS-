//
//  JsonHelper.swift
//  IOSDemo
//
//  Created by EP_NonFunc on 2023/03/23.
//

import Foundation


func load<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else{fatalError("couldn't find\(filename)in main Bundle")}
    
    do{
        data = try Data(contentsOf: file)
        
    }catch{
        fatalError("couldn't find\(filename)in main Bundle.\n\(error)")
    }
    
    do{
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }catch{
        fatalError("couldn't parse\(filename) as.\(T.self):\n\(error)")
    }
}
