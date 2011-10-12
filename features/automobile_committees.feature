Feature: Automobile Committee Calculations
  The automobile model should generate correct committee calculations

  Background:
    Given a Automobile

  Scenario: Retirement committee from default
    Given a characteristic "timeframe" of "2009-03-04/2009-08-17"
    When the "retirement" committee reports
    Then the committee should have used quorum "from acquisition"
    And the conclusion of the committee should be "2009-08-17"

  Scenario Outline: Retirement committee from acquisition
    Given a characteristic "timeframe" of "<timeframe>"
    And a characteristic "acquisition" of "<acquisition>"
    When the "retirement" committee reports
    Then the committee should have used quorum "from acquisition"
    And the conclusion of the committee should be "<retirement>"
    Examples:
      | timeframe             | acquisition | retirement |
      | 2009-03-04/2009-08-17 | 2010-04-21  | 2010-04-21 |
      | 2009-03-04/2009-08-17 | 2007-01-30  | 2009-08-17 |

  Scenario: Acquisition committee from make model year variant
    Given a characteristic "make_model_year_variant.row_hash" of "xxx1"
    When the "acquisition" committee reports
    Then the committee should have used quorum "from make model year variant"
    And the conclusion of the committee should be "2003-01-01"

  Scenario: Acquisition committee from make model year
    Given a characteristic "make_model_year.name" of "Toyota Prius 2003"
    When the "acquisition" committee reports
    Then the committee should have used quorum "from make model year"
    And the conclusion of the committee should be "2003-01-01"

  Scenario: Acquisition committee from make year
    Given a characteristic "make_year.name" of "Toyota 2003"
    When the "acquisition" committee reports
    Then the committee should have used quorum "from make year"
    And the conclusion of the committee should be "2003-01-01"

  Scenario Outline: Acquisition committee from retirement
    Given a characteristic "timeframe" of "<timeframe>"
    And a characteristic "retirement" of "<retirement>"
    When the "acquisition" committee reports
    Then the committee should have used quorum "from retirement"
    And the conclusion of the committee should be "<acquisition_committee>"
    Examples:
      | timeframe             | retirement | acquisition_committee |
      | 2010-08-10/2010-09-16 | 2007-02-03 | 2007-02-03            |
      | 2010-08-10/2010-09-16 | 2010-09-01 | 2010-08-10            |

  Scenario Outline: Active subtimeframe committee from acquisition and retirement
    Given a characteristic "acquisition" of "<acquisition>"
    And a characteristic "retirement" of "<retirement>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "active_subtimeframe" committee reports
    Then the committee should have used quorum "from acquisition and retirement"
    And the conclusion of the committee should be timeframe "<active_subtimeframe>"
    Examples:
      | acquisition | retirement | timeframe             | active_subtimeframe   |
      | 2010-04-21  | 2010-09-01 | 2010-01-01/2010-12-31 | 2010-04-21/2010-09-01 |
      | 2010-04-21  | 2010-09-01 | 2010-05-01/2010-08-01 | 2010-05-01/2010-08-01 |
      | 2010-04-21  | 2010-09-01 | 2010-05-01/2010-12-31 | 2010-05-01/2010-09-01 |
      | 2010-04-21  | 2010-09-01 | 2010-01-01/2010-08-01 | 2010-04-21/2010-08-01 |
      | 2010-04-21  | 2010-09-01 | 2010-01-01/2010-01-31 | 2010-01-01/2010-01-01 |

  Scenario: Urbanity committee from default
    Given the conclusion of the committee should be "0.43"

  Scenario: Hybridity multiplier committee from default
    Given the conclusion of the committee should be "1.0"

  Scenario Outline: Hybridity multiplier committee from hybridity and urbanity
    Given a characteristic "hybridity" of "<hybridity>"
    When the "urbanity" committee reports
    And the "hybridity_multiplier" committee reports
    Then the committee should have used quorum "from hybridity and urbanity"
    And the conclusion of the committee should be "<multiplier>"
    Examples:
      | hybridity | multiplier |
      | true      | 1.36919    |
      | false     | 0.99211    |

  Scenario Outline: Hybridity multiplier committee from size class missing hybridity multipliers
    Given a characteristic "hybridity" of "<hybridity>"
    And a characteristic "size_class.name" of "<size_class>"
    When the "urbanity" committee reports
    And the "hybridity_multiplier" committee reports
    Then the committee should have used quorum "from hybridity and urbanity"
    And the conclusion of the committee should be "<multiplier>"
    Examples:
      | hybridity | size_class    | multiplier |
      | true      | Midsize Wagon | 1.36919    |
      | false     | Midsize Wagon | 0.99211    |

  Scenario Outline: Hybridity multiplier committee from size class with hybridity multipliers
    Given a characteristic "hybridity" of "<hybridity>"
    And a characteristic "size_class.name" of "<size_class>"
    When the "urbanity" committee reports
    And the "hybridity_multiplier" committee reports
    Then the committee should have used quorum "from size class, hybridity, and urbanity"
    And the conclusion of the committee should be "<multiplier>"
    Examples:
      | hybridity | size_class  | multiplier |
      | true      | Midsize Car | 1.68067    |
      | false     | Midsize Car | 0.87464    |

  Scenario Outline: Fuel efficiency committee from hybridity multiplier
    Given a characteristic "hybridity_multiplier" of "<multiplier>"
    When the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from hybridity multiplier"
    And the conclusion of the committee should be "<fe>"
    Examples:
      | multiplier | fe       |
      | 1.0        |  8.58025 |
      | 10         | 85.80250 |

  Scenario: Fuel efficiency committee from make
    Given a characteristic "make.name" of "Toyota"
    And a characteristic "hybridity_multiplier" of "2.0"
    When the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from make and hybridity multiplier"
    And the conclusion of the committee should be "20.0"

  Scenario: Fuel efficiency committee from make year and hybridity multiplier
    Given a characteristic "make_year.name" of "Toyota 2003"
    And a characteristic "hybridity_multiplier" of "2.0"
    When the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from make year and hybridity multiplier"
    And the conclusion of the committee should be "30.0"

  Scenario: Fuel efficiency committee from size class, hybridity multiplier, and urbanity
    Given a characteristic "size_class.name" of "Midsize Car"
    And a characteristic "hybridity_multiplier" of "2.0"
    And a characteristic "urbanity" of "0.5"
    When the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from size class, hybridity multiplier, and urbanity"
    And the conclusion of the committee should be "26.66667"

  Scenario: Fuel efficiency committee from make model and urbanity
    Given a characteristic "make_model.name" of "Toyota Prius"
    And a characteristic "urbanity" of "0.5"
    When the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from make model and urbanity"
    And the conclusion of the committee should be "24.0"

  Scenario: Fuel efficiency committee from make model year and urbanity
    Given a characteristic "make_model_year.name" of "Toyota Prius 2003"
    And a characteristic "urbanity" of "0.5"
    When the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from make model year and urbanity"
    And the conclusion of the committee should be "34.28571"

  Scenario: Fuel efficiency committee from make model year variant and urbanity
    Given a characteristic "make_model_year_variant.row_hash" of "xxx1"
    And a characteristic "urbanity" of "0.5"
    When the "fuel_efficiency" committee reports
    Then the committee should have used quorum "from make model year variant and urbanity"
    And the conclusion of the committee should be "44.44444"

  Scenario: Speed committee from default urbanity
    Given the "speed" committee reports
    Then the committee should have used quorum "from urbanity"
    And the conclusion of the committee should be "50.94388"

  Scenario: Automobile fuel committee from default
    Given the conclusion of the committee should have "annual_distance" of "17923.24"
    And the conclusion of the committee should have "co2_emission_factor" of "2.30958"
    And the conclusion of the committee should have "co2_biogenic_emission_factor" of "0.0"
    And the conclusion of the committee should have "ch4_emission_factor" of "0.00226"
    And the conclusion of the committee should have "n2o_emission_factor" of "0.00705"
    And the conclusion of the committee should have "hfc_emission_factor" of "0.10627"

  Scenario: Automobile fuel committee from make model year variant
    Given a characteristic "make_model_year_variant.row_hash" of "xxx1"
    When the "automobile_fuel" committee reports
    Then the committee should have used quorum "from make model year variant"
    And the conclusion of the committee should have "name" of "diesel"

  Scenario: Annual distance committee from automobile fuel
    Given a characteristic "automobile_fuel.code" of "R"
    When the "annual_distance" committee reports
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "17800.0"

  Scenario: Annual distance committee from size class
    Given a characteristic "size_class.name" of "Midsize Car"
    When the "annual_distance" committee reports
    Then the committee should have used quorum "from size class"
    And the conclusion of the committee should be "16300.0"

  Scenario: Annual distance committee from daily duration, speed and timeframe
    Given a characteristic "daily_duration" of "3600.0"
    And a characteristic "speed" of "10"
    And a characteristic "timeframe" of "2010-01-01/2010-01-31"
    When the "annual_distance" committee reports
    Then the committee should have used quorum "from daily duration, speed, and timeframe"
    And the conclusion of the committee should be "3650.0"

  Scenario: Annual distance committee from daily distance and timeframe
    Given a characteristic "daily_distance" of "10"
    And a characteristic "timeframe" of "2010-01-01/2010-01-31"
    When the "annual_distance" committee reports
    Then the committee should have used quorum "from daily distance and timeframe"
    And the conclusion of the committee should be "3650.0"

  Scenario: Annual distance committee from weekly distance and timeframe
    Given a characteristic "weekly_distance" of "70"
    And a characteristic "timeframe" of "2010-01-01/2010-01-31"
    When the "annual_distance" committee reports
    Then the committee should have used quorum "from weekly distance and timeframe"
    And the conclusion of the committee should be "3650.0"

  Scenario Outline: Distance committee from annual distance, active subtimeframe and timeframe
    Given a characteristic "annual_distance" of "<annual_distance>"
    And a characteristic "active_subtimeframe" of "<active_subtimeframe>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "distance" committee reports
    Then the committee should have used quorum "from annual distance"
    And the conclusion of the committee should be "<distance>"
    Examples:
      | annual_distance | active_subtimeframe   | timeframe             | distance  |
      | 10000           | 2010-01-01/2010-01-31 | 2010-01-01/2010-01-31 | 821.91781 |
      | 10000           | 2010-01-01/2010-01-31 | 2010-01-01/2011-01-01 | 821.91781 |

  Scenario: Fuel use committee from fuel efficiency and distance
    Given a characteristic "distance" of "10000"
    And a characteristic "fuel_efficiency" of "10"
    When the "fuel_use" committee reports
    Then the committee should have used quorum "from fuel efficiency and distance"
    And the conclusion of the committee should be "1000.0"

  Scenario: HFC emission factor committee from default automobile fuel
    Given the "hfc_emission_factor" committee reports
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "0.10627"

  Scenario Outline: HFC emission factor committee from automobile fuel
    Given a characteristic "automobile_fuel.name" of "<fuel>"
    When the "hfc_emission_factor" committee reports
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "<ef>"
    Examples:
      | fuel             | ef   |
      | regular gasoline | 0.1  |
      | diesel           | 0.12 |
      | B20              | 0.12 |

  Scenario: N2O emission factor committee from default automobile fuel
    Given the "n2o_emission_factor" committee reports
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "0.00705"

  Scenario Outline: N2O emission factor committee from automobile fuel
    Given a characteristic "automobile_fuel.name" of "<fuel>"
    When the "n2o_emission_factor" committee reports
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "<ef>"
    Examples:
      | fuel             | ef    |
      | regular gasoline | 0.008 |
      | diesel           | 0.002 |
      | B20              | 0.002 |

  Scenario: CH4 emission factor committee from default automobile fuel
    Given the "ch4_emission_factor" committee reports
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "0.00226"

  Scenario Outline: CH4 emission factor committee from automobile fuel
    Given a characteristic "automobile_fuel.name" of "<fuel>"
    When the "ch4_emission_factor" committee reports
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "<ef>"
    Examples:
      | fuel             | ef     |
      | regular gasoline | 0.002  |
      | diesel           | 0.0001 |
      | B20              | 0.0001 |

  Scenario: CO2 biogenic emission factor committee from default automobile fuel
    Given the "co2_biogenic_emission_factor" committee reports
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "0.0"

  Scenario Outline: CO2 biogenic emission factor committee from automobile fuel
    Given a characteristic "automobile_fuel.name" of "<fuel>"
    When the "co2_biogenic_emission_factor" committee reports
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "<ef>"
    Examples:
      | fuel             | ef  |
      | regular gasoline | 0.0 |
      | diesel           | 0.0 |
      | B20              | 0.5 |

  Scenario: CO2 emission factor committee from default automobile fuel
    Given the "co2_emission_factor" committee reports
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "2.30958"

  Scenario Outline: CO2 emission factor committee from automobile fuel
    Given a characteristic "automobile_fuel.name" of "<fuel>"
    When the "co2_emission_factor" committee reports
    Then the committee should have used quorum "from automobile fuel"
    And the conclusion of the committee should be "<ef>"
    Examples:
      | fuel             | ef  |
      | regular gasoline | 2.3 |
      | diesel           | 2.7 |
      | B20              | 2.2 |

  Scenario: HFC emission from fuel use and hfc emission factor
    Given a characteristic "fuel_use" of "1000"
    And a characteristic "hfc_emission_factor" of "0.1"
    When the "hfc_emission" committee reports
    Then the committee should have used quorum "from fuel use and hfc emission factor"
    And the conclusion of the committee should be "100.0"

  Scenario: N2O emission from fuel use and n2o emission factor
    Given a characteristic "fuel_use" of "1000"
    And a characteristic "n2o_emission_factor" of "0.008"
    When the "n2o_emission" committee reports
    Then the committee should have used quorum "from fuel use and n2o emission factor"
    And the conclusion of the committee should be "8.0"

  Scenario: CH4 emission from fuel use and ch4 emission factor
    Given a characteristic "fuel_use" of "1000"
    And a characteristic "ch4_emission_factor" of "0.002"
    When the "ch4_emission" committee reports
    Then the committee should have used quorum "from fuel use and ch4 emission factor"
    And the conclusion of the committee should be "2.0"

  Scenario: CO2 biogenic emission from fuel use and co2 biogenic emission factor
    Given a characteristic "fuel_use" of "1000"
    And a characteristic "co2_biogenic_emission_factor" of "0.0"
    When the "co2_biogenic_emission" committee reports
    Then the committee should have used quorum "from fuel use and co2 biogenic emission factor"
    And the conclusion of the committee should be "0.0"

  Scenario: CO2 emission from fuel use and co2 emission factor
    Given a characteristic "fuel_use" of "1000"
    And a characteristic "co2_emission_factor" of "2.3"
    When the "co2_emission" committee reports
    Then the committee should have used quorum "from fuel use and co2 emission factor"
    And the conclusion of the committee should be "2300.0"
