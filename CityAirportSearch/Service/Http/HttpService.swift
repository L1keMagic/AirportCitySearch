//
//  HttpService.swift
//  CityAirportSearch
//
//  Created by Артур Карачев on 13.06.2023.
//

import Alamofire

protocol HttpService {
    var sessionManager: Session { get set }
    func request(_ urlRequest: URLRequestConvertible) -> DataRequest
}
