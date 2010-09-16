Feature: Automobile Committee Calculations
  The automobile model should generate correct committee calculations

  Scenario Outline: Retirement committee from acquisition
    Given an automobile emitter
    And a characteristic "timeframe" of "<timeframe>"
    And a characteristic "acquisition" of "<acquisition>"
    When the "retirement" committee is calculated
    Then the conclusion of the committee should be "<retirement_committee>"
    Examples:
      | timeframe             | acquisition | retirement_committee |
      | 2009-03-04/2009-08-17 | 2010-04-21  | 2010-04-21           |
      | 2009-03-04/2009-08-17 | 2007-01-30  | 2009-08-17           |
      | 2009-03-04/2009-08-17 |             | 2009-08-17           |

  Scenario Outline: Acquisition committee from model year or year
    Given an automobile emitter
    And a characteristic "model_year.name" of "<make_model_year>"
    And a characteristic "year" of "<year>"
    When the "acquisition" committee is calculated
    Then the conclusion of the committee should be "<acquisition_committee>"
    Examples:
      | make_model_year | year | acquisition_committee |
      |                 | 2007 | 2007-01-01            |
      | Honda FIT 2008  |      | 2008-01-01            |

  Scenario Outline: Acquisition committee from retirement
    Given an automobile emitter
    And a characteristic "timeframe" of "<timeframe>"
    And a characteristic "retirement" of "<retirement>"
    When the "acquisition" committee is calculated
    Then the conclusion of the committee should be "<acquisition_committee>"
    Examples:
      | timeframe             | retirement | acquisition_committee |
      | 2010-08-10/2010-09-16 | 2007-02-03 | 2007-02-03            |
      | 2010-08-10/2010-09-16 |            | 2010-08-10            |
