# FPV Drone Parent Cache Preload

Small SPT server compatibility preload for `FPVDroneModServer`.

FPV Drone Mod creates two custom parent nodes for drone and payload items before loading its item JSON. SPT's item base-class service can warn the first time those node ids are checked as if they were real item templates. This preload installs an early compatibility patch that treats those two FPV parent node ids as non-matching base-class checks without logging a warning.

It does not disable FPV, rewrite FPV item IDs, or alter drone/payload behavior.


Public package note: installation paths in legacy examples are placeholders. Use the central build/install scripts described in the root README. Headless setup scripts are manual tools; they are not run by the package installer.
