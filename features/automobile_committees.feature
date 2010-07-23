Feature: Automobile Committee Calculations
  The automobile model should generate correct committee calculations

  Scenario Outline: Acquisition committee
    Given an automobile has "acquisition" of "<acquisition>"
    And it has "model_year.name" "<make_model_year>"
    When emissions are calculated
    Then the acquisition committee should be exactly <acquisition_committee>
    Examples:
      | make_model_year | acquisition | acquisition_committee |
      |                 | 2007-01-30  | 2007-01-30            |
      | Honda FIT 2008  |             | 2010-01-01            |

  Scenario Outline: Retirement committees
    Given an automobile has "acquisition" of "<acquisition>"
    And it has "model_year.name" "<make_model_year>"
    When emissions are calculated
    Then the retirement committee should be exactly <retirement_committee>
    Examples:
      | acquisition | retirement | retirement_committee |
      | 2007-01-30  | 2009-03-04 | 2011-01-01           |
