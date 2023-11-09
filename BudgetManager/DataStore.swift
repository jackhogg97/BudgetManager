//
//  DataStore.swift
//  BudgetManager
//
//  Created by JACK HOGG on 09/11/2023.
//

import Foundation

public final class DataStore
{
    var data: [Category] = []

    init()
    {
        self.loadData()
    }

    func saveData(data: [Category]) {
        if let url = Bundle.main.url(forResource: "categories.json", withExtension: nil)
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
        if let url = Bundle.main.url(forResource: "categories.json", withExtension: nil) {
            if let data = try? Data(contentsOf: url)
            {
                let decoder = JSONDecoder()

                do {
                    let result = try decoder.decode([Category].self, from: data)
                    self.data = result
                } catch {
                    print("Error loading data \(error)")
                }
            }
        }
    }
}
