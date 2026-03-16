Feature: User Endpoint Tests
  Petstore API - User CRUD and authentication operations

  Background:
    * url baseUrl

  Scenario: Create a new user
    Given path '/user'
    And request
      """
      {
        "id": 88801,
        "username": "karateTestUser",
        "firstName": "Karate",
        "lastName": "Tester",
        "email": "karate@test.com",
        "password": "Test1234",
        "phone": "5551234567",
        "userStatus": 1
      }
      """
    When method POST
    Then status 200

  Scenario: Login user
    Given path '/user/login'
    And param username = 'karateTestUser'
    And param password = 'Test1234'
    When method GET
    Then status 200

  Scenario: Get user by username
    Given path '/user/karateTestUser'
    When method GET
    Then status 200
    And match response.username == 'karateTestUser'
    And match response.firstName == 'Karate'

  Scenario: Update user
    Given path '/user/karateTestUser'
    And request
      """
      {
        "id": 88801,
        "username": "karateTestUser",
        "firstName": "KarateUpdated",
        "lastName": "TesterUpdated",
        "email": "karateUpdated@test.com",
        "password": "Test5678",
        "phone": "5559876543",
        "userStatus": 1
      }
      """
    When method PUT
    Then status 200

  Scenario: Delete user
    Given path '/user/karateTestUser'
    When method DELETE
    Then status 200

  Scenario: Logout user
    Given path '/user/logout'
    When method GET
    Then status 200
