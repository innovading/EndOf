# EndOf
PowerShell script for handling EndOfWeek and EndOfDay tasks scheduled inside of Task Scheduler.

## Features
* Combines handling EndOfWeek adn EndOfDay tasks such that they are processed in series instead of parallel if done separately
* Uses ProcessPipeline such that when tasks are broken up into different stages one task in each stage can be processing like a CPU pipline are factory assembly line
