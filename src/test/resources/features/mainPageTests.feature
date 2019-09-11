@apicuritoTests
@ui
@mainPageTests
Feature: Main page tests

  Background:
    Given delete API "tmp/download/openapi-spec.json"
    And log into apicurito

  @changeAPIname
  Scenario: change API name
    When create a new API
    And change API name to "MyApi"
    And save API as "json" and close editor
    And import API "tmp/download/openapi-spec.json"
    Then check that API name is "MyApi"

  @setAPIversion
  Scenario: set API version
    When create a new API
    And set API version to "2.20a"
    And save API as "json" and close editor
    And import API "tmp/download/openapi-spec.json"
    Then check that API version is "2.20a"

  @setAPIdescription
  Scenario: set API description
    When create a new API
    And change description to "New API desc"
    And save API as "json" and close editor
    And import API "tmp/download/openapi-spec.json"
    Then check that API description is "New API desc"

  @setAPIconsumes
  Scenario: set API consumes
    When create a new API
    And set consumes to "text/xml"
    And save API as "json" and close editor
    And import API "tmp/download/openapi-spec.json"
    Then check that API consume "text/xmlapplication/json"
    #TODO add space and check every label separately

  @setAPIproduces
  Scenario: set API produces
    When create a new API
    And set produces to "text/xml"
    And save API as "json" and close editor
    And import API "tmp/download/openapi-spec.json"
    Then check that API produce "text/xmlapplication/json"
    #TODO add space and check every label separately

  @setAPIcontact
  Scenario: set API contact
    When create a new API
    And add contact info
      | Ignite test | a@a.com | https://github.com/Apicurio/ |

    And save API as "json" and close editor
    And import API "tmp/download/openapi-spec.json"
    Then check that API contact info is
      | Ignite test | a@a.com | https://github.com/Apicurio/ |

  @setAPIlicense
  Scenario: set API license
    When create a new API
    And add license "MIT License"
    And save API as "json" and close editor
    And import API "tmp/download/openapi-spec.json"
    Then check that API license is "MIT License"

  @setAPItag
  Scenario: set API tag
    When create a new API
    And add tag "MyTag" with description "My desc"
    And save API as "json" and close editor
    And import API "tmp/download/openapi-spec.json"
    Then check that API have tag "MyTag" with description "My desc"

  @createAPIsecurityBasic
  Scenario: create basic security scheme for API
    When import API "src/test/resources/preparedAPIs/paramsAndSecurity.json"
    And create basic security scheme with values
      | basicScheme | Basic scheme description |

    And save API as "json" and close editor
    And import API "tmp/download/openapi-spec.json"
    Then check security scheme
      | basicScheme | basic | Basic scheme description |

  @createAPIsecurityAPIkey
  Scenario: create API Key security scheme for API
    When import API "src/test/resources/preparedAPIs/paramsAndSecurity.json"
    And create API Key security scheme with values
      | APIkeySecurityName | API Key description | HTTP header | ParameterName |

    And save API as "json" and close editor
    And import API "tmp/download/openapi-spec.json"
    Then check security scheme
      | APIkeySecurityName | apiKey | API Key description | HTTP header | ParameterName |

  @createAPIsecurityOauth2
  Scenario: create OAuth2 security scheme for API
    When import API "src/test/resources/preparedAPIs/paramsAndSecurity.json"
    And create OAuth security scheme with values
      | OAuth2name | OAuth2 description | Access Code | https://github.com/Apicurio/ | https://github.com/Apicurio/apicurito |

    And save API as "json" and close editor
    And import API "tmp/download/openapi-spec.json"
    Then check security scheme
      | OAuth2name | oauth2 | OAuth2 description | Access Code | https://github.com/Apicurio/ | https://github.com/Apicurio/apicurito |

  @createSecurityRequiremet
  Scenario: create security requirement
    When import API "src/test/resources/preparedAPIs/paramsAndSecurity.json"
    And create security requirement with schemes
      | api   |
      | basic |

    And save API as "json" and close editor
    And import API "tmp/download/openapi-spec.json"

    Then check that API security requirement "api, basic" exists

  @mainPage
  Scenario: Test the api main page (set everything except security)
    When create a new API
    And change API name to "MyApi"
    And set API version to "2.20a"
    And change description to "New API desc"
    And set consumes to "text/xml"
    And set produces to "text/xml"
    And add contact info
      | Ignite test | a@a.com | https://github.com/Apicurio/ |

    And add license "MIT License"
    And add tag "MyTag" with description "My desc"

    Then save API as "json" and close editor
    When import API "tmp/download/openapi-spec.json"

    And check that API name is "MyApi"
    And check that API version is "2.20a"
    And check that API description is "New API desc"
    And check that API consume "text/xmlapplication/json"
    #TODO add space and check every label separately
    And check that API produce "text/xmlapplication/json"
    And check that API contact info is
      | Ignite test | a@a.com | https://github.com/Apicurio/ |

    And check that API license is "MIT License"
    And check that API have tag "MyTag" with description "My desc"

  @search
  Scenario: test search on paths and datatypes
    When create a new API
    And create a new path with link
      | Mypaths1  | false |
      | Mypaths2  | false |
      | Mypathsx  | false |
      | Mypaths24 | false |
      | DataType1 | false |

    And create a new data type by link
      | DataType1  | desc |  | false | false |
      | DataType2  | desc |  | false | false |
      | DataTypex  | desc |  | false | false |
      | DataType24 | desc |  | false | false |

    And search path or data type with substring "x"
    Then check that path "/Mypathsx" is created
    And check that data type "DataTypex" is created

    When search path or data type with substring "2"
    Then check that path "/Mypaths2" is created
    And check that path "/Mypaths24" is created
    And check that data type "DataType2" is created
    And check that data type "DataType24" is created

    When search path or data type with substring "ATH"
    Then check that path "/Mypaths1" is created
    And check that path "/Mypaths2" is created
    And check that path "/Mypathsx" is created
    And check that path "/Mypaths24" is created

  @plurals
  Scenario: test for creating paths in plural forms
    #TODO change to the right path names after closing:
    #https://issues.jboss.org/browse/ENTESB-11594
    When create a new API
    And create a new data type by link
      | beer   |  |  | true | false |
      | BANANA |  |  | true | false |
      | data2  |  |  | true | false |
      | mouse  |  |  | true | false |
      | man    |  |  | true | false |
      | abc    |  |  | true | false |

    Then check that path "/beers" is created
    And check that path "/bANANAS" is created
    And check that path "/data2S" is created
    And check that path "/mice" is created
    And check that path "/men" is created
    And check that path "/abcs" is created

  Scenario: #kebab menu for paths and data types

  #TODO after closing:
  # https://github.com/Apicurio/apicurio-studio/issues/656
  # https://github.com/Apicurio/apicurio-studio/issues/657
  #  And add scopes to scheme "OAuth2name"
  #  And add scopes to security requirement "OAuth2name, APIkeySecurityName" and OAuth scheme "OAuth2name"
