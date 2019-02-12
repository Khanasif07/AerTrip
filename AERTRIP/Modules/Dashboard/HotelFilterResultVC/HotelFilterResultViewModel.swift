//
//  HotelFilterResultViewModel.swift
//  AERTRIP
//
//  Created by Admin on 11/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

public protocol DataSource: class {
    var title: String? { get }
    var sections: [Section] { get }
}

public protocol Section: class  {
    var header: String? { get }
    var footer: String? { get }
    var items: [Item] { get }
}

public protocol Item: class  {
    var identifier: String { get }
    var viewModel: ViewModel { get }
    var child: DataSource? { get }
}

public protocol ViewModel: class  {}

// MARK: - Helpers

public extension DataSource {
    var title: String? { return nil }
    
    func item(at indexPath: IndexPath) -> Item {
        return sections[indexPath.section].items[indexPath.item]
    }
    func identifier(at indexPath: IndexPath) -> String {
        return item(at: indexPath).identifier
    }
    func viewModel(at indexPath: IndexPath) -> ViewModel {
        return item(at: indexPath).viewModel
    }
    
    var uniqueIdentifiers: Set<String> {
        var ids: Set<String> = Set<String>()
        sections.forEach { section in
            let allSectionIdentifiers: [String] = section.items.map({ $0.identifier })
            ids.formUnion(allSectionIdentifiers)
        }
        return ids
    }
}

public extension Section {
    var header: String? { return nil }
    var footer: String? { return nil }
}

public extension Item {
    var child: DataSource? { return nil }
}

