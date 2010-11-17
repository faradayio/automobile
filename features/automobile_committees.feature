Feature: Automobile Committee Calculations
  The automobile model should generate correct committee calculations

  Scenario: Retirement committee from default
    Given an automobile emitter
    And a characteristic "timeframe" of "2009-03-04/2009-08-17"
    When the "retirement" committee is calculated
    Then the conclusion of the committee should be "2009-08-17"

  Scenario Outline: Retirement committee from acquisition
    Given an automobile emitter
    And a characteristic "timeframe" of "<timeframe>"
    And a characteristic "acquisition" of "<acquisition>"
    When the "retirement" committee is calculated
    Then the conclusion of the committee should be "<retirement>"
    Examples:
      | timeframe             | acquisition | retirement |
      | 2009-03-04/2009-08-17 | 2010-04-21  | 2010-04-21 |
      | 2009-03-04/2009-08-17 | 2007-01-30  | 2009-08-17 |

  Scenario: Acquisition committee from make model year variant
    Given an automobile emitter
    And a characteristic "make_model_year_variant.row_hash" of "xxx1"
    When the "acquisition" committee is calculated
    Then the committee should have used quorum "from make model year variant"
    And the conclusion of the committee should be "2003-01-01"

  Scenario: Acquisition committee from make model year
    Given an automobile emitter
    And a characteristic "make_model_year.name" of "Acura RSX 2003"
    When the "acquisition" committee is calculated
    Then the committee should have used quorum "from make model year"
    And the conclusion of the committee should be "2003-01-01"

  Scenario: Acquisition committee from make year
    Given an automobile emitter
    And a characteristic "make_year.name" of "Acura 2003"
    When the "acquisition" committee is calculated
    Then the committee should have used quorum "from make year"
    And the conclusion of the committee should be "2003-01-01"

  Scenario Outline: Acquisition committee from retirement
    Given an automobile emitter
    And a characteristic "timeframe" of "<timeframe>"
    And a characteristic "retirement" of "<retirement>"
    When the "acquisition" committee is calculated
    Then the committee should have used quorum "from retirement"
    And the conclusion of the committee should be "<acquisition_committee>"
    Examples:
      | timeframe             | retirement | acquisition_committee |
      | 2010-08-10/2010-09-16 | 2007-02-03 | 2007-02-03            |
      | 2010-08-10/2010-09-16 | 2010-09-01 | 2010-08-10            |

  Scenario Outline: Active subtimeframe committee from acquisition and retirement
    Given an automobile emitter
    And a characteristic "acquisition" of "<acquisition>"
    And a characteristic "retirement" of "<retirement>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "active_subtimeframe" committee is calculated
    Then the conclusion of the committee should be timeframe "<active_subtimeframe>"
    Examples:
      | acquisition | retirement | timeframe             | active_subtimeframe   |
      | 2010-04-21  | 2010-09-01 | 2010-01-01/2010-12-31 | 2010-04-21/2010-09-01 |
      | 2010-04-21  | 2010-09-01 | 2010-05-01/2010-08-01 | 2010-05-01/2010-08-01 |
      | 2010-04-21  | 2010-09-01 | 2010-05-01/2010-12-31 | 2010-05-01/2010-09-01 |
      | 2010-04-21  | 2010-09-01 | 2010-01-01/2010-08-01 | 2010-04-21/2010-08-01 |
      | 2010-04-21  | 2010-09-01 | 2010-01-01/2010-01-31 | 2010-01-01/2010-01-01 |

  Scenario: Fuel type committee from make model year variant
    Given an automobile emitter
    And a characteristic "make_model_year_variant.row_hash" of "xxx1"
    When the "fuel_type" committee is calculated
    Then the committee should have used quorum "from make model year variant"
    And the conclusion of the committee should have "name" of "premium gasoline"

  Scenario: Urbanity committee from default
    Given an automobile emitter
    When the "urbanity" committee is calculated
    Then the conclusion of the committee should be "0.43"

  Scenario: Speed committee from urbanity
    Given an automobile emitter
    When the "urbanity" committee is calculated
    And the "speed" committee is calculated
    Then the conclusion of the committee should be "50.94388"

  Scenario Outline: Hybridity multiplier committee from size class with hybridity multipliers
    Given an automobile emitter
    And a characteristic "hybridity" of "<hybridity>"
    And a characteristic "size_class.name" of "<size_class>"
    When the "urbanity" committee is calculated
    And the "hybridity_multiplier" committee is calculated
    Then the committee should have used quorum "from size class, hybridity, and urbanity"
    And the conclusion of the committee should be "<multiplier>"
    Examples:
      | hybridity | size_class  | multiplier |
      | true      | Midsize Car | 1.68067    |
      | false     | Midsize Car | 0.87464    |

  Scenario Outline: Hybridity multiplier committee from size class missing hybridity multipliers
    Given an automobile emitter
    And a characteristic "hybridity" of "<hybridity>"
    And a characteristic "size_class.name" of "<size_class>"
    When the "urbanity" committee is calculated
    And the "hybridity_multiplier" committee is calculated
    Then the committee should have used quorum "from hybridity and urbanity"
    And the conclusion of the committee should be "<multiplier>"
    Examples:
      | hybridity | size_class    | multiplier |
      | true      | Midsize Wagon | 1.36919    |
      | false     | Midsize Wagon | 0.99211    |

  Scenario Outline: Hybridity multiplier committee from hybridity and urbanity
    Given an automobile emitter
    And a characteristic "hybridity" of "<hybridity>"
    When the "urbanity" committee is calculated
    And the "hybridity_multiplier" committee is calculated
    Then the committee should have used quorum "from hybridity and urbanity"
    And the conclusion of the committee should be "<multiplier>"
    Examples:
      | hybridity | multiplier |
      | true      | 1.36919    |
      | false     | 0.99211    |

  Scenario: Hybridity multiplier committee from default
    Given an automobile emitter
    When the "hybridity_multiplier" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "1.0"

  Scenario: Fuel efficiency committee from make model year variant and urbanity
    Given an automobile emitter
    And a characteristic "make_model_year_variant.row_hash" of "xxx1"
    When the "urbanity" committee is calculated
    And the "fuel_efficiency" committee is calculated
    Then the committee should have used quorum "from make model year variant and urbanity"
    And the conclusion of the committee should be "13.98601"

  Scenario: Fuel efficiency committee from make model year and urbanity
    Given an automobile emitter
    And a characteristic "make_model_year.name" of "Acura RSX 2003"
    When the "urbanity" committee is calculated
    And the "fuel_efficiency" committee is calculated
    Then the committee should have used quorum "from make model year and urbanity"
    And the conclusion of the committee should be "19.43005"

  Scenario: Fuel efficiency committee from make model and urbanity
    Given an automobile emitter
    And a characteristic "make_model.name" of "Acura RSX"
    When the "urbanity" committee is calculated
    And the "fuel_efficiency" committee is calculated
    Then the committee should have used quorum "from make model and urbanity"
    And the conclusion of the committee should be "6.99301"

  Scenario: Fuel efficiency committee from size class, hybridity multiplier, and urbanity
    Given an automobile emitter
    And a characteristic "size_class.name" of "Midsize Car"
    And a characteristic "hybridity_multiplier" of "2"
    When the "urbanity" committee is calculated
    And the "fuel_efficiency" committee is calculated
    Then the committee should have used quorum "from size class, hybridity multiplier, and urbanity"
    And the conclusion of the committee should be "27.97203"

  Scenario: Fuel efficiency committee from make year and hybridity multiplier
    Given an automobile emitter
    And a characteristic "make_year.name" of "Acura 2003"
    And a characteristic "hybridity_multiplier" of "2"
    When the "fuel_efficiency" committee is calculated
    Then the committee should have used quorum "from make year and hybridity multiplier"
    And the conclusion of the committee should be "30.0"

  Scenario: Fuel efficiency committee from make with fuel efficiency and hybridity multiplier
    Given an automobile emitter
    And a characteristic "make.name" of "Acura"
    And a characteristic "hybridity_multiplier" of "2"
    When the "fuel_efficiency" committee is calculated
    Then the committee should have used quorum "from make and hybridity multiplier"
    And the conclusion of the committee should be "20.0"

  Scenario: Fuel efficiency committee from make missing fuel efficiency and hybridity multiplier
    Given an automobile emitter
    And a characteristic "make.name" of "Honda"
    And a characteristic "hybridity_multiplier" of "2"
    When the "fuel_efficiency" committee is calculated
    Then the committee should have used quorum "from hybridity multiplier"
    And the conclusion of the committee should be "17.1605"

  Scenario: Fuel efficiency committee from hybridity multiplier
    Given an automobile emitter
    And a characteristic "hybridity_multiplier" of "1"
    When the "fuel_efficiency" committee is calculated
    Then the committee should have used quorum "from hybridity multiplier"
    And the conclusion of the committee should be "8.58025"

  Scenario: Annual distance committee from weekly distance and timeframe
    Given an automobile emitter
    And a characteristic "weekly_distance" of "7"
    And a characteristic "timeframe" of "2010-05-23/2010-11-24"
    When the "annual_distance" committee is calculated
    Then the committee should have used quorum "from weekly distance and timeframe"
    And the conclusion of the committee should be "365.0"

  Scenario: Annual distance committee from daily distance and timeframe
    Given an automobile emitter
    And a characteristic "daily_distance" of "2"
    And a characteristic "timeframe" of "2010-05-23/2010-11-24"
    When the "annual_distance" committee is calculated
    Then the committee should have used quorum "from daily distance and timeframe"
    And the conclusion of the committee should be "730.0"

  Scenario: Annual distance committee from daily duration, speed and timeframe
    Given an automobile emitter
    And a characteristic "daily_duration" of "2"
    And a characteristic "speed" of "5"
    And a characteristic "timeframe" of "2010-05-23/2010-11-24"
    When the "annual_distance" committee is calculated
    Then the committee should have used quorum "from daily duration, speed, and timeframe"
    And the conclusion of the committee should be "3650.0"

  Scenario: Annual distance committee from size class
    Given an automobile emitter
    And a characteristic "size_class.name" of "Midsize Car"
    When the "annual_distance" committee is calculated
    Then the committee should have used quorum "from size class"
    And the conclusion of the committee should be "10000.0"

  Scenario: Annual distance committee from fuel type
    Given an automobile emitter
    And a characteristic "fuel_type.code" of "P"
    When the "annual_distance" committee is calculated
    Then the committee should have used quorum "from fuel type"
    And the conclusion of the committee should be "18161.0"

  Scenario: Annual distance committee from default
    Given an automobile emitter
    When the "annual_distance" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "19020.83674"

  Scenario Outline: Distance committee from annual distance and active subtimeframe
    Given an automobile emitter
    And a characteristic "annual_distance" of "<annual_distance>"
    And a characteristic "active_subtimeframe" of "<active_subtimeframe>"
    And a characteristic "timeframe" of "<timeframe>"
    When the "distance" committee is calculated
    Then the conclusion of the committee should be "<distance>"
    Examples:
      | annual_distance | active_subtimeframe   | timeframe             | distance  |
      | 10000           | 2010-06-01/2010-07-07 | 2010-01-01/2010-12-31 | 986.30137 |
      | 10000           | 2010-06-01/2010-07-07 | 2010-06-01/2010-06-30 | 986.30137 |

  Scenario: Fuel consumed committee from fuel efficiency and distance
    Given an automobile emitter
    And a characteristic "distance" of "100"
    And a characteristic "fuel_efficiency" of "10"
    When the "fuel_consumed" committee is calculated
    Then the conclusion of the committee should be "10.0"

  Scenario: Emission factor committee from fuel type
    Given an automobile emitter
    And a characteristic "fuel_type.code" of "P"
    When the "emission_factor" committee is calculated
    Then the conclusion of the committee should be "2.48"

  Scenario: Emission factor committee from default
    Given an automobile emitter
    When the "emission_factor" committee is calculated
    Then the conclusion of the committee should be "2.49011"
