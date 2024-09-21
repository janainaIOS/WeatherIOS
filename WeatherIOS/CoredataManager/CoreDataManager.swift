//
//  CoreDataManager.swift
//  WeatherIOS
//
//  Created by Janaina A on 20/09/2024.
//

import UIKit
import CoreData

class CoredataManager {
    static let shared = CoredataManager()
    
    // Main Managed Object Context used for interacting with Core Data
    private lazy var mainManagedObjectContext: NSManagedObjectContext? = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.persistentContainer.viewContext
    }()
    
    // Saves changes in the main context, returning true if successful
    private func saveMainContext() -> Bool {
        var returnVal = true
        
        // Check if the context exists and has unsaved changes
        if mainManagedObjectContext != nil {
            if (mainManagedObjectContext!.hasChanges) {
                // Perform save operation synchronously
                mainManagedObjectContext!.performAndWait {
                    do {
                        print("Core Data has changes")
                        // Attempt to save changes to the context
                        try mainManagedObjectContext?.save()
                    } catch {
                        // If save fails, rollback changes and set return value to false
                        returnVal = false
                        print("Unable to create Core Data Entity - not able to save - rollback")
                        rollBackRecentModification()
                    }
                }
            } else {
                print("Core Data doesn't have changes")
                returnVal = true
            }
        } else {
            // Context is nil, cannot proceed with save
            returnVal = false
            print("Unable to create Core Data Entity - managedObjectContext is nil")
        }
        
        print("Saved Core Data = \(returnVal)")
        return returnVal
    }
    
    // MARK: --------------------- ROLL BACK ----------------------------
    
    // Rolls back the recent unsaved changes in the context
    func rollBackRecentModification() {
        mainManagedObjectContext?.rollback()
    }
    
    
    // MARK: - Forecast
    
    /// Fetch all forecast items from the database
    /// - Returns: An array of `DBForecast` objects, or nil if an error occurs
    func fetchAllForecasts() -> [DBForecast]? {
        guard let context = mainManagedObjectContext else {
            print("Unable to access the managed object context.")
            return nil
        }
        
        let fetchRequest: NSFetchRequest<DBForecast> = DBForecast.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            print("Fetched \(results.count) forecast items.")
            return results
        } catch {
            print("Failed to fetch forecasts: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Fetch a specific forecast by ID
    /// - Parameter id: The ID of the forecast to fetch
    /// - Returns: An optional `DBForecast` object if found, nil otherwise
    func fetchForecast(byID id: Int64) -> DBForecast? {
        guard let context = mainManagedObjectContext else {
            print("Unable to access the managed object context.")
            return nil
        }
        
        let fetchRequest: NSFetchRequest<DBForecast> = DBForecast.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %lld", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Failed to fetch forecast with id \(id): \(error.localizedDescription)")
            return nil
        }
    }
    
    
    /// Checks if a location with the specified ID already exists in the database
    /// - Parameter id: The ID of the weather location
    /// - Returns: A Boolean indicating whether a duplicate exists
    func checkDuplicateForecastByID(id: Int64) -> Bool {
        guard let context = mainManagedObjectContext else {
            print("Managed Object Context is nil.")
            return false
        }
        
        let fetchRequest: NSFetchRequest<DBForecast> = DBForecast.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %lld", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            return !results.isEmpty
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Adds or updates a forecast in the database
    /// - Parameters:
    ///   - forecast: The forecast data to add or update
    ///   - completion: A completion handler with a Boolean indicating success
    func insertOrUpdateForecast(forecast: Forecast, completion: @escaping (Bool) -> Void) {
        guard let context = mainManagedObjectContext else {
            completion(false)
            return
        }
        
        // Check if forecast already exists using city ID
        let fetchRequest: NSFetchRequest<DBForecast> = DBForecast.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %lld", forecast.city?.id ?? 0)
        
        do {
            let results = try context.fetch(fetchRequest)
            let dbForecast: DBForecast
            
            if let existingForecast = results.first {
                // Update the existing forecast
                print("Updating existing forecast with id \(existingForecast.id).")
                dbForecast = existingForecast
            } else {
                // Create a new forecast entry
                print("Creating new forecast for city id \(forecast.city?.id ?? 0).")
                guard let entity = NSEntityDescription.entity(forEntityName: "DBForecast", in: context) else {
                    completion(false)
                    return
                }
                dbForecast = DBForecast(entity: entity, insertInto: context)
                dbForecast.id = Int64(forecast.city?.id ?? 0)
            }
            
            // Update or add related weather data
            if let weatherList = forecast.list {
                let weatherSet = NSMutableSet()
                for weather in weatherList {
                    if let dbWeather = insertOrUpdateWeather(forecast: forecast, weather: weather) {
                        weatherSet.add(dbWeather)
                    }
                }
                dbForecast.forecasts = weatherSet
            }
            
            // Save the context
            completion(saveMainContext())
        } catch {
            print("Error fetching forecast: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    /// Adds or updates weather in the database
    /// - Parameter weather: The weather data to add or update
    /// - Returns: An optional `DBWeather` object if successfully added or updated
    private func insertOrUpdateWeather(forecast: Forecast, weather: Weather) -> DBWeather? {
        guard let context = mainManagedObjectContext else {
            return nil
        }
        
        // Fetch request to check if the weather data with the given ID already exists
        let fetchRequest: NSFetchRequest<DBWeather> = DBWeather.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %lld", weather.id)
        
        do {
            let results = try context.fetch(fetchRequest)
            let dbWeather: DBWeather
            
            if let existingWeather = results.first {
                // If the weather exists, update it
                print("Updating existing weather data for id \(weather.id).")
                dbWeather = existingWeather
            } else {
                // If the weather doesn't exist, create a new one
                print("Creating new weather data for id \(weather.id).")
                guard let entity = NSEntityDescription.entity(forEntityName: "DBWeather", in: context) else {
                    return nil
                }
                dbWeather = DBWeather(entity: entity, insertInto: context)
            }
            
            // Update or set the values
            dbWeather.id            = Int64(forecast.city?.id ?? 0)
            dbWeather.isHome        = forecast.isHome
            dbWeather.cityName      = forecast.city?.name
            dbWeather.date          = weather.dateTime
            dbWeather.descriptn     = weather.descriptn.first?.description
            dbWeather.descriptnMain = weather.descriptn.first?.main
            dbWeather.latitude      = forecast.city?.coord?.latitude ?? 0
            dbWeather.longitude     = forecast.city?.coord?.longitude ?? 0
            dbWeather.temp          = weather.temparature?.temp ?? 0
            dbWeather.maxTemp       = weather.temparature?.maxTemp ?? 0
            dbWeather.minTemp       = weather.temparature?.minTemp ?? 0
            dbWeather.windSpeed     = weather.wind?.speed ?? 0
            dbWeather.humidity      = weather.temparature?.humidity ?? 0
            dbWeather.pressure      = weather.temparature?.pressure ?? 0
            dbWeather.sunset        = forecast.city?.sunset ?? 0
            dbWeather.sunrise       = forecast.city?.sunrise ?? 0
            dbWeather.createdDate   = Date()
            
            return dbWeather
        } catch {
            print("Error fetching weather data: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Deletes a forecast and its related weather data from the database
    /// - Parameter forecastID: The ID of the forecast to delete
    /// - Returns: A Boolean indicating whether the deletion was successful
    func deleteForecast(byID forecastID: Int64) -> Bool {
        guard let context = mainManagedObjectContext else {
            return false
        }
        
        // Fetch request to find the forecast by ID
        let fetchRequest: NSFetchRequest<DBForecast> = DBForecast.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %lld", forecastID)
        
        do {
            let forecast = try context.fetch(fetchRequest)
            if let forecastToDelete = forecast.first {
                // Remove all associated weather data
                if let weathers = forecastToDelete.forecasts as? Set<DBWeather> {
                    for weather in weathers {
                        context.delete(weather)
                    }
                }
                
                // Delete the forecast itself
                context.delete(forecastToDelete)
                print("Deleted forecast with id \(forecastID).")
            } else {
                print("No forecast found with id \(forecastID).")
            }
        } catch {
            print("Failed to delete forecast with id \(forecastID): \(error)")
        }
        return saveMainContext()
    }
}
