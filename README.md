# xpage

## Synopsis

A simple limited page object implementation.  

## Code Example

```ruby
require 'selenium-webdriver'
require 'xpage'

@driver = Selenium::WebDriver.for :chrome
@driver.navigate.to 'http://www.google.com'

Xpage.set_driver(@driver)

class GooglePage < Xpage
  def initialize
    @query = '//input[@name="q"]'
    @search = '//button[@value="Search"]'
  end

  def displayed?
    xpath_displayed?(@query) 
  end

  def set_query(text)
    set_xpath(@query, text)
  end
  
  def click_search()
    click_xpath(@search)
  end  
end

google_page=GooglePage.new
google_page.displayed?
google_page.set_query("test")
google_page.click_search()

```

## Motivation

To have a simple limited set of helper methods to use Selenium 

## Installation

This is dependent on Selenium and a Selenium driver set up.

## Contributors

Feedback and contributions are very welcome.

## License

MIT
