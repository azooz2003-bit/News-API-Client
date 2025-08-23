//
//  Paginatable.swift
//  NewsAPI
//
//  Created by Abdulaziz Albahar on 8/22/25.
//

protocol Paginatable {
    var pageSize: Int { get }
    var page: Int { get }
}

