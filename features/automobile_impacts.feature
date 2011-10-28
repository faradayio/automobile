Feature: Automobile Impact Calculations
  The automobile model should generate correct impact calculations

  Background:
    Given a Automobile

  Scenario: Automobile emission from nothing
    Given an automobile has nothing
    When impacts are calculated
    # Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "energy" should be within "0.01" of "94769.12"
    And the amount of "carbon" should be within "0.01" of "6558.18"

  Scenario Outline: Automobile emission from acquisition, retirement, and timeframe
    Given it has "acquisition" of "<acquisition>"
    And it has "retirement" of "<retirement>"
    And it has "timeframe" of "<timeframe>"
    When impacts are calculated
    # Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "energy" should be within "0.01" of "<energy>"
    And the amount of "carbon" should be within "0.01" of "<carbon>"
    Examples:
      | acquisition | retirement | timeframe             | energy   | carbon   |
      | 2010-03-01  | 2010-05-30 | 2010-01-01/2011-01-01 | 23367.73 | 1617.09  |
      | 2010-03-01  | 2010-04-30 | 2010-01-01/2011-01-01 | 15578.49 | 1078.06  |
      | 2010-03-01  | 2010-03-31 | 2010-01-01/2011-01-01 |  7789.24 |  539.03  |
      | 2010-03-01  | 2010-03-31 | 2010-04-01/2011-01-01 |     0.0  |    0.0   |

  Scenario Outline: Automobile emission from hybridity
    Given it has "hybridity" of "<hybridity>"
    When impacts are calculated
    # Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "energy" should be within "0.01" of "<energy>"
    And the amount of "carbon" should be within "0.01" of "<carbon>"
    Examples:
      | hybridity | energy   | carbon  |
      | true      | 69837.15 | 4832.85 |
      | false     | 95496.77 | 6608.54 |

  Scenario Outline: Calculations from hybridity and urbanity
    Given it has "hybridity" of "<hybridity>"
    And it has "urbanity" of "0.5"
    When impacts are calculated
    # Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "energy" should be within "0.01" of "<energy>"
    And the amount of "carbon" should be within "0.01" of "<carbon>"
    Examples:
      | hybridity | energy   | carbon  |
      | true      | 67764.46 | 4689.42 |
      | false     | 95583.53 | 6614.54 |

  Scenario Outline: Automobile emission from size class and hybridity
    Given it has "size_class.name" of "<size_class>"
    And it has "hybridity" of "<hybridity>"
    When impacts are calculated
    # Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "energy" should be within "0.01" of "<energy>"
    And the amount of "carbon" should be within "0.01" of "<carbon>"
    Examples:
      | hybridity | size_class    | energy   | carbon  |
      | true      | Midsize Wagon | 46946.08 | 3248.75 |
      | false     | Midsize Wagon | 64195.05 | 4442.41 |
      | true      | Midsize Car   | 38188.45 | 2642.70 |
      | false     | Midsize Car   | 63647.41 | 4404.51 |
  
  Scenario: Automobile emission from fuel efficiency and annual distance
    Given it has "fuel_efficiency" of "10"
    And it has "annual_distance" of "10000"
    When impacts are calculated
    # Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "energy" should be within "0.01" of "35099.67"
    And the amount of "carbon" should be within "0.01" of "2428.96"
  
  Scenario: Automobile emission from daily duration
    Given it has "daily_duration" of "3600.0"
    And it is the year "2010"
    And it has "speed" of "10"
    And it has "acquisition" of "2010-01-01"
    And it has "retirement" of "2010-02-01"
    When impacts are calculated
    # Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "energy" should be within "0.01" of "1088.09"
    And the amount of "carbon" should be within "0.01" of "75.30"

  Scenario: Automobile emission from daily distance
    Given it has "daily_distance" of "10"
    And it is the year "2010"
    And it has "acquisition" of "2010-01-01"
    And it has "retirement" of "2010-02-01"
    When impacts are calculated
    # Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "energy" should be within "0.01" of "1088.09"
    And the amount of "carbon" should be within "0.01" of "75.30"

  Scenario: Automobile emission from weekly distance
    Given it has "weekly_distance" of "70"
    And it is the year "2010"
    And it has "acquisition" of "2010-01-01"
    And it has "retirement" of "2010-02-01"
    When impacts are calculated
    # Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "energy" should be within "0.01" of "1088.09"
    And the amount of "carbon" should be within "0.01" of "75.30"

  Scenario: Automobile emission from multiple distances
    Given it has "daily_duration" of "3600.0"
    And it is the year "2010"
    And it has "daily_distance" of "10"
    And it has "weekly_distance" of "70"
    And it has "annual_distance" of "10000"
    And it has "acquisition" of "2010-01-01"
    And it has "retirement" of "2010-02-01"
    When impacts are calculated
    # Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "energy" should be within "0.01" of "2981.07"
    And the amount of "carbon" should be within "0.1" of "206.29"

  Scenario Outline: Automobile emission from make and urbanity
    Given it has "make.name" of "<make>"
    And it has "urbanity" of "0.5"
    When impacts are calculated
    # Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "energy" should be within "0.01" of "<energy>"
    And the amount of "carbon" should be within "0.01" of "<carbon>"
    Examples:
      | make   | energy   | carbon  |
      | Toyota | 75815.30 | 5246.55 |
      | Ford   | 94769.12 | 6558.18 |

  Scenario Outline: Automobile emission from make year and urbanity
    Given it has "make.name" of "<make>"
    And it has "year.year" of "<year>"
    And it has "urbanity" of "0.5"
    When impacts are calculated
    # Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "energy" should be within "0.01" of "<energy>"
    And the amount of "carbon" should be within "0.01" of "<carbon>"
    Examples:
      | make   | year | energy   | carbon  |
      | Toyota | 2003 | 78974.27 | 5465.15 |
      | Ford   | 2010 | 82407.93 | 5702.77 |
      | Toyota | 2010 | 75815.30 | 5246.55 |
      | Ford   | 2003 | 94769.12 | 6558.18 |

  Scenario Outline: Automobile emission from make model and urbanity
    Given it has "make.name" of "<make>"
    And it has "model.name" of "<model>"
    And it has "urbanity" of "0.5"
    When impacts are calculated
    # Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "energy" should be within "0.01" of "<energy>"
    And the amount of "carbon" should be within "0.01" of "<carbon>"
    Examples:
      | make   | model | energy   | carbon  |
      | Toyota | Prius | 47384.56 | 3279.09 |
      | Ford   | Focus | 78974.27 | 5465.15 |
      | Toyota | Focus | 75815.30 | 5246.55 |
      | Ford   | Prius | 94769.12 | 6558.18 |

  Scenario Outline: Automobile emission from make model year and urbanity
    Given it has "make.name" of "<make>"
    And it has "model.name" of "<model>"
    And it has "year.year" of "<year>"
    And it has "urbanity" of "0.5"
    When impacts are calculated
    # Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    And the amount of "energy" should be within "0.01" of "<energy>"
    And the amount of "carbon" should be within "0.01" of "<carbon>"
    Examples:
      | make       | model | year | energy   | carbon  |
      | Toyota     | Prius | 2003 | 35000.0  | 2410.5  |
      | Toyota     | Prius | 2010 | 47384.56 | 3279.09 |
      | Ford       | Focus | 2010 | 76885.71 | 5573.43 |
      | Volkswagen | Jetta | 2011 | 68616.67 | 4460.28 |

  Scenario: Automobile emission from fuel and fuel use
    Given it has "automobile_fuel.name" of "regular gasoline"
    And it has "fuel_use" of "1000"
    When impacts are calculated
    # Then the calculation should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the amount of "energy" should be within "0.01" of "35000.00"
    And the amount of "carbon" should be within "0.01" of "2410.50"
