Feature: Automobile Impact Calculations
  The automobile model should generate correct impact calculations

  Background:
    Given a Automobile

  Scenario: Automobile emission from nothing
    Given an automobile has nothing
    When impacts are calculated
    Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "carbon" should be within "0.01" kgs of "6558.18"

  Scenario Outline: Automobile emission from acquisition, retirement, and timeframe
    Given it has "acquisition" of "<acquisition>"
    And it has "retirement" of "<retirement>"
    And it has "timeframe" of "<timeframe>"
    When impacts are calculated
    Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "carbon" should be within "0.01" kgs of "<emission>"
    Examples:
      | acquisition | retirement | timeframe             | emission |
      | 2010-03-01  | 2010-05-30 | 2010-01-01/2011-01-01 | 1617.09  |
      | 2010-03-01  | 2010-04-30 | 2010-01-01/2011-01-01 | 1078.06  |
      | 2010-03-01  | 2010-03-31 | 2010-01-01/2011-01-01 | 539.03   |
      | 2010-03-01  | 2010-03-31 | 2010-04-01/2011-01-01 | 0.0      |

  Scenario: Automobile emission from urbanity
    Given it has "urbanity" of "0.5"
    When impacts are calculated
    Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "carbon" should be within "0.01" kgs of "6558.18"

  Scenario Outline: Automobile emission from hybridity
    Given it has "hybridity" of "<hybridity>"
    When impacts are calculated
    Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "carbon" should be within "0.01" kgs of "<emission>"
    Examples:
      | hybridity | emission |
      | true      | 4832.85  |
      | false     | 6608.54  |

  Scenario Outline: Automobile emission from size class and hybridity
    Given it has "size_class.name" of "<size_class>"
    And it has "hybridity" of "<hybridity>"
    When impacts are calculated
    Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "carbon" should be within "0.01" kgs of "<emission>"
    Examples:
      | hybridity | size_class    | emission |
      | true      | Midsize Wagon | 3248.75  |
      | false     | Midsize Wagon | 4442.41  |
      | true      | Midsize Car   | 2642.70  |
      | false     | Midsize Car   | 4404.51  |
  
  Scenario: Automobile emission from fuel efficiency and annual distance
    Given it has "fuel_efficiency" of "10"
    And it has "annual_distance" of "10000"
    When impacts are calculated
    Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "carbon" should be within "0.01" kgs of "2428.96"
  
  Scenario: Automobile emission from weekly distance
    Given it has "weekly_distance" of "70"
    And it is the year "2010"
    And it has "acquisition" of "2010-01-01"
    And it has "retirement" of "2010-02-01"
    When impacts are calculated
    Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "carbon" should be within "0.01" kgs of "75.30"

  Scenario: Automobile emission from daily distance
    Given it has "daily_distance" of "10"
    And it is the year "2010"
    And it has "acquisition" of "2010-01-01"
    And it has "retirement" of "2010-02-01"
    When impacts are calculated
    Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "carbon" should be within "0.01" kgs of "75.30"

  Scenario: Automobile emission from daily duration
    Given it has "daily_duration" of "3600.0"
    And it is the year "2010"
    And it has "speed" of "10"
    And it has "acquisition" of "2010-01-01"
    And it has "retirement" of "2010-02-01"
    When impacts are calculated
    Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "carbon" should be within "0.01" kgs of "75.30"
  
  Scenario: Automobile emission from multiple distances
    Given it has "daily_duration" of "3600.0"
    And it is the year "2010"
    And it has "daily_distance" of "10"
    And it has "weekly_distance" of "70"
    And it has "annual_distance" of "10000"
    And it has "acquisition" of "2010-01-01"
    And it has "retirement" of "2010-02-01"
    When impacts are calculated
    Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "carbon" should be within "0.1" kgs of "206.29"

  Scenario Outline: Automobile emission from make and urbanity
    Given it has "make.name" of "<make>"
    And it has "urbanity" of "0.5"
    When impacts are calculated
    Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "carbon" should be within "0.01" kgs of "<emission>"
    Examples:
      | make   | emission |
      | Toyota | 5246.55  |
      | Ford   | 6558.18  |

  Scenario Outline: Automobile emission from make year and urbanity
    Given it has "make.name" of "<make>"
    And it has "year.year" of "<year>"
    And it has "urbanity" of "0.5"
    When impacts are calculated
    Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "carbon" should be within "0.01" kgs of "<emission>"
    Examples:
      | make   | year | emission |
      | Toyota | 2003 | 5465.15  |
      | Ford   | 2010 | 5702.77  |
      | Toyota | 2010 | 5246.55  |
      | Ford   | 2003 | 6558.18  |

  Scenario Outline: Automobile emission from make model and urbanity
    Given it has "make.name" of "<make>"
    And it has "model.name" of "<model>"
    And it has "urbanity" of "0.5"
    When impacts are calculated
    Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "carbon" should be within "0.01" kgs of "<emission>"
    Examples:
      | make   | model | emission |
      | Toyota | Prius | 3279.09  |
      | Ford   | Focus | 5465.15  |
      | Toyota | Focus | 5246.55  |
      | Ford   | Prius | 6558.18  |

  Scenario Outline: Automobile emission from make model year and urbanity
    Given it has "make.name" of "<make>"
    And it has "model.name" of "<model>"
    And it has "year.year" of "<year>"
    And it has "urbanity" of "0.5"
    When impacts are calculated
    Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "carbon" should be within "0.01" kgs of "<emission>"
    Examples:
      | make   | model | year | emission |
      | Toyota | Prius | 2003 | 3643.44  |
      | Toyota | Prius | 2010 | 3279.09  |
      | Ford   | Focus | 2003 | 5465.15  |

  Scenario: Automobile emission from fuel and fuel use
    Given it has "automobile_fuel.name" of "regular gasoline"
    And it has "fuel_use" of "1000"
    When impacts are calculated
    Then the calculation should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the amount of "carbon" should be within "0.01" kgs of "2410.50"
