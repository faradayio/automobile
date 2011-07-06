Feature: Automobile Emissions Calculations
  The automobile model should generate correct emission calculations

  Scenario: Automobile emission from nothing
    Given an automobile has nothing
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "5065.88"

  Scenario Outline: Automobile emission from acquisition, retirement, and timeframe
    Given an automobile has "acquisition" of "<acquisition>"
    And it has "retirement" of "<retirement>"
    And it has "timeframe" of "<timeframe>"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "<emission>"
    Examples:
      | acquisition | retirement | timeframe             | emission |
      | 2010-03-01  | 2010-05-30 | 2010-01-01/2011-01-01 | 1249.12  |
      | 2010-03-01  | 2010-04-30 | 2010-01-01/2011-01-01 | 832.75   |
      | 2010-03-01  | 2010-03-31 | 2010-01-01/2011-01-01 | 416.37   |
      | 2010-03-01  | 2010-03-31 | 2010-04-01/2011-01-01 | 0.0      |

  Scenario: Automobile emission from urbanity estimate
    Given an automobile has "urbanity_estimate" of "0.5"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "5065.88"

  Scenario Outline: Automobile emission from hybridity
    Given an automobile has "hybridity" of "<hybridity>"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "<emission>"
    Examples:
      | hybridity | emission |
      | true      | 3699.90  |
      | false     | 5106.17  |

  Scenario Outline: Automobile emission from size class and hybridity
    Given an automobile has "size_class.name" of "<size_class>"
    And it has "hybridity" of "true"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "<emission>"
    Examples:
      | size_class    | emission |
      | Midsize Car   | 1681.70  |
      | Midsize Wagon | 4128.55  |
  
  Scenario: Automobile emission from fuel efficiency and annual distance
    Given an automobile has "fuel_efficiency" of "10"
    And it has "annual_distance" of "10000"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "2425.15"
  
  Scenario: Automobile emission from weekly distance
    Given an automobile has "weekly_distance" of "70"
    And it is the year "2010"
    And it has "acquisition" of "2010-01-01"
    And it has "retirement" of "2010-01-31"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "84.79"

  Scenario: Automobile emission from daily distance
    Given an automobile has "daily_distance" of "10"
    And it is the year "2010"
    And it has "acquisition" of "2010-01-01"
    And it has "retirement" of "2010-01-31"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "84.79"

  Scenario: Automobile emission from daily duration
    Given an automobile has "daily_duration" of "3600.0"
    And it is the year "2010"
    And it has "speed" of "10"
    And it has "acquisition" of "2010-01-01"
    And it has "retirement" of "2010-01-31"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "84.79"
  
  Scenario: Automobile emission from multiple distances
    Given an automobile has "daily_duration" of "3600.0"
    And it is the year "2010"
    And it has "daily_distance" of "10"
    And it has "weekly_distance" of "70"
    And it has "annual_distance" of "10000"
    And it has "acquisition" of "2010-01-01"
    And it has "retirement" of "2010-01-31"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "232.31"

  Scenario: Automobile emission from make and urbanity estimate
    Given an automobile has "make.name" of "Toyota"
    And it has "urbanity_estimate" of "0.5"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "4346.65"

  Scenario: Automobile emission from make year and urbanity estimate
    Given an automobile has "make_year.name" of "Toyota 2003"
    And it has "urbanity_estimate" of "0.5"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "2897.77"

  Scenario: Automobile emission from make model and urbanity estimate
    Given an automobile has "make_model.name" of "Toyota Prius"
    And it has "urbanity_estimate" of "0.5"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "1811.11"

  Scenario: Automobile emission from make model year and urbanity estimate
    Given an automobile has "make_model_year.name" of "Toyota Prius 2003"
    And it has "urbanity_estimate" of "0.5"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "1267.77"

  Scenario: Automobile emission from make model year variant and urbanity estimate
    Given an automobile has "make_model_year_variant.row_hash" of "xxx1"
    And it has "urbanity_estimate" of "0.5"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "1460.44"
