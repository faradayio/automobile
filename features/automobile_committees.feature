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

  Scenario: Urbanity committee from default
    When the "urbanity" committee reports
    Then the committee should have used quorum "default"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "0.4"

  Scenario: Hybridity multiplier committee from default
    When the "hybridity_multiplier" committee reports
    Then the committee should have used quorum "default"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "1.0"

  Scenario Outline: Hybridity multiplier committee from hybridity and default urbanity
    Given a characteristic "hybridity" of "<hybridity>"
    When the "urbanity" committee reports
    And the "hybridity_multiplier" committee reports
    Then the committee should have used quorum "from hybridity and urbanity"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "<multiplier>"
    Examples:
      | hybridity | multiplier |
      | true      | 1.35700    |
      | false     | 0.99238    |

  Scenario Outline: Hybridity multiplier committee from size class missing hybridity multipliers
    Given a characteristic "hybridity" of "<hybridity>"
    And a characteristic "size_class.name" of "<size_class>"
    When the "urbanity" committee reports
    And the "hybridity_multiplier" committee reports
    Then the committee should have used quorum "from hybridity and urbanity"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "<multiplier>"
    Examples:
      | hybridity | size_class    | multiplier |
      | true      | Midsize Wagon | 1.35700    |
      | false     | Midsize Wagon | 0.99238    |

  Scenario Outline: Hybridity multiplier committee from size class with hybridity multipliers
    Given a characteristic "hybridity" of "<hybridity>"
    And a characteristic "size_class.name" of "<size_class>"
    When the "urbanity" committee reports
    And the "hybridity_multiplier" committee reports
    Then the committee should have used quorum "from size class, hybridity, and urbanity"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "<multiplier>"
    Examples:
      | hybridity | size_class  | multiplier |
      | true      | Midsize Car | 1.47059    |
      | false     | Midsize Car | 0.88235    |

  Scenario: Fuel efficiency committee from hybridity multiplier
    Given a characteristic "hybridity_multiplier" of "10"
    When the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from hybridity multiplier"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "100.0"

  Scenario: Fuel efficiency committee from make
    Given a characteristic "make.name" of "Toyota"
    And a characteristic "hybridity_multiplier" of "2.0"
    When the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from make and hybridity multiplier"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "25.0"

  Scenario: Fuel efficiency committee from make year and hybridity multiplier
    Given a characteristic "make.name" of "Toyota"
    And a characteristic "year.year" of "2003"
    And a characteristic "hybridity_multiplier" of "2.0"
    When the "make_year" committee reports
    And the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from make year and hybridity multiplier"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "24.0"

  Scenario: Fuel efficiency committee from size class, hybridity multiplier, and urbanity
    Given a characteristic "size_class.name" of "Midsize Car"
    And a characteristic "hybridity_multiplier" of "2.0"
    And a characteristic "urbanity" of "0.5"
    When the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from size class, hybridity multiplier, and urbanity"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "19.2"

  Scenario: Fuel efficiency committee from make model and urbanity
    Given a characteristic "make.name" of "Toyota"
    And a characteristic "model.name" of "Prius"
    And a characteristic "urbanity" of "0.5"
    When the "make_model" committee reports
    And the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from make model and urbanity"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "20.0"

  Scenario: Fuel efficiency committee from make model year and urbanity
    Given a characteristic "make.name" of "Toyota"
    And a characteristic "model.name" of "Prius"
    And a characteristic "year.year" of "2003"
    And a characteristic "urbanity" of "0.5"
    When the "make_model_year" committee reports
    And the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from make model year and urbanity"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "18.0"

  Scenario: Speed committee from default urbanity
    When the "urbanity" committee reports
    And the "speed" committee reports
    Then the committee should have used quorum "from urbanity"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "50.0"

  Scenario: Automobile fuel committee from default
    When the "automobile_fuel" committee reports
    Then the committee should have used quorum "default"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    And the conclusion of the committee should have "annual_distance" of "27000"
    And the conclusion of the committee should have "energy_content" of "35.09967"
    And the conclusion of the committee should have "co2_emission_factor" of "2.30997"
    And the conclusion of the committee should have "co2_biogenic_emission_factor" of "0.0"
    And the conclusion of the committee should have "ch4_emission_factor" of "0.00206"
    And the conclusion of the committee should have "n2o_emission_factor" of "0.00782"
    And the conclusion of the committee should have "hfc_emission_factor" of "0.10910"

  Scenario: Annual distance committee from automobile fuel
    Given a characteristic "automobile_fuel.code" of "R"
    When the "annual_distance" committee reports
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "18000"

  Scenario: Annual distance committee from size class
    Given a characteristic "size_class.name" of "Midsize Car"
    When the "annual_distance" committee reports
    Then the committee should have used quorum "from size class"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "16000"

  Scenario: Annual distance committee from daily duration, speed and timeframe
    Given a characteristic "daily_duration" of "3600.0"
    And a characteristic "speed" of "10"
    And a characteristic "timeframe" of "2010-01-01/2010-02-01"
    When the "annual_distance" committee reports
    Then the committee should have used quorum "from daily duration, speed, and timeframe"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "3650"

  Scenario: Annual distance committee from daily distance and timeframe
    Given a characteristic "daily_distance" of "10"
    And a characteristic "timeframe" of "2010-01-01/2010-02-01"
    When the "annual_distance" committee reports
    Then the committee should have used quorum "from daily distance and timeframe"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "3650"

  Scenario: Annual distance committee from weekly distance and timeframe
    Given a characteristic "weekly_distance" of "70"
    And a characteristic "timeframe" of "2010-01-01/2010-02-01"
    When the "annual_distance" committee reports
    Then the committee should have used quorum "from weekly distance and timeframe"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    And the conclusion of the committee should be "3650"

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
