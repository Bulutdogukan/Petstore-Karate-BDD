Feature: Store Endpoint Tests
  Petstore API - Store inventory and order operations

  Background:
    * url baseUrl

  Scenario: Get store inventory
    Given path '/store/inventory'
    When method GET
    Then status 200
    And match response == '#object'

  Scenario: Place a new order
    Given path '/store/order'
    And request
      """
      {
        "id": 7770,
        "petId": 77701,
        "quantity": 1,
        "shipDate": "2026-03-08T00:00:00.000Z",
        "status": "placed",
        "complete": true
      }
      """
    When method POST
    Then status 200
    And match response.id == 7770
    And match response.status == 'placed'

  Scenario: Get order by ID
    Given path '/store/order/7770'
    When method GET
    Then status 200
    And match response.id == 7770

  Scenario: Delete order
    Given path '/store/order/7770'
    When method DELETE
    Then status 200
