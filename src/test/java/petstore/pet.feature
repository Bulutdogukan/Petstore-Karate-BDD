Feature: Pet Endpoint Tests
  Petstore API - Pet CRUD operations

  Background:
    * url baseUrl

  Scenario: Create a new pet via POST
    Given path '/pet'
    And request
      """
      {
        "id": 77701,
        "category": { "id": 1, "name": "Dogs" },
        "name": "Karate-Dog",
        "photoUrls": ["https://example.com/karate-dog.jpg"],
        "tags": [{ "id": 1, "name": "friendly" }],
        "status": "available"
      }
      """
    When method POST
    Then status 200
    And match response.name == 'Karate-Dog'
    And match response.status == 'available'
    And match response.id == 77701

  Scenario: Get pet by ID
    Given path '/pet/77701'
    When method GET
    Then status 200
    And match response.id == 77701
    And match response.name == 'Karate-Dog'

  Scenario: Find pets by status
    Given path '/pet/findByStatus'
    And param status = 'available'
    When method GET
    Then status 200
    And match response == '#[_ > 0]'
    And match each response contains { status: 'available' }

  Scenario: Update an existing pet via PUT
    Given path '/pet'
    And request
      """
      {
        "id": 77701,
        "category": { "id": 1, "name": "Dogs" },
        "name": "Karate-Dog-Updated",
        "photoUrls": ["https://example.com/karate-dog.jpg"],
        "tags": [{ "id": 1, "name": "trained" }],
        "status": "sold"
      }
      """
    When method PUT
    Then status 200
    And match response.name == 'Karate-Dog-Updated'
    And match response.status == 'sold'

  Scenario: Delete a pet
    Given path '/pet/77701'
    When method DELETE
    Then status 200

  Scenario: Verify deleted pet returns 404
    Given path '/pet/77701'
    When method GET
    Then status 404
