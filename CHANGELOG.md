# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

Add comment under [Unreleased] and commit with !Deploy!
Format as below (Requires the '### Added' as a header or task fails)
...### Added
...- Move Test-Module from Private to public\build
...- Update ReadMe.MD

## [Unreleased]
### Added
- Convert-ChassisType ID to accept [string]
- Updated Get-MEMCMSQL_ExtendedInfo to accept [string] - SCCM stores as string not [int]

## [1.20.20210506.0] - 2021-05-06
### Added
- Update Test-Module
- Add Join-Object

## [1.19.20210430.0] - 2021-04-30
### Added
- Update cmdlet name Get-ZoomRoomsDashboard

## [1.18.20210428.0] - 2021-04-28
### Added
- Remove Schema name from 'Get-ZoomRoomsObjects'
- Update 'Set-InsightObject'

## [1.17.20210422.0] - 2021-04-22
### Added
- Updated Set-Insight Object to add -ShowJSON function

## [1.16.20210421.0] - 2021-04-21
### Added
- Find-InsightObjectsAdvanced bug fix for attributesToDisplay (Still seems to be bug at Insight end)
- Find-InsightObjectsAdvanced Added ShowJSON switch that will show json and break out of function. Good for troubleshooting
- ObjectTypes.json updated to include status field.
- Connect-MEMCM cleaned up and removed unwanted code
- New-InsightObjectTypeAttributes updated JSON depth.. descriptions still not working logged ticket to Insight
- New-InsightObjectAttribute Removed whitespace
- Build-ObjectType Removed whitespace and test code.

## [1.15.20210414.0] - 2021-04-14
### Added
- Build-ObjectType Add description parameter
- New-InsightObjectTypeAttributes Add description parameter

## [1.14.20210413.0] - 2021-04-13
### Added
- Fixed bug in zoom room builder where parent_room was not created or populated.
- Added field 'typeValue' for type 'Object' in New-InsightObjectTypeAttributes
- Added Find-InsightObjects
- Added Find-InsightObjectsAdvanced
- Removed Links from JSON and Build-ObjectType

## [1.13.20210412.0] - 2021-04-12
### Added
- Update Convert-ChassisType to contain catagory as well as ID.
- Update ObjectTypes.json - Remove Hostname, Update SerialName field, add links
- Connect-MEMCM updated
- Update Get-MEMCMSQL_ExtendedInfo - New Chasis Info, SerialName
- Statuses examples and builder

## [1.12.20210409.0] - 2021-04-09
### Added
- Move -raw on get-content to stop positional errors
- Added 'Get-MEMCMSQL_ExtendedInfo' to collect extra properties for computers pulled from SCCM
- Added SiteServer.Json example
- Updated Zoom Rooms Example.ps1
- Updated Example_ObjectTypeBuilder.ps1
- Updated Example_Schemabuilder.ps1
- Added Convert-ChassisType.ps1
- Added Get-ZoomRoomsObjects.ps1


## [1.11.20210408.0] - 2021-04-08
### Added
- Rearranged ObjectTypes.json
- Added 'SCCM Example.ps1' (Currently only building Computer Object..)

## [1.10.20210408.0] - 2021-04-08
### Added
- 'Test-Module PSInsight' added to examples to ensure module is loaded
- Populate_ZoomRooms sample script added

## [1.9.20210408.0] - 2021-04-08
### Added
- Renamed Build Folder to Builder as 'Build' is a reserved folder for github actions. 
- Edit ReadMe.MD 

## [1.8.20210408.0] - 2021-04-08
### Added
- Move Test-Module from Private to public\build
- Update ReadMe.MD

## [1.7.20210408.0] - 2021-04-08
### Added
- Updated ReadMe.md
- Build-ObjectType and Build-Schema added to build the database from JSON input (See examples folder).
- Examples\Schema added to provide sample data and script to automaticly build a Schema.
- Examples\ObjectTypes added to provide sample data and script to automaticly build ObjectTypes within the schema.
- Superseeded example files removed


