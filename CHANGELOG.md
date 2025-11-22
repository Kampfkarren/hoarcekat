# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.4.0]
### Added
- Added support for string requires.

## [1.3.0]
### Added
- Vertical splitter bar between Stories list and Preview pane which can be dragged to resize the two areas.

## [1.2.1]
### Changed
- Improved live editing experience by retaining last working preview and delaying error messages. ([#27](https://github.com/Kampfkarren/hoarcekat/pull/27))

### Fixed
- Fixed expanded UI not using sibling ZIndexBehavior, like the un-expanded UI. ([#24](https://github.com/Kampfkarren/hoarcekat/pull/24))
- Fixed the expand/select buttons being layered behind stories. ([#21](https://github.com/Kampfkarren/hoarcekat/pull/21))
- Fixed a bug where live refresh would fail until the story was re-selected. ([#25](https://github.com/Kampfkarren/hoarcekat/pull/25))

## [1.2.0] - 2021-05-12
### Added
- Expand to screen button which allows you to display UI on your screen.

### Changed
- When a studio test is initiated, HoarceKat will no longer display an update message.
- Changed how loaded scripts location are displayed. Instead of using the script source, it uses the script location within the datamodel.

### Fixed
- Fixed plugin breaking with the removal of UI Theme.

## [1.1.1] - 2020-05-10
### Fixed
- Fixed permanently breaking if the cleanup function errored.
- Fixed stories being re-required if they were closed out.

## [1.1.0] - 2020-02-05
### Added
- Added a button to select the preview.

## [1.0.1] - 2020-02-05
### Changed
- `_G` is now monkey patched instead of referring to the real `_G`.

## [1.0.0] - 2020-01-22
### Added
- Initial release.
