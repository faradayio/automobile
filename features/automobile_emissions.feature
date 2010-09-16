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
      |    30000 | Acura RSX 2003  | 2008-01-30/2009-05-20|   8706.4 |
      |    80000 | Honda FIT 2008  | 2008-01-30/2009-05-20|  23217.1 |
