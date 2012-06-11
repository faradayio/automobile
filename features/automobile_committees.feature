Feature: Automobile Committee Calculations
  The automobile model should generate correct committee calculations

  Background:
    Given a Automobile

  Scenario: Make model committee from valid make model combination
    Given a characteristic "make.name" of "Toyota"
    And a characteristic "model.name" of "Prius"
    When the "make_model" committee reports
    Then the committee should have used quorum "from make and model"
    And the conclusion of the committee should have "name" of "Toyota Prius"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"

  Scenario: Make model committee from invalid make model combination
    Given a characteristic "make.name" of "Toyota"
    And a characteristic "model.name" of "Focus"
    When the "make_model" committee reports
    Then the conclusion of the committee should be nil

  Scenario: Make year committee from valid make year combination
    Given a characteristic "make.name" of "Toyota"
    And a characteristic "year.year" of "2003"
    When the "make_year" committee reports
    Then the committee should have used quorum "from make and year"
    And the conclusion of the committee should have "name" of "Toyota 2003"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"

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
    And the conclusion of the committee should have "name" of "Toyota Prius 2003"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"

  Scenario: Make model year committee from invalid make model year combination
    Given a characteristic "make.name" of "Toyota"
    And a characteristic "model.name" of "Focus"
    And a characteristic "year.year" of "2003"
    When the "make_model_year" committee reports
    Then the conclusion of the committee should be nil

  Scenario Outline: Retirement committee
    Given a characteristic "timeframe" of "2010-01-01/2011-01-01"
    And a characteristic "acquisition" of "<acquisition>"
    When the "retirement" committee reports
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "<retirement>"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | acquisition | retirement | notes |
      |             | 2011-01-01 | unknown acq use last day of timeframe |
      | 2009-01-01  | 2011-01-01 | acq before timeframe use last day of timeframe |
      | 2010-07-01  | 2011-01-01 | acq during timeframe use last day of timeframe |
      | 2012-01-01  | 2012-01-01 | acq after timeframe use acq |

  Scenario Outline: Acquisition committee
    Given a characteristic "timeframe" of "2010-01-01/2011-01-01"
    And a characteristic "retirement" of "<retirement>"
    And a characteristic "year.year" of "<year>"
    When the "acquisition" committee reports
    Then the committee should have used quorum "<quorum>"
    And the conclusion of the committee should be "<acquisition>"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | retirement | year | acquisition | quorum                        | notes |
      | 2009-01-01 |      | 2009-01-01  | from timeframe and retirement | no year retired before timeframe use retirement |
      | 2010-07-01 |      | 2010-01-01  | from timeframe and retirement | no year retired during timeframe use first day of timeframe |
      | 2012-01-01 |      | 2010-01-01  | from timeframe and retirement | no year retired after timeframe first day of timeframe |
      | 2009-01-01 | 2003 | 2003-01-01  | from year                     | year use first day of year |

  Scenario Outline: Active subtimeframe committee
    Given a characteristic "acquisition" of "<acquisition>"
    And a characteristic "retirement" of "<retirement>"
    And a characteristic "timeframe" of "2010-01-01/2011-01-01"
    When the "active_subtimeframe" committee reports
    Then the committee should have used quorum "from acquisition and retirement"
    And the conclusion of the committee should be timeframe "<active_subtimeframe>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | acquisition | retirement | active_subtimeframe   | notes |
      | 2009-04-21  | 2009-09-01 | 2010-01-01/2010-01-01 | both before -> 0 days |
      | 2009-04-21  | 2010-09-01 | 2010-01-01/2010-09-01 | acq before retire during -> start of timeframe to retire |
      | 2010-04-21  | 2010-09-01 | 2010-04-21/2010-09-01 | both during -> acq to retire |
      | 2010-04-21  | 2011-09-01 | 2010-04-21/2011-01-01 | acq during retire after -> acq to end of timeframe |
      | 2011-04-21  | 2011-09-01 | 2010-01-01/2010-01-01 | both after -> 0 days |
      | 2009-04-21  | 2011-09-01 | 2010-01-01/2011-01-01 | acq before retire after -> timeframe |
      | 2010-09-01  | 2010-04-21 | 2010-04-21/2010-04-21 | acq after retire -> 0 days |

  Scenario Outline: Urbanity committee
    Given a characteristic "country.iso_3166_code" of "<country>"
    When the "urbanity" committee reports
    Then the committee should have used quorum "<quorum>"
    And the conclusion of the committee should be "<urbanity>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | country | urbanity | quorum       |
      |         |  0.58333 | default      |
      | GB      |  0.58333 | default      |
      | US      |  0.58333 | from country |

  Scenario Outline: Hybridity multiplier committee
    Given a characteristic "hybridity" of "<hybridity>"
    And a characteristic "size_class.name" of "<size_class>"
    When the "urbanity" committee reports
    And the "hybridity_multiplier" committee reports
    Then the committee should have used quorum "<quorum>"
    And the conclusion of the committee should be "<hyb_mult>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | hybridity | size_class    | hyb_mult | quorum                                   |
      |           |               |  1.0     | default                                  |
      | true      |               |  1.43509 | from hybridity and urbanity              |
      | false     |               |  0.99073 | from hybridity and urbanity              |
      | true      | Midsize Wagon |  1.43509 | from hybridity and urbanity              |
      | false     | Midsize Wagon |  0.99073 | from hybridity and urbanity              |
      | true      | Midsize Car   |  1.5     | from size class, hybridity, and urbanity |
      | false     | Midsize Car   |  0.8     | from size class, hybridity, and urbanity |

  Scenario Outline: Automobile fuel committee
    Given a characteristic "make.name" of "<make>"
    And a characteristic "model.name" of "<model>"
    And a characteristic "year.year" of "<year>"
    When the "make_model" committee reports
    And the "make_model_year" committee reports
    And the "automobile_fuel" committee reports
    Then the committee should have used quorum "<quorum>"
    And the conclusion should comply with standards "<standards>"
    And the conclusion of the committee should have "name" of "<fuel>"
    Examples:
      | make       | model | year | fuel     | quorum               | standards                                       |
      |            |       |      | fallback | default              | ghg_protocol_scope_3, iso                       |
      | Toyota     | Prius |      | gasoline | from make model      | ghg_protocol_scope_1, ghg_protocol_scope_3, iso |
      | Toyota     | Prius | 2003 | gasoline | from make model year | ghg_protocol_scope_1, ghg_protocol_scope_3, iso |

  Scenario Outline: Fuel efficiency highway committee
    Given a characteristic "make.name" of "<make>"
    And a characteristic "model.name" of "<model>"
    And a characteristic "year.year" of "<year>"
    And a characteristic "automobile_fuel.code" of "<fuel>"
    When the "make_model" committee reports
    When the "make_model_year" committee reports
    And the "fuel_efficiency_highway" committee reports
    Then the committee should have used quorum "<quorum>"
    And the conclusion of the committee should be "<fe>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | make | model    | year | fuel | fe  | quorum                                   |
      | Ford | F150 FFV |      | R    | 8.0 | from make model and automobile fuel      |
      | Ford | F150 FFV |      | E    | 6.0 | from make model and automobile fuel      |
      | Ford | F150 FFV | 2012 | R    | 9.0 | from make model year and automobile fuel |
      | Ford | F150 FFV | 2012 | E    | 7.0 | from make model year and automobile fuel |

  Scenario Outline: Fuel efficiency highway committee from invalid fuel
    Given a characteristic "make.name" of "<make>"
    And a characteristic "model.name" of "<model>"
    And a characteristic "year.year" of "<year>"
    And a characteristic "automobile_fuel.code" of "<fuel>"
    When the "make_model" committee reports
    When the "make_model_year" committee reports
    And the "fuel_efficiency_highway" committee reports
    Then the conclusion of the committee should be nil
    Examples:
      | make | model    | year | fuel |
      | Ford | F150 FFV |      | D    |
      | Ford | F150 FFV | 2012 | D    |

  Scenario Outline: Fuel efficiency city committee
    Given a characteristic "make.name" of "<make>"
    And a characteristic "model.name" of "<model>"
    And a characteristic "year.year" of "<year>"
    And a characteristic "automobile_fuel.code" of "<fuel>"
    When the "make_model" committee reports
    When the "make_model_year" committee reports
    And the "fuel_efficiency_city" committee reports
    Then the committee should have used quorum "<quorum>"
    And the conclusion of the committee should be "<fe>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | make | model    | year | fuel | fe  | quorum                                   |
      | Ford | F150 FFV |      | R    | 6.0 | from make model and automobile fuel      |
      | Ford | F150 FFV |      | E    | 4.0 | from make model and automobile fuel      |
      | Ford | F150 FFV | 2012 | R    | 7.0 | from make model year and automobile fuel |
      | Ford | F150 FFV | 2012 | E    | 5.0 | from make model year and automobile fuel |

  Scenario Outline: Fuel efficiency city committee from invalid fuel
    Given a characteristic "make.name" of "<make>"
    And a characteristic "model.name" of "<model>"
    And a characteristic "year.year" of "<year>"
    And a characteristic "automobile_fuel.code" of "<fuel>"
    When the "make_model" committee reports
    When the "make_model_year" committee reports
    And the "fuel_efficiency_city" committee reports
    Then the conclusion of the committee should be nil
    Examples:
      | make | model    | year | fuel |
      | Ford | F150 FFV |      | D    |
      | Ford | F150 FFV | 2012 | D    |

  Scenario Outline: Fuel efficiency committee
    Given a characteristic "fuel_efficiency_city" of "<fe_c>"
    And a characteristic "fuel_efficiency_highway" of "<fe_h>"
    And a characteristic "size_class.name" of "<size_class>"
    And a characteristic "urbanity" of "<urb>"
    And a characteristic "make.name" of "<make>"
    And a characteristic "year.year" of "<year>"
    And a characteristic "country.iso_3166_code" of "<country>"
    And a characteristic "hybridity_multiplier" of "<hyb_mult>"
    When the "make_year" committee reports
    And the "fuel_efficiency" committee reports
    Then the committee should have used quorum "<quorum>"
    And the conclusion of the committee should be "<fe>"
    And the conclusion should comply with standards "<standards>"
    Examples:
      | fe_c | fe_h | size_class  | urb | make   | year | country | hyb_mult | fe       | quorum                                                           | standards                                       |
      |  4.0 |  6.0 |             | 0.4 |        |      |         | 1.0      |      5.0 | from fuel efficiency city, fuel efficiency highway, and urbanity | ghg_protocol_scope_1, ghg_protocol_scope_3, iso |
      |      |      | Midsize Car | 0.4 |        |      |         | 2.0      |     20.0 | from size class, hybridity multiplier, and urbanity              | ghg_protocol_scope_3, iso                       |
      |      |      |             |     | Toyota | 2003 |         | 2.0      |     24.0 | from make year and hybridity multiplier                          | ghg_protocol_scope_3, iso                       |
      |      |      |             |     | Toyota |      |         | 2.0      |     25.0 | from make and hybridity multiplier                               | ghg_protocol_scope_3, iso                       |
      |      |      |             |     |        |      | US      | 2.0      |     20.0 | from country and hybridity multiplier                            | ghg_protocol_scope_3, iso                       |
      |      |      |             |     |        |      | GB      | 2.0      | 16.45306 | from hybridity multiplier                                        | ghg_protocol_scope_3, iso                       |

  Scenario Outline: Speed committee
    Given a characteristic "country.iso_3166_code" of "<country>"
    When the "urbanity" committee reports
    And the "speed" committee reports
    Then the committee should have used quorum "<quorum>"
    And the conclusion of the committee should be "<speed>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | country | speed | quorum                    |
      |         |  48.0 | from urbanity             |
      | GB      |  48.0 | from urbanity             |
      | US      |  48.0 | from urbanity and country |

  Scenario Outline: Automobile type committee
    Given a characteristic "make.name" of "<make>"
    And a characteristic "model.name" of "<model>"
    And a characteristic "year.year" of "<year>"
    And a characteristic "size_class.name" of "<size_class>"
    When the "make_model" committee reports
    And the "make_model_year" committee reports
    And the "automobile_type" committee reports
    Then the committee should have used quorum "<quorum>"
    And the conclusion of the committee should be "<type>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | make   | model    | year | size_class  | type              | quorum               |
      |        |          |      | Midsize Car | Passenger cars    | from size class      |
      | Ford   | F150 FFV |      |             | Light-duty trucks | from make model      |
      | Toyota | Prius    | 2003 |             | Passenger cars    | from make model year |

  Scenario Outline: Type fuel committee
    Given a characteristic "automobile_type" of "<type>"
    And a characteristic "automobile_fuel.code" of "<fuel>"
    When the "type_fuel" committee reports
    Then the committee should have used quorum "from automobile type and automobile fuel"
    And the conclusion of the committee should have "name" of "<type_fuel>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | type              | fuel | type_fuel                |
      | Passenger cars    | R    | Passenger cars gasoline  |
      | Light-duty trucks | D    | Light-duty trucks diesel |

  Scenario Outline: Type fuel year committee
    Given a characteristic "automobile_type" of "<type>"
    And a characteristic "automobile_fuel.code" of "<fuel>"
    And a characteristic "year.year" of "<year>"
    When the "type_fuel_year" committee reports
    Then the committee should have used quorum "from automobile type, automobile fuel, and year"
    And the conclusion of the committee should have "name" of "<type_fuel_year>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | type              | fuel | year | type_fuel_year                |
      | Passenger cars    | R    | 2003 | Passenger cars gasoline 2003  |
      | Light-duty trucks | D    | 2012 | Light-duty trucks diesel 2009 |

  Scenario Outline: Annual distance committee
    Given a characteristic "automobile_fuel.code" of "<code>"
    And a characteristic "automobile_type" of "<type>"
    And a characteristic "year.year" of "<year>"
    And a characteristic "daily_duration" of "<daily_dur>"
    And a characteristic "speed" of "<speed>"
    And a characteristic "daily_distance" of "<d_dist>"
    And a characteristic "weekly_distance" of "<w_dist>"
    And a characteristic "annual_fuel_use" of "<fuel>"
    And a characteristic "fuel_efficiency" of "<fe>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "type_fuel" committee reports
    And the "type_fuel_year" committee reports
    And the "annual_distance" committee reports
    Then the committee should have used quorum "<quorum>"
    And the conclusion of the committee should be "<dist>"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | code | type           | year | daily_dur | speed | d_dist | w_dist | fuel | fe | timeframe             | dist        | quorum                                    |
      | G    |                |      |           |       |        |        |      |    |                       | 18000.0     | from automobile fuel                      |
      | R    |                |      |           |       |        |        |      |    |                       | 18000.0     | from automobile fuel                      |
      | G    | Passenger cars |      |           |       |        |        |      |    |                       | 16500.0     | from type fuel                            |
      | G    | Passenger cars | 2003 |           |       |        |        |      |    |                       | 17500.0     | from type fuel year                       |
      | G    | Passenger cars | 2003 | 3600.0    | 10.0  |        |        |      |    | 2010-01-01/2010-02-01 | 3650.0      | from daily duration, speed, and timeframe |
      | G    | Passenger cars | 2003 | 3600.0    | 10.0  | 10.0   |        |      |    | 2010-01-01/2010-02-01 | 3650.0      | from daily distance and timeframe         |
      | G    | Passenger cars | 2003 | 3600.0    | 10.0  | 10.0   | 70.0   |      |    | 2010-01-01/2010-02-01 | 3650.0      | from weekly distance and timeframe        |
      | G    | Passenger cars | 2003 | 3600.0    | 10.0  | 10.0   | 70.0   | 10.0 | 10 | 2010-01-01/2010-02-01 |  100.0      | from annual fuel use and fuel efficiency  |

  Scenario Outline: Distance committee
    Given a characteristic "annual_distance" of "10000"
    And a characteristic "active_subtimeframe" of "<active_subtimeframe>"
    And a characteristic "timeframe" of "2010-01-01/2011-01-01"
    When the "distance" committee reports
    Then the committee should have used quorum "from annual distance and active subtimeframe"
    And the conclusion of the committee should be "<distance>"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | active_subtimeframe   | distance  | notes |
      | 2010-01-01/2011-01-01 | 10000.0   | active same as timeframe -> 100% |
      | 2010-01-01/2010-02-01 | 849.31507 | active within timeframe -> portion of timeframe |
      | 2010-01-01/2010-01-01 |     0.0   | active 0 days -> 0% |

  Scenario Outline: Annual fuel use committee
    Given a characteristic "annual_distance" of "10000"
    And a characteristic "fuel_efficiency" of "10"
    And a characteristic "automobile_fuel.code" of "<fuel>"
    When the "annual_fuel_use" committee reports
    Then the committee should have used quorum "from fuel efficiency, annual distance, and automobile fuel"
    And the conclusion of the committee should be "<fuel_use>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | fuel | fuel_use   |
      | G    | 1000.0     |
      | D    | 1000.0     |
      | C    |  921.05263 |
      | EL   | 9722.22222 |

  Scenario Outline: Fuel use committee
    Given a characteristic "annual_fuel_use" of "10000"
    And a characteristic "active_subtimeframe" of "<active_subtimeframe>"
    And a characteristic "timeframe" of "2010-01-01/2011-01-01"
    When the "fuel_use" committee reports
    Then the committee should have used quorum "from annual fuel use and active subtimeframe"
    And the conclusion of the committee should be "<fuel_use>"
    And the conclusion should comply with standards "ghg_protocol_scope_3, iso"
    Examples:
      | active_subtimeframe   | fuel_use  | notes |
      | 2010-01-01/2011-01-01 | 10000.0   | active same as timeframe -> 100% |
      | 2010-01-01/2010-02-01 | 849.31507 | active within timeframe -> portion of timeframe |
      | 2010-01-01/2010-01-01 |     0.0   | active 0 days -> 0% |

  Scenario Outline: Energy use committee
    Given a characteristic "fuel_use" of "1"
    And a characteristic "automobile_fuel.code" of "<fuel>"
    When the "energy" committee reports
    Then the committee should have used quorum "from fuel use and automobile fuel"
    And the conclusion should comply with standards ""
    And the conclusion of the committee should be "<energy>"
    Examples:
      | fuel   | energy   |
      | G      | 35.0     |
      | D      | 38.5     |
      | BP-B20 | 38.0     |
      | C      | 38.0     |
      | EL     |  3.6     |

  Scenario Outline: Activity year committee
    Given a characteristic "active_subtimeframe" of "<active_subtimeframe>"
    When the "activity_year" committee reports
    Then the committee should have used quorum "from active subtimeframe"
    And the conclusion of the committee should have "activity_year" of "<year>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | active_subtimeframe   | year |
      | 2008-06-01/2008-08-01 | 2008 |
      | 2009-06-01/2009-08-01 | 2009 |
      | 2010-06-01/2010-08-01 | 2009 |

  Scenario Outline: Activity year type committee
  Given a characteristic "active_subtimeframe" of "<active_subtimeframe>"
    And a characteristic "automobile_type" of "<type>"
    When the "activity_year_type" committee reports
    Then the committee should have used quorum "from active subtimeframe and automobile type"
    And the conclusion of the committee should have "name" of "<activity_year>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | active_subtimeframe   | type              | activity_year          |
      | 2008-06-01/2008-08-01 | Passenger cars    | 2008 Passenger cars    |
      | 2009-06-01/2009-08-01 | Light-duty trucks | 2009 Light-duty trucks |
      | 2010-06-01/2010-08-01 | Passenger cars    | 2009 Passenger cars    |

  Scenario Outline: HFC emission factor committee
    Given a characteristic "active_subtimeframe" of "<active_subtimeframe>"
    And a characteristic "automobile_type" of "<type>"
    When the "activity_year" committee reports
    And the "activity_year_type" committee reports
    And the "hfc_emission_factor" committee reports
    Then the committee should have used quorum "<quorum>"
    And the conclusion of the committee should be "<ef>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | active_subtimeframe   | type              | ef    | quorum                  |
      | 2008-01-01/2009-01-01 |                   | 0.012 | from activity year      |
      | 2010-01-01/2011-01-01 |                   | 0.01  | from activity year      |
      | 2009-01-01/2010-01-01 | Light-duty trucks | 0.015 | from activity year type |
      | 2010-01-01/2011-01-01 | Passenger cars    | 0.007 | from activity year type |

  Scenario Outline: N2O emission factor committee
    Given a characteristic "automobile_type" of "<type>"
    And a characteristic "automobile_fuel.code" of "<fuel>"
    And a characteristic "year.year" of "<year>"
    When the "type_fuel" committee reports
    And the "type_fuel_year" committee reports
    And the "n2o_emission_factor" committee reports
    Then the committee should have used quorum "<quorum>"
    And the conclusion of the committee should be "<ef>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | type              | fuel | year | ef     | quorum               |
      |                   | R    | 2003 | 0.006  | from automobile fuel |
      |                   | D    | 2012 | 0.0003 | from automobile fuel |
      | Passenger cars    | R    |      | 0.005  | from type fuel       |
      | Light-duty trucks | D    |      | 0.0003 | from type fuel       |
      | Passenger cars    | R    | 2003 | 0.0025 | from type fuel year  |
      | Light-duty trucks | D    | 2012 | 0.0003 | from type fuel year  |

  Scenario Outline: CH4 emission factor committee
    Given a characteristic "automobile_type" of "<type>"
    And a characteristic "automobile_fuel.code" of "<fuel>"
    And a characteristic "year.year" of "<year>"
    When the "type_fuel" committee reports
    And the "type_fuel_year" committee reports
    And the "ch4_emission_factor" committee reports
    Then the committee should have used quorum "<quorum>"
    And the conclusion of the committee should be "<ef>"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
    Examples:
      | type              | fuel | year | ef       | quorum               |
      |                   | R    | 2003 | 0.0004   | from automobile fuel |
      |                   | D    | 2012 | 0.00001  | from automobile fuel |
      | Passenger cars    | R    |      | 0.0004   | from type fuel       |
      | Light-duty trucks | D    |      | 0.000015 | from type fuel       |
      | Passenger cars    | R    | 2003 | 0.0002   | from type fuel year  |
      | Light-duty trucks | D    | 2012 | 0.000008 | from type fuel year  |

  Scenario Outline: CO2 biogenic emission factor committee
    Given a characteristic "automobile_fuel.code" of "<fuel>"
    When the "co2_biogenic_emission_factor" committee reports
    Then the committee should have used quorum "<quorum>"
    And the conclusion of the committee should be "<ef>"
    And the conclusion should comply with standards "<standards>"
    Examples:
      | fuel | ef  | quorum               | standards                                       |
      |      | 0.0 | default              | ghg_protocol_scope_3, iso                       |
      | EL   | 0.0 | default              | ghg_protocol_scope_3, iso                       |
      | R    | 0.0 | from automobile fuel | ghg_protocol_scope_1, ghg_protocol_scope_3, iso |
      | E    | 1.3 | from automobile fuel | ghg_protocol_scope_1, ghg_protocol_scope_3, iso |

  Scenario Outline: CO2 emission factor committee
    Given a characteristic "automobile_fuel.code" of "<fuel>"
    And a characteristic "country.iso_3166_code" of "<country>"
    When the "co2_emission_factor" committee reports
    Then the committee should have used quorum "<quorum>"
    And the conclusion of the committee should be "<ef>"
    And the conclusion should comply with standards "<standards>"
    Examples:
      | fuel | country | ef       | quorum               | standards                                       |
      |      |         | 0.626089 | default              | ghg_protocol_scope_3, iso                       |
      |      | US      | 0.59     | from country         | ghg_protocol_scope_3, iso                       |
      | EL   | GB      | 0.51     | from country         | ghg_protocol_scope_3, iso                       |
      | R    |         | 2.3      | from automobile fuel | ghg_protocol_scope_1, ghg_protocol_scope_3, iso |
      | E    | US      | 0.4      | from automobile fuel | ghg_protocol_scope_1, ghg_protocol_scope_3, iso |

  Scenario: HFC emission committee
    Given a characteristic "distance" of "10.0"
    And a characteristic "hfc_emission_factor" of "0.1"
    When the "hfc_emission" committee reports
    Then the committee should have used quorum "from distance and hfc emission factor"
    And the conclusion of the committee should be "1.0"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"

  Scenario: N2O emission committee
    Given a characteristic "distance" of "10.0"
    And a characteristic "n2o_emission_factor" of "0.1"
    When the "n2o_emission" committee reports
    Then the committee should have used quorum "from distance and n2o emission factor"
    And the conclusion of the committee should be "1.0"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"

  Scenario: CH4 emission committee
    Given a characteristic "distance" of "10.0"
    And a characteristic "ch4_emission_factor" of "0.1"
    When the "ch4_emission" committee reports
    Then the committee should have used quorum "from distance and ch4 emission factor"
    And the conclusion of the committee should be "1.0"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"

  Scenario: CO2 biogenic emission committee
    Given a characteristic "fuel_use" of "10.0"
    And a characteristic "co2_biogenic_emission_factor" of "1.0"
    When the "co2_biogenic_emission" committee reports
    Then the committee should have used quorum "from fuel use and co2 biogenic emission factor"
    And the conclusion of the committee should be "10.0"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"

  Scenario: CO2 emission committee
    Given a characteristic "fuel_use" of "10.0"
    And a characteristic "co2_emission_factor" of "1.0"
    When the "co2_emission" committee reports
    Then the committee should have used quorum "from fuel use and co2 emission factor"
    And the conclusion of the committee should be "10.0"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"

  Scenario: Carbon impact from co2 emisison, ch4 emission, n2o emission, and hfc emission
    Given a characteristic "co2_emission" of "10.0"
    And a characteristic "ch4_emission" of "0.1"
    And a characteristic "n2o_emission" of "0.1"
    And a characteristic "hfc_emission" of "1.0"
    When the "carbon" committee reports
    Then the committee should have used quorum "from co2 emission, ch4 emission, n2o emission, and hfc emission"
    And the conclusion of the committee should be "11.2"
    And the conclusion should comply with standards "ghg_protocol_scope_1, ghg_protocol_scope_3, iso"
