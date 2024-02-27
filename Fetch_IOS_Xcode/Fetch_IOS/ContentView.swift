//
//  ContentView.swift
//  Fetch_IOS
//
//  Created by Samkit Shah on 2/23/24.
//

import SwiftUI

// Model for storing meal data
struct Meal: Codable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}

struct mealDetail: Codable {
    let idMeal: String
    let strMeal: String
    let strDrinkAlternate: String?
    let strCategory: String
    let strArea: String
    let strInstructions: String
    let strMealThumb: String
    let strTags: String
    let strYoutube: String
    let strIngredient1: String
    let strIngredient2: String
    let strIngredient3: String
    let strIngredient4: String
    let strIngredient5: String
    let strIngredient6: String
    let strIngredient7: String
    let strIngredient8: String
    let strIngredient9: String
    let strIngredient10: String
    let strIngredient11: String
    let strIngredient12: String
    let strIngredient13: String
    let strIngredient14: String
    let strIngredient15: String
    let strIngredient16: String
    let strIngredient17: String
    let strIngredient18: String
    let strIngredient19: String
    let strIngredient20: String
    let strMeasure1: String
    let strMeasure2: String
    let strMeasure3: String
    let strMeasure4: String
    let strMeasure5: String
    let strMeasure6: String
    let strMeasure7: String
    let strMeasure8: String
    let strMeasure9: String
    let strMeasure10: String
    let strMeasure11: String
    let strMeasure12: String
    let strMeasure13: String
    let strMeasure14: String
    let strMeasure15: String
    let strMeasure16: String
    let strMeasure17: String
    let strMeasure18: String
    let strMeasure19: String
    let strMeasure20: String
    let strSource: String
}

// API Service for fetching meals
class MealAPIService {
    static let shared = MealAPIService()
    
    func fetchDessertMeals(completion: @escaping ([Meal]) -> Void) {
        let urlString = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                if let error = error {
                    print("Failed to fetch dessert meals: \(error.localizedDescription)")
                } else {
                    print("Failed to fetch dessert meals: Unknown error")
                }
                completion([])
                return
            }
            
            do {
                let result = try JSONDecoder().decode(MealResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(result.meals)
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
                completion([])
            }
        }.resume()
    }
    
    func fetchMealDetails(mealId: String, completion: @escaping (mealDetail?) -> Void) {
        let urlString = "https://themealdb.com/api/json/v1/1/lookup.php?i=\(mealId)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                if let error = error {
                    print("Failed to fetch meal details: \(error.localizedDescription)")
                } else {
                    print("Failed to fetch meal details: Unknown error")
                }
                completion(nil)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(MealResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(result.detail.first)
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}

// Response model for decoding API responses
struct MealResponse: Codable {
    let meals: [Meal]
    let detail: [mealDetail]
}

// Main ContentView
struct ContentView: View {
    @State private var meals: [Meal] = []
    
    var body: some View {
        NavigationView {
            List(meals) { meal in
                NavigationLink(destination: MealDetailView(meal: meal)) {
                    Text(meal.strMeal)
                }
            }
            .navigationTitle("Dessert Recipes")
            .onAppear {
                MealAPIService.shared.fetchDessertMeals { meals in
                    self.meals = meals.sorted(by: { $0.strMeal < $1.strMeal })
                }
            }
        }
    }
}

// Detail view for displaying meal details
struct MealDetailView: View {
    let meal: Meal
    @State private var detailedMeal: mealDetail?
    @State private var range: ClosedRange<Int> = 0...20
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let detailedMeal = detailedMeal {
                    Text(detailedMeal.strMeal)
                        .font(.title)
                        .padding(.bottom)
                    
                    if let url = URL(string: detailedMeal.strMealThumb) {
                        AsyncImage(url: url)
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .padding(.bottom)
                    }
                    
                    Text("Ingredients:")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    ForEach(range, id: \.self) { index in
                        let ingredientKey = "strIngredient\(index)"
                        let measureKey = "strMeasure\(index)"
                        
                        if let ingredient = mealDetail[keyPath: \mealDetail[keyPath: \mealDetail.strIngredient1] as? String],
                           !ingredient.isEmpty,
                           let measure = mealDetail[keyPath: \mealDetail[keyPath: \mealDetail.strMeasure1] as? String],
                           !measure.isEmpty {
                            Text("\(ingredient) - \(measure)")
                                .padding(.bottom, 4)
                        }
                    }
                    
                    Text("Instructions:")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    Text(detailedMeal.strInstructions)
                } else {
                    ProgressView()
                        .onAppear {
                            MealAPIService.shared.fetchMealDetails(mealId: meal.idMeal) { detailedMeal in
                                self.detailedMeal = detailedMeal
                            }
                        }
                }
            }
            .padding()
        }
        .navigationTitle("Recipe")
    }
}

#Preview {
    ContentView()
}
