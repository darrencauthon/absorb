Feature: Absorb files
  In order to make permanent backups of my files across computers
  As a computer user
  I want to "absorb" the files into a S3 backup

  Scenario: Absorb a single file
    Given I have a file
    When I absorb the file
    Then the file should be uploaded to S3 
