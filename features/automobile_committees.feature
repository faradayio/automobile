Feature: Automobile Committee Calculations
  The automobile model should generate correct committee calculations

  Background:
    Given a Automobile

  Scenario Outline: Make model committee from valid make model combination
    Given a characteristic "make.name" of "<make>"
    And a characteristic "model.name" of "<model>"
    When the "make_model" committee reports
    Then the committee should have used quorum "from make and model"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the conclusion of the committee should have "name" of "<make_model>"
    Examples:
      | make   | model | make_model   |
      | Toyota | Prius | Toyota Prius |
      | Ford   | Focus | Ford Focus   |

  Scenario Outline: Make model committee from invalid make model combination
    Given a characteristic "make.name" of "<make>"
    And a characteristic "model.name" of "<model>"
    When the "make_model" committee reports
    Then the conclusion of the committee should be nil
    Examples:
      | make   | model |
      | Toyota | Focus |
      | Ford   | Prius |

  Scenario: Make year committee from valid make year combination
    Given a characteristic "make.name" of "Toyota"
    And a characteristic "year.year" of "2003"
    When the "make_year" committee reports
    Then the committee should have used quorum "from make and year"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the conclusion of the committee should have "name" of "Toyota 2003"

  Scenario: Make year committee from invalid make year combination
    Given a characteristic "make.name" of "Toyota"
    And a characteristic "year.year" of "2010"
    When the "make_year" committee reports
    Then the conclusion of the committee should be nil

  Scenario: Make model year committee from valid make model year combination
    Given a characteristic "make.name" of "Toyota"
    And a characteristic "model.name" of "Prius"
    And a characteristic "year.year" of "2003"
    When the "make_model_year" committee reports
    Then the committee should have used quorum "from make, model, and year"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the conclusion of the committee should have "name" of "Toyota Prius 2003"

  Scenario: Make model year committee from invalid make model year combination
    Given a characteristic "make.name" of "Toyota"
    And a characteristic "model.name" of "Focus"
    And a characteristic "year.year" of "2003"
    When the "make_model_year" committee reports
    Then the conclusion of the committee should be nil

  Scenario: Retirement committee from default
    Given a characteristic "timeframe" of "2009-03-04/2009-08-17"
    When the "retirement" committee reports
    Then the committee should have used quorum "default"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "2009-08-17"

  Scenario Outline: Retirement committee from acquisition
    Given a characteristic "timeframe" of "<timeframe>"
    And a characteristic "acquisition" of "<acquisition>"
    When the "retirement" committee reports
    Then the committee should have used quorum "default"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "<retirement>"
    Examples:
      | timeframe             | acquisition | retirement |
      | 2009-03-04/2009-08-17 | 2010-04-21  | 2010-04-21 |
      | 2009-03-04/2009-08-17 | 2007-01-30  | 2009-08-17 |

  Scenario: Acquisition committee from default
    Given a characteristic "timeframe" of "2009-03-04/2009-08-17"
    When the "acquisition" committee reports
    Then the committee should have used quorum "default"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "2009-03-04"

  Scenario Outline: Acquisition committee from retirement
    Given a characteristic "timeframe" of "<timeframe>"
    And a characteristic "retirement" of "<retirement>"
    When the "acquisition" committee reports
    Then the committee should have used quorum "default"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "<acquisition>"
    Examples:
      | timeframe             | retirement | acquisition |
      | 2010-08-10/2010-09-16 | 2007-02-03 | 2007-02-03  |
      | 2010-08-10/2010-09-16 | 2010-09-01 | 2010-08-10  |

  Scenario: Acquisition committee from year
    Given a characteristic "year.year" of "2003"
    When the "acquisition" committee reports
    Then the committee should have used quorum "from year"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "2003-01-01"

  Scenario Outline: Active subtimeframe committee from acquisition and retirement
    Given a characteristic "acquisition" of "<acquisition>"
    And a characteristic "retirement" of "<retirement>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "active_subtimeframe" committee reports
    Then the committee should have used quorum "from acquisition and retirement"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be timeframe "<active_subtimeframe>"
    Examples:
      | acquisition | retirement | timeframe             | active_subtimeframe   |
      | 2010-04-21  | 2010-09-01 | 2010-01-01/2010-12-31 | 2010-04-21/2010-09-01 |
      | 2010-04-21  | 2010-09-01 | 2010-05-01/2010-08-01 | 2010-05-01/2010-08-01 |
      | 2010-04-21  | 2010-09-01 | 2010-05-01/2010-12-31 | 2010-05-01/2010-09-01 |
      | 2010-04-21  | 2010-09-01 | 2010-01-01/2010-08-01 | 2010-04-21/2010-08-01 |
      | 2010-04-21  | 2010-09-01 | 2010-01-01/2010-01-31 | 2010-01-01/2010-01-01 |

  Scenario Outline: Safe country committee
    Given a characteristic "country.iso_3166_code" of "<country>"
    When the "safe_country" committee reports
    Then the committee should have used quorum "<quorum>"
    And the conclusion of the committee should have "name" of "<safe_country>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | country | quorum       | safe_country  |
      |         | default      | fallback      |
      | US      | from country | United States |
      | GB      | default      | fallback      |

  Scenario Outline: Urbanity committee
    Given a characteristic "country.iso_3166_code" of "<country>"
    When the "safe_country" committee reports
    And the "urbanity" committee reports
    Then the committee should have used quorum "from safe country"
    And the conclusion of the committee should be "<urbanity>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | country | urbanity |
      |         | 0.4      |
      | US      | 0.4      |
      | GB      | 0.4      |

  Scenario Outline: Hybridity multiplier committee
    Given a characteristic "hybridity" of "<hybridity>"
    And a characteristic "size_class.name" of "<size_class>"
    When the "safe_country" committee reports
    And the "urbanity" committee reports
    And the "hybridity_multiplier" committee reports
    Then the committee should have used quorum "<quorum>"
    And the conclusion of the committee should be "<hyb_mult>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | hybridity | size_class    | quorum                                   | hyb_mult |
      |           |               | default                                  |  1.0     |
      | true      |               | from hybridity and urbanity              |  1.35700 |
      | false     |               | from hybridity and urbanity              |  0.99238 |
      | true      | Midsize Wagon | from hybridity and urbanity              |  1.35700 |
      | false     | Midsize Wagon | from hybridity and urbanity              |  0.99238 |
      | true      | Midsize Car   | from size class, hybridity, and urbanity |  1.47059 |
      | false     | Midsize Car   | from size class, hybridity, and urbanity |  0.88235 |

  Scenario Outline: Fuel efficiency committee
    Given a characteristic "make.name" of "<make>"
    And a characteristic "year.year" of "<year>"
    And a characteristic "size_class.name" of "<size_class>"
    And a characteristic "urbanity" of "<urb>"
    And a characteristic "country.iso_3166_code" of "<country>"
    And a characteristic "hybridity_multiplier" of "<hyb_mult>"
    When the "make_year" committee reports
    And the "safe_country" committee reports
    And the "fuel_efficiency" committee reports
    Then the committee should have used quorum "<quorum>"
    And the conclusion of the committee should be "<fe>"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | make   | model | year | size_class  | urb | country | hyb_mult | quorum                                              | fe       |
      |        |       |      |             |     |         | 1.0      | from hybridity multiplier and safe country          |  8.22653 |
      |        |       |      |             |     | GB      | 1.0      | from hybridity multiplier and safe country          |  8.22653 |
      |        |       |      |             |     | US      | 2.0      | from hybridity multiplier and safe country          | 20.0     |
      | Toyota |       |      |             |     |         | 2.0      | from make and hybridity multiplier                  | 25.0     |
      | Toyota |       | 2003 |             |     |         | 2.0      | from make year and hybridity multiplier             | 24.0     |
      |        |       |      | Midsize Car | 0.5 |         | 2.0      | from size class, hybridity multiplier, and urbanity | 19.2     |

  Scenario Outline: Fuel efficiency committee - GHGP scope 1 compliant
    Given a characteristic "make.name" of "<make>"
    And a characteristic "model.name" of "<model>"
    And a characteristic "year.year" of "<year>"
    And a characteristic "urbanity" of "<urb>"
    And a characteristic "hybridity_multiplier" of "<hyb_mult>"
    And the "make_model" committee reports
    And the "make_model_year" committee reports
    And the "fuel_efficiency" committee reports
    Then the committee should have used quorum "<quorum>"
    And the conclusion of the committee should be "<fe>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | make   | model | year | urb | hyb_mult | quorum                            | fe   |
      | Toyota | Prius |      | 0.5 | 2.0      | from make model and urbanity      | 20.0 |
      | Toyota | Prius | 2003 | 0.5 | 2.0      | from make model year and urbanity | 18.0 |

  Scenario Outline: Speed committee
    Given a characteristic "country.iso_3166_code" of "<country>"
    When the "safe_country" committee reports
    And the "urbanity" committee reports
    And the "speed" committee reports
    Then the committee should have used quorum "from urbanity and safe country"
    And the conclusion of the committee should be "<speed>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | country | speed |
      |         | 50.0 |
      | US      | 50.0 |
      | GB      | 50.0 |

  Scenario Outline: Automobile fuel committee
    Given a characteristic "make.name" of "<make>"
    And a characteristic "model.name" of "<model>"
    And a characteristic "year.year" of "<year>"
    When the "make_model_year" committee reports
    And the "automobile_fuel" committee reports
    Then the committee should have used quorum "<quorum>"
    And the conclusion should comply with standards "<standards>"    
    And the conclusion of the committee should have "name" of "<fuel>"
    Examples:
      | make       | model | year | quorum               | standards                                       | fuel |
      |            |       |      | default              | ghg_protocol_scope_3, iso                       | fallback |
      | Toyota     | Prius | 2003 | from make model year | ghg_protocol_scope_1, ghg_protocol_scope_3, iso | regular gasoline |
      | Ford       | Focus | 2010 | from make model year | ghg_protocol_scope_1, ghg_protocol_scope_3, iso | diesel           |
      | Volkswagen | Jetta | 2011 | from make model year | ghg_protocol_scope_1, ghg_protocol_scope_3, iso | B20              |

  Scenario Outline: Annual distance committee
    Given a characteristic "automobile_fuel.code" of "<code>"
    And a characteristic "size_class.name" of "<size_class>"
    And a characteristic "daily_duration" of "<daily_dur>"
    And a characteristic "speed" of "<speed>"
    Given a characteristic "daily_distance" of "<d_dist>"
    Given a characteristic "weekly_distance" of "<w_dist>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "annual_distance" committee reports
    Then the committee should have used quorum "<quorum>"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "<dist>"
    Examples:
      | code | size_class  | daily_dur | speed | d_dist | w_dist | timeframe             | quorum                                    | dist    |
      | R    |             |           |       |        |        |                       | from automobile fuel                      | 18000.0 |
      |      | Midsize Car |           |       |        |        |                       | from size class                           | 16000.0 |
      |      |             | 3600.0    | 10.0  |        |        | 2010-01-01/2010-02-01 | from daily duration, speed, and timeframe | 3650.0  |
      |      |             |           |       | 10.0   |        | 2010-01-01/2010-02-01 | from daily distance and timeframe         | 3650.0  |
      |      |             |           |       |        | 70.0   | 2010-01-01/2010-02-01 | from weekly distance and timeframe        | 3650.0  |

  Scenario Outline: Distance committee from annual distance, active subtimeframe and timeframe
    Given a characteristic "annual_distance" of "<annual_distance>"
    And a characteristic "active_subtimeframe" of "<active_subtimeframe>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "distance" committee reports
    Then the committee should have used quorum "from annual distance"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "<distance>"
    Examples:
      | annual_distance | active_subtimeframe   | timeframe             | distance  |
      | 10000           | 2010-01-01/2010-02-01 | 2010-01-01/2010-02-01 | 849.31507 |
      | 10000           | 2010-01-01/2010-02-01 | 2010-01-01/2011-01-01 | 849.31507 |
      | 10000           | 2010-01-01/2011-01-01 | 2010-01-01/2010-02-01 | 10000.0   |
      | 10000           | 2010-01-01/2011-01-01 | 2010-01-01/2011-01-01 | 10000.0   |

  Scenario: Fuel use committee from fuel efficiency and distance
    Given a characteristic "distance" of "10000"
    And a characteristic "fuel_efficiency" of "10"
    When the "fuel_use" committee reports
    Then the committee should have used quorum "from fuel efficiency and distance"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "1000.0"

  Scenario: Energy use committee from fuel use and default automobile fuel
    Given a characteristic "fuel_use" of "1"
    When the "automobile_fuel" committee reports
    And the "energy" committee reports
    Then the committee should have used quorum "from fuel use and automobile fuel"
    And the conclusion should comply with standards ""
    And the conclusion of the committee should be "35.09967"

  Scenario Outline: Energy use committee from default fuel use and automobile fuel
    Given a characteristic "fuel_use" of "1"
    And a characteristic "automobile_fuel.name" of "<fuel>"
    When the "energy" committee reports
    Then the committee should have used quorum "from fuel use and automobile fuel"
    And the conclusion should comply with standards ""
    And the conclusion of the committee should be "<energy>"
    Examples:
      | fuel             | energy |
      | regular gasoline | 35.0   |
      | diesel           | 39.0   |
      | B20              | 35.8   |

  Scenario: HFC emission from fuel use and default automobile fuel
    Given a characteristic "fuel_use" of "1"
    When the "automobile_fuel" committee reports
    And the "hfc_emission" committee reports
    Then the committee should have used quorum "from fuel use and automobile fuel"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "0.1091"

  Scenario Outline: HFC emission from fuel use and automobile fuel
    Given a characteristic "fuel_use" of "1"
    And a characteristic "automobile_fuel.name" of "<fuel>"
    And the "hfc_emission" committee reports
    Then the committee should have used quorum "from fuel use and automobile fuel"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "<emission>"
    Examples:
      | fuel             | emission |
      | regular gasoline | 0.1      |
      | diesel           | 0.125    |
      | B20              | 0.125    |

  Scenario: N2O emission from fuel use and default automobile fuel
    Given a characteristic "fuel_use" of "1"
    When the "automobile_fuel" committee reports
    And the "n2o_emission" committee reports
    Then the committee should have used quorum "from fuel use and automobile fuel"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "0.00782"

  Scenario Outline: N2O emission from fuel use and automobile fuel
    Given a characteristic "fuel_use" of "1"
    And a characteristic "automobile_fuel.name" of "<fuel>"
    And the "n2o_emission" committee reports
    Then the committee should have used quorum "from fuel use and automobile fuel"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "<emission>"
    Examples:
      | fuel             | emission |
      | regular gasoline | 0.008    |
      | diesel           | 0.002    |
      | B20              | 0.002    |

  Scenario: CH4 emission from fuel use and default automobile fuel
    Given a characteristic "fuel_use" of "1"
    When the "automobile_fuel" committee reports
    And the "ch4_emission" committee reports
    Then the committee should have used quorum "from fuel use and automobile fuel"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "0.00206"

  Scenario Outline: CH4 emission from fuel use and automobile fuel
    Given a characteristic "fuel_use" of "1"
    And a characteristic "automobile_fuel.name" of "<fuel>"
    And the "ch4_emission" committee reports
    Then the committee should have used quorum "from fuel use and automobile fuel"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "<emission>"
    Examples:
      | fuel             | emission |
      | regular gasoline | 0.0025   |
      | diesel           | 0.0001   |
      | B20              | 0.0001   |

  Scenario: CO2 biogenic emission from fuel use and default automobile fuel
    Given a characteristic "fuel_use" of "1"
    When the "automobile_fuel" committee reports
    And the "co2_biogenic_emission" committee reports
    Then the committee should have used quorum "from fuel use and automobile fuel"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "0.0"

  Scenario Outline: CO2 biogenic emission from fuel use and automobile fuel
    Given a characteristic "fuel_use" of "1"
    And a characteristic "automobile_fuel.name" of "<fuel>"
    And the "co2_biogenic_emission" committee reports
    Then the committee should have used quorum "from fuel use and automobile fuel"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "<emission>"
    Examples:
      | fuel             | emission |
      | regular gasoline | 0.0      |
      | diesel           | 0.0      |
      | B20              | 0.5      |

  Scenario: CO2 emission from fuel use and default automobile fuel
    Given a characteristic "fuel_use" of "1"
    When the "automobile_fuel" committee reports
    And the "co2_emission" committee reports
    Then the committee should have used quorum "from fuel use and automobile fuel"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "2.30997"

  Scenario Outline: CO2 emission from fuel use and automobile fuel
    Given a characteristic "fuel_use" of "1"
    And a characteristic "automobile_fuel.name" of "<fuel>"
    And the "co2_emission" committee reports
    Then the committee should have used quorum "from fuel use and automobile fuel"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "<emission>"
    Examples:
      | fuel             | emission |
      | regular gasoline | 2.3      |
      | diesel           | 2.7      |
      | B20              | 2.2      |

  Scenario: Carbon impact from co2 emisison, ch4 emission, n2o emission, and hfc emission
    Given a characteristic "co2_emission" of "1"
    And a characteristic "ch4_emission" of "2"
    And a characteristic "n2o_emission" of "3"
    And a characteristic "hfc_emission" of "4"
    When the "carbon" committee reports
    Then the committee should have used quorum "from co2 emission, ch4 emission, n2o emission, and hfc emission"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "10.0"
