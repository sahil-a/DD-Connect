# DD-Connect

An app made to connect people with officials and destinations in the ColumbUS discovery district. Made for the CBus Student Hack

## File Organization

The code is under the DD Connect folder and is organized in the Model-View-Controller pattern.

The View files include:
- MenuScene.swift: sprite kit scene that manages main menu animations and structure
- CustomTextField.swift: a custom text field used across the app
- OptionButton.swift: a custom button used in the staff mode views
- Main.storyboard: Xcode visual layout file

The Model files include:
- FirebaseHelper.swift: communication with firebase backend
- CurrentHelper.swift: communication with GE Current API
- Location.swift: data structure
- Event.swift: data structure
- Report.swift: data structure
- Official.swift: data structure
- Announcement.swift: data structure
- TemperatureMeasures.swift: data structure

The Controller files include:
- MenuViewController.swift: manages the main menu navigation
- CityStatusViewController.swift: connects the GE API model data to the view
- LocationsViewController.swift: manages the view for displaying all locations
- LocationViewController.swift: manages the detail view for displaying one location
- EventsViewController.swift: manages the view for displaying all events
- EventViewController.swift: manages the detail view for displaying one event
- ReportViewController.swift: manages the view in the hero mode for picking a report category
- WriteReportViewController.swift: manages the view in the hero mode for writing a report
- ContactViewController.swift: manages the view in the hero mode for viewing city officials contact info
- StaffListViewController.swift: manages the view for staff to view others contact information and edit their own information
- ReportCategoriesViewController.swift: manages the view for staff to pick a category of reports to view
- ReportCategoryViewController.swift: manages the view for staff to view reports in a category
- ViewReportViewController: manages the view for staff to view a specific report

## To Run (Xcode 8 required)

- Clone the Repo
- Open the .xcworkspace file in Xcode
- Build and Run on iOS Simulator with Xcode 8

