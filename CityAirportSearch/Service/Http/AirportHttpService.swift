//
//  AirportHttpService.swift
//  CityAirportSearch
//
//  Created by Артур Карачев on 13.06.2023.
//

import Alamofire

class AirportHttpService: HttpService {
    var sessionManager: Session = Session.default
    
    func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
        return sessionManager.request(urlRequest).validate(statusCode: 200..<400)
    }
}
