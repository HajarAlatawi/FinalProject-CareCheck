

import UIKit

struct MedReminder: Codable {
  
  var name: String?
  var date: TimeInterval?
  var description: String?
  var reminderSet: Bool?
  var notificationID: String?
  var completed: Bool?
}


struct MealReminder: Codable {
  var name: String?
  var date: TimeInterval?
  var description: String?
  var reminderSet: Bool?
  var notificationID: String?
  var completed: Bool?
}


struct ShowerReminder: Codable {
  var name: String?
  var date: TimeInterval?
  var reminderSet: Bool?
  var notificationID: String?
  var completed: Bool?
}


struct PhotoReminder: Codable {
  var date: TimeInterval?
  var reminderSet: Bool?
  var notificationID: String?
  var completed: Bool?
}
