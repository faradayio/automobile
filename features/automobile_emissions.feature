Feature: Automobile Emissions Calculations
  The automobile model should generate correct emission calculations

  Scenario Outline: Standard Calculations for automobiles
    Given an automobile has "annual_distance_estimate" of "<annual_distance>"
    And it has "model_year.name" "<make_model_year>"
    And it has "acquisition" "<acquisition>"
    And it has "retirement" "<retirement>"
    When emissions are calculated
    Then the emission value should be within 0.1 kgs of <emission>
    Examples:
      | annual_distance | make_model_year | acquisition | retirement | emission |
      |           30000 | Acura RSX 2003  | 2008-01-30  | 2009-05-15 |      123 |
      |           30000 | Honda FIT 2008  | 2008-01-30  | 2009-05-15 |      123 |
