Feature: Absorb files
  In order to make permanent backups of my files across computers
  As a computer user
  I want to "absorb" the files into a S3 backup

  Scenario: Absorb a single file
    Given I have a file
    When I absorb the file
    Then the file should be uploaded to S3 in a unique folder
    And a record of the upload should be made in DynamoDB
    And details of the file upload should be made

  Scenario: Absorb two files
    Given I have two files
    When I absorb the files
    Then the files should be uploaded to S3 in a unique folder
    And a record of the upload should be made in DynamoDB
    And details of the file uploads should be made
