Feature: Automobile Emissions Calculations
  The automobile model should generate correct emission calculations

  Scenario Outline: Standard Calculations for automobiles
    Given an automobile has "annual_distance_estimate" of "<distance>"
    And it has "timeframe" of "<timeframe>"
    And it has "model_year.name" of "<make_model_year>"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "<emission>"
    Examples:
      | distance | make_model_year |  timeframe           | emission |
      |    30000 | Acura RSX 2003  | 2010-03-01/2010-12-21|   7036.7 |
      |    80000 | Honda FIT 2008  | 2009-01-01/2009-12-31|  23153.5 |

  Scenario: Calculation with multiple distance estimates
    Given an automobile has "annual_distance_estimate" of "33796.2"
    And it has "daily_duration" of "3.0"
    And it has "timeframe" of "2010-01-01/2011-01-01"
    And it has "weekly_distance_estimate" of "804.672"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "9808.1"
