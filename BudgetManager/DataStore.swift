//
//  DataStore.swift
//  BudgetManager
//
//  Created by JACK HOGG on 09/11/2023.
//

import Foundation

public final class DataStore<T: Codable>
{
    private var data: [T] = []
    private let filename: String

    init(location: String)
    {
        self.filename = location
        self.loadData()
    }

    func getData() -> [T] {
        self.loadData()
        return self.data
    }

    func saveData(data: [T]) {
        if let url = getDataLocation()
        {
            let encoder = JSONEncoder()

            do
            {
                let result = try encoder.encode(data)
                try result.write(to: url)
            }
            catch
            {
                print("Error saving data \(error)")
            }
        }
    }

    private func loadData() {
        if let url = getDataLocation() {
            if let data = try? Data(contentsOf: url)
            {
                let decoder = JSONDecoder()

                do {
                    let result = try decoder.decode([T].self, from: data)
                    self.data = result
                } catch {
                    print("Error loading data \(error)")
                }
            }
        }
    }

    private func getDataLocation() -> URL? {
        if let url = Bundle.main.url(forResource: self.filename, withExtension: "json") {
            return url
        } else {
            print("Error: Unable find location of stored data")
            return nil
        }
    }
}
