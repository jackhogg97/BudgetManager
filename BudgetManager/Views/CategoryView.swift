//
//  CategoryView.swift
//  BudgetManager
//
//  Created by JACK HOGG on 16/11/2023.
//

import SwiftUI

struct CategoryView: View 
{

    @Binding var showing: Page
    @Binding var category: String
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var transactions: FetchedResults<Transaction>

    var body: some View 
    {
        VStack(alignment: .leading)
        {
            HStack
            {
                Text(category).font(.title)
                Spacer()
                Button(action: { self.showing = .MonthlyView }, label:
                {
                    Image(systemName: "multiply")
                        .resizable()
                        .frame(width: 20.0, height: 20.0, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                })
            }
            .padding()
            let transactionsFromCategory = getTransactionsKeyedByDay()
            List
            {
                ForEach(transactionsFromCategory.keys.sorted(by: >), id: \.self)
                {
                    day in
                    Section(header: Text(day))
                    {
                        ForEach(transactionsFromCategory[day]!, id: \.self)
                        {
                            transaction in
                            HStack
                            {
                                Text(transaction.wrappedName)
                                Spacer()
                                Text(String(format: "£%.2F", transaction.amount))
                            }
                        }
                        .onDelete 
                        {
                            indexSet in
                            if let index = indexSet.first 
                            {
                                let transactionToDelete = transactionsFromCategory[day]![index]
                                moc.delete(transactionToDelete)
                                try? moc.save()
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
    }

    func getTransactionsKeyedByDay() -> [String : [FetchedResults<Transaction>.Element]]
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_GB")

        let transactionsFromCategory = self.transactions.filter { $0.category ?? "" == category }
        return Dictionary(grouping: transactionsFromCategory) { (element: Transaction) in
            return dateFormatter.string(from: element.date!)
        }
    }
}

#Preview 
{
    CategoryView(showing: .constant(.CategoryPage), category: .constant("Category Title"))
}
