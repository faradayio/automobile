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

  Scenario: Acquisition committee from model year
    Given an automobile emitter
    And a characteristic "model_year.name" of "Honda FIT 2008"
    When the "acquisition" committee is calculated
    Then the committee should have used quorum "from model year"
    And the conclusion of the committee should be "2008-01-01"

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
      | 2010-04-21  | 2010-09-01 | 2010-05-01/2010-08-31 | 2010-05-01/2010-08-31 |
      | 2010-04-21  | 2010-09-01 | 2010-05-01/2010-12-31 | 2010-05-01/2010-09-01 |
      | 2010-04-21  | 2010-09-01 | 2010-01-01/2010-08-31 | 2010-04-21/2010-08-31 |
      | 2010-04-21  | 2010-09-01 | 2010-01-01/2010-01-31 | 2010-01-01/2010-01-01 |

  Scenario: Fuel type committee from variant
    Given an automobile emitter
    And a characteristic "variant.row_hash" of "xxx1"
    When the "fuel_type" committee is calculated
    Then the committee should have used quorum "from variant"
    And the conclusion of the committee should have "name" of "regular gasoline"

  Scenario: Urbanity committee from default
    Given an automobile emitter
    When the "urbanity" committee is calculated
    Then the conclusion of the committee should be "0.43"

  Scenario: Speed committee from urbanity
    Given an automobile emitter
    When the "urbanity" committee is calculated
    And the "speed" committee is calculated
    Then the conclusion of the committee should be "50.94388"

