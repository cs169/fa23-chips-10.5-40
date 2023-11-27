Feature: User authentication

  Scenario: Logging in with Google
    Given I am on the login page
    When I click on "Sign in with Google"
    Then I should be redirected to the home page
    And I should see my Google name on the page

  Scenario: Logging in with GitHub
    Given I am on the login page
    When I click on "Sign in with GitHub"
    Then I should be redirected to the home page
    And I should see my GitHub name on the page