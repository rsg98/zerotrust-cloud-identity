Feature: Level 1

  Scenario: Level 1
    Given I login
    When I visit <provider> console
    Then I see "unknown user" in the <provider> console

    Examples:
      | provider  |
      | googlecloud |