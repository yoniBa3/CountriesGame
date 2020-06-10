//
//  JsonParser.swift
//  Countries Game
//
//  Created by Yoni on 01/06/2020.
//  Copyright © 2020 Yoni. All rights reserved.
//

import UIKit

class JsonParser {
    
    let url = URL(string: "https://restcountries.eu/rest/v2/all")
    var countries = [Country]()
    
    func parseCountriesJson(completion: @escaping ([Country]) -> ()) {
        if let url = url {
            let session = URLSession.shared
            session.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        self.countries = try
                            JSONDecoder().decode([Country].self, from: data)
                        completion(self.countries)
                    } catch let error {
                        print(error)
                    }
                }
                
            }.resume()
        }
    }
}