## [1.6.20210407.0] - 2021-04-07
### Added
- Update New-InsightObjectTypes to support more parameters (abstractObjectType & inherited).

## [1.5.20201023.0] - 2020-10-23
### Added
- Updated the format of the dynamic parameters based on the help from chrisdent (https://discord.gg/winadmin ) makes it much more readable and can remove all teh commenting. 

## [1.4.20201022.0] - 2020-10-22
### Added
- Fixed issue with APIkey

## [1.3.20201021.0] - 2020-10-21
### Added
- Added Recurse to the Invoke-Build Script for the PSM1

## [1.2.20201021.0] - 2020-10-21
### Added
- Added Recurse to the Invoke-Build Script

## [1.1.20201021.0] - 2020-10-21
### Added
- First Deployment

## [1.0.0] - 2020-10-15
### Added
- Added to start versioning[Unreleased]: https://github.com/DamagedDingo/PSInsight/compare/1.21.20210507.0..HEAD
[1.21.20210507.0]: https://github.com/DamagedDingo/PSInsight/compare/1.20.20210506.0..1.21.20210507.0
[1.20.20210506.0]: https://github.com/DamagedDingo/PSInsight/compare/1.19.20210430.0..1.20.20210506.0
[1.19.20210430.0]: https://github.com/DamagedDingo/PSInsight/compare/1.18.20210428.0..1.19.20210430.0
[1.18.20210428.0]: https://github.com/DamagedDingo/PSInsight/compare/1.17.20210422.0..1.18.20210428.0
[1.17.20210422.0]: https://github.com/DamagedDingo/PSInsight/compare/1.16.20210421.0..1.17.20210422.0
[1.16.20210421.0]: https://github.com/DamagedDingo/PSInsight/compare/1.15.20210414.0..1.16.20210421.0
[1.15.20210414.0]: https://github.com/DamagedDingo/PSInsight/compare/1.14.20210413.0..1.15.20210414.0
[1.14.20210413.0]: https://github.com/DamagedDingo/PSInsight/compare/1.13.20210412.0..1.14.20210413.0
[1.13.20210412.0]: https://github.com/DamagedDingo/PSInsight/compare/1.12.20210409.0..1.13.20210412.0
[1.12.20210409.0]: https://github.com/DamagedDingo/PSInsight/compare/1.11.20210408.0..1.12.20210409.0
[1.11.20210408.0]: https://github.com/DamagedDingo/PSInsight/compare/1.10.20210408.0..1.11.20210408.0
[1.10.20210408.0]: https://github.com/DamagedDingo/PSInsight/compare/1.9.20210408.0..1.10.20210408.0
[1.9.20210408.0]: https://github.com/DamagedDingo/PSInsight/compare/1.8.20210408.0..1.9.20210408.0
[1.8.20210408.0]: https://github.com/DamagedDingo/PSInsight/compare/1.7.20210408.0..1.8.20210408.0
[1.7.20210408.0]: https://github.com/DamagedDingo/PSInsight/compare/1.6.20210407.0..1.7.20210408.0
[1.6.20210407.0]: https://github.com/DamagedDingo/PSInsight/compare/1.5.20201023.0..1.6.20210407.0
[1.5.20201023.0]: https://github.com/DamagedDingo/PSInsight/compare/1.4.20201022.0..1.5.20201023.0
[1.4.20201022.0]: https://github.com/DamagedDingo/PSInsight/compare/1.3.20201021.0..1.4.20201022.0
[1.3.20201021.0]: https://github.com/DamagedDingo/PSInsight/compare/1.2.20201021.0..1.3.20201021.0
[1.2.20201021.0]: https://github.com/DamagedDingo/PSInsight/compare/1.1.20201021.0..1.2.20201021.0
[1.1.20201021.0]: https://github.com/DamagedDingo/PSInsight/compare/1.0.0..1.1.20201021.0