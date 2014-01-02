Feature: Absorb files
  In order to make permanent backups of my files across computers
  As a computer user
  I want to "absorb" the files into a S3 backup

  Scenario: Amazon, upload and then restore
    Given I am using Amazon services
    And I have a file
    When I absorb the file
    And I restore the file to a directory
    Then the file should be restored to the directory
