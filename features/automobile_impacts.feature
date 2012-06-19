Feature: Automobile Impact Calculations
  The automobile model should generate correct impact calculations

  Background:
    Given a Automobile

  Scenario: Automobile emission from nothing
    Given an automobile has nothing
    When impacts are calculated
    And the amount of "carbon" should be within "0.01" of "5352.00"
    And the amount of "energy" should be within "0.01" of "76889.02"
    # Then the calculation should comply with standards "ghg_protocol_scope_3, iso"

  Scenario Outline: Automobile emission from acquisition, retirement, and timeframe
    Given it has "acquisition" of "<acquisition>"
    And it has "retirement" of "<retirement>"
    And it is the year "<year>"
    When impacts are calculated
    And the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | acquisition | retirement | year | energy   | carbon  |
      | 2009-01-01  | 2012-01-01 | 2010 | 76889.02 | 5352.00 |
      | 2010-01-01  | 2010-07-01 | 2010 | 38128.53 | 2654.01 |
      | 2010-01-01  | 2010-02-01 | 2010 |  6530.30 |  454.55 |
      | 2008-01-01  | 2009-01-01 | 2010 |     0.0  |    0.0  |
      | 2008-01-01  | 2009-01-01 | 2008 | 76889.02 | 5388.10 |

  Scenario Outline: Calculations from country
    Given it has "country.iso_3166_code" of "<country>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | country | energy   | carbon  |
      | GB      | 76889.02 | 5352.00 |
      | US      | 63252.99 | 4455.09 |

  Scenario Outline: Automobile emission from hybridity
    Given it has "hybridity" of "<hybridity>"
    When impacts are calculated
    And the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | hybridity | energy   | carbon  |
      | true      | 53577.98 | 3818.72 |
      | false     | 77608.44 | 5399.32 |

  Scenario Outline: Automobile emission from size class and hybridity
    Given it has "size_class.name" of "Midsize Car"
    And it has "hybridity" of "<hybridity>"
    When impacts are calculated
    And the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | hybridity | energy   | carbon  |
      | true      | 45389.87 | 3226.00 |
      | false     | 85106.01 | 5838.32 |

  Scenario Outline: Automobile emission from make
    Given it has "make.name" of "<make>"
    When impacts are calculated
    And the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | make   | energy   | carbon  |
      | Toyota | 50602.39 | 3623.00 |
      | Ford   | 57502.71 | 4076.87 |

  Scenario Outline: Automobile emission from make year
    Given it has "make.name" of "<make>"
    And it has "year.year" of "<year>"
    When impacts are calculated
    And the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | make   | year | energy   | carbon  |
      | Toyota | 2003 | 52710.82 | 3761.69 |
      | Ford   | 2012 | 63252.99 | 4455.09 |
      | Toyota | 2012 | 50602.39 | 3623.00 |
      | Ford   | 2003 | 57502.71 | 4076.87 |

  Scenario Outline: Automobile emission from make model and urbanity
    Given it has "make.name" of "<make>"
    And it has "model.name" of "<model>"
    And it has "urbanity" of "0.5"
    When make_model is determined
    And impacts are calculated
    And the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | make       | model        | energy   | carbon  |
      | Toyota     | Prius        | 29634.87 | 2152.03 |
      | Ford       | F150 FFV     | 99531.25 | 6989.13 |
      | Chevrolet  | Volt         | 36235.29 | 2585.78 |
      | Nissan     | Leaf         | 15076.92 | 2748.08 |
      | Volkswagen | Jetta Diesel | 45903.85 | 3348.97 |
      | Honda      | Civic CNG    | 51136.36 | 3042.82 |
      | Honda      | FCX          | 24230.77 |  126.00 |

  Scenario Outline: Automobile emission from make model year and urbanity
    Given it has "make.name" of "<make>"
    And it has "model.name" of "<model>"
    And it has "year.year" of "<year>"
    And it has "urbanity" of "0.5"
    When make_model_year is determined
    And impacts are calculated
    And the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | make       | model        | year | energy    | carbon  |
      | Toyota     | Prius        | 2003 |  35028.59 | 2471.63 |
      | Ford       | F150 FFV     | 2012 | 142222.22 | 9866.03 |
      | Chevrolet  | Volt         | 2012 |  52705.88 | 3707.37 |
      | Nissan     | Leaf         | 2012 |  15076.92 | 2748.08 |
      | Volkswagen | Jetta Diesel | 2003 |  42777.78 | 3126.14 |
      | Honda      | Civic CNG    | 2003 |  52867.13 | 3129.36 |
      | Honda      | FCX          | 2010 |  24230.77 |  126.00 |

  Scenario Outline: Automobile emission from various distances and fuel efficiency
    Given it has "fuel_efficiency" of "10"
    And it has "daily_duration" of "<d_dur>"
    And it has "speed" of "<speed>"
    And it has "daily_distance" of "<d_dist>"
    And it has "weekly_distance" of "<w_dist>"
    And it has "annual_distance" of "<a_dist>"
    And it is the year "2010"
    When impacts are calculated
    And the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # Then the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | d_dur  | speed | d_dist | w_dist | a_dist  | energy   | carbon  |
      | 7200.0 | 5.0   |        |        |         | 12790.91 |  900.90 |
      |        |       | 10.0   |        |         | 12790.91 |  900.90 |
      |        |       |        | 70.0   |         | 12790.91 |  900.90 |
      | 3600.0 | 5.0   | 10.0   | 70.0   | 10000.0 | 35043.58 | 2468.22 |

  Scenario Outline: Calculations from annual fuel use and fuel
    Given it has "annual_fuel_use" of "10.0"
    And it has "automobile_fuel.code" of "<fuel>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # And the calculation should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | fuel   | energy | carbon |
      | G      | 350.0  | 24.35  |
      | R      | 350.0  | 24.35  |
      | P      | 350.0  | 24.35  |
      | D      | 385.0  | 27.85  |
      | BP-B20 | 380.0  | 22.84  |
      | E      | 250.0  |  5.73  |
      | C      | 380.0  | 21.47  |
      | EL     |  36.0  |  7.08  |
      | H      |1200.0  |  0.82  |

  Scenario Outline: Calculations from fuel efficiency, annual distance, and fuel
    Given it has "fuel_efficiency" of "10.0"
    And it has "annual_distance" of "100.0"
    And it has "automobile_fuel.code" of "<fuel>"
    When impacts are calculated
    # Then trace the calculation
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # And the calculation should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | fuel   | energy | carbon |
      | G      | 350.0  | 24.64  |
      | R      | 350.0  | 24.64  |
      | P      | 350.0  | 24.64  |
      | D      | 385.0  | 28.03  |
      | BP-B20 | 380.0  | 23.02  |
      | E      | 250.0  |  6.10  |
      | C      | 350.0  | 20.50  |
      | EL     | 350.0  | 61.87  |
      | H      | 350.0  |  1.0   |

  Scenario Outline: Calculations from make model year, annual distance, and automobile fuel
    Given it has "annual_distance" of "100"
    And it has "make.name" of "<make>"
    And it has "model.name" of "<model>"
    And it has "year.year" of "<year>"
    And it has "automobile_fuel.code" of "<fuel>"
    When make_model_year is determined
    And impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    And the amount of "energy" should be within "0.01" of "<energy>"
    # And the calculation should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | make       | model        | year | fuel   | energy | carbon | notes |
      | Toyota     | Prius        | 2003 | R      | 199.21 | 14.06  | different code meaning gasoline |
      | Ford       | F150 FFV     | 2012 | E      | 440.48 |  9.65  | alt fuel |
      | Chevrolet  | Volt         | 2012 | EL     |  87.50 | 15.92  | alt fuel |
      | Volkswagen | Jetta Diesel | 2003 | BP-B20 | 246.30 | 14.98  | alt fuel |
      | Honda      | Civic CNG    | 2003 | G      | 269.23 | 18.66  | not a fuel for this variant |
