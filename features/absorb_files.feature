Feature: Absorb files
  In order to make permanent backups of my files across computers
  As a computer user
  I want to "absorb" the files into a S3 backup

Scenario: Amazon, absorb a single file
    Given I am using Amazon services
    And I have a file
    When I absorb the file
    Then the file should be uploaded to S3 in a unique folder
    And a record of the package should be made in DynamoDB
    And details of the file upload should be made in DynamoDB

  Scenario: Amazon, absorb two files
    Given I am using Amazon services
    And I have two files
    When I absorb the files
    Then the files should be uploaded to S3 in a unique folder
    And a record of the package should be made in DynamoDB
    And details of the file uploads should be made in DynamoDB

  Scenario: Amazon, absorb two files of different depth
    Given I am using Amazon services
    And I have two files of different depth
    When I absorb the files
    Then the files should be uploaded to S3 in a unique folder
    And a record of the package should be made in DynamoDB
    And details of the file uploads should be made in DynamoDB

  Scenario: Amazon, absorb the same file twice
    Given I am using Amazon services
    And I have a file
    When I absorb the file
    And I absorb the file again
    Then the file should be saved twice but uploaded to s3 once

  Scenario: Amazon, upload and then restore
    Given I am using Amazon services
    And I have a file
    When I absorb the file
    And I restore the file to a directory
    Then the file should be restored to the directory
