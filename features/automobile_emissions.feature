Feature: Automobile Emissions Calculations
  The automobile model should generate correct emission calculations

  Scenario: Automobile emission from nothing
    Given an automobile has nothing
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "5520.12"

  Scenario Outline: Automobile emission from acquisition, retirement, and timeframe
    Given an automobile has "acquisition" of "<acquisition>"
    And it has "retirement" of "<retirement>"
    And it has "timeframe" of "<timeframe>"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "<emission>"
    Examples:
      | acquisition | retirement | timeframe             | emission |
      | 2010-04-21  | 2010-09-01 | 2010-01-01/2010-12-31 | 2011.44  |
      | 2010-04-21  | 2010-09-01 | 2010-05-01/2010-08-01 | 1391.37  |
      | 2010-04-21  | 2010-09-01 | 2010-05-01/2010-12-31 | 1860.21  |
      | 2010-04-21  | 2010-09-01 | 2010-01-01/2010-08-01 | 1542.61  |
      | 2010-04-21  | 2010-09-01 | 2010-01-01/2010-01-31 | 0.0      |

  Scenario: Automobile emission from fuel type
    Given an automobile has "fuel_type.code" of "P"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "5249.18"

  Scenario Outline: Automobile emission from hybridity
    Given an automobile has "hybridity" of "<hybridity>"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "<emission>"
    Examples:
      | hybridity | emission |
      | true      | 4031.66  |
      | false     | 5564.02  |

  Scenario: Calculation with multiple distances
    Given an automobile has "daily_duration" of "5"
    And it has "daily_distance" of "10"
    And it has "weekly_distance" of "100"
    And it has "annual_distance" of "1000"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "290.21"

  Scenario: Automobile emission from urbanity
    Given an automobile has "urbanity" of "0.5"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "5520.12"

  Scenario Outline: Automobile emission from size class
    Given an automobile has "size_class.name" of "<size_class>"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "<emission>"
    Examples:
      | size_class    | emission |
      | Midsize Car   | 1780.43  |
      | Midsize Wagon | 5341.29  |
  
  Scenario: Automobile emission from fuel efficiency
    Given an automobile has "fuel_efficiency" of "20"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "2368.20"
  
  Scenario: Automobile emission from annual distance
    Given an automobile has "annual_distance" of "1000"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "290.21"

  Scenario: Automobile emission from weekly distance
    Given an automobile has "weekly_distance" of "100"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "1513.26"

  Scenario: Automobile emission from daily distance
    Given an automobile has "daily_distance" of "10"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "1059.28"

  Scenario: Automobile emission from daily duration
    Given an automobile has "daily_duration" of "5"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "26981.99"
  
  Scenario: Automobile emission from make
    Given an automobile has "make.name" of "Acura"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "4736.40"

  Scenario: Automobile emission from make year
    Given an automobile has "make_year.name" of "Acura 2003"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "3157.60"

  Scenario: Automobile emission from make model
    Given an automobile has "make_model.name" of "Acura RSX"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "6773.06"

  Scenario: Automobile emission from make model year
    Given an automobile has "make_model_year.name" of "Acura RSX 2003"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "2437.67"

  Scenario: Automobile emission from make model year variant
    Given an automobile has "make_model_year_variant.row_hash" of "xxx1"
    When emissions are calculated
    Then the emission value should be within "0.01" kgs of "3220.31"
