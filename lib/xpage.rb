require 'selenium-webdriver'

class Xpage
  def self.set_driver(driver)
    @@driver = driver
  end

  @@wait = Selenium::WebDriver::Wait.new(:timeout => 20, :interval => 1)

  def get_element(xpath)
    element = nil

    begin
      element = @@driver.find_element(:xpath, xpath)
    rescue
      element = nil
    end

    element
  end

  def click_xpath(xpath)
    wait_for_xpath_to_display xpath

    @@wait.until {
      element = get_element xpath
      element.click
      true
    }
  end

  def clear_xpath(xpath)
    wait_for_xpath_to_display xpath

    @@wait.until {
      element = get_element xpath
      element.clear
      true
    }
  end

  def get_xpath_text(xpath)
    wait_for_xpath_to_exist xpath

    result = nil
    @@wait.until {
      element = get_element xpath
      result = element.text
      true
    }
    result
  end

  def move_to_xpath(xpath)
    wait_for_xpath_to_display xpath

    @@wait.until {
      element = get_element xpath
      @@driver.mouse.move_to element
      true
    }
  end

  def select_xpath(xpath, option)
    wait_for_xpath_to_display xpath

    @@wait.until {
      element = get_element xpath
      Selenium::WebDriver::Support::Select.new(element).select_by(:text, option)
      true
    }
  end

  def send_keys_xpath(xpath, text)
    wait_for_xpath_to_display xpath

    @@wait.until {
      element = get_element xpath
      element.send_keys text
      true
    }
  end

  def set_xpath(xpath, text)
    clear_xpath xpath
    send_keys_xpath xpath, text
  end

  def switch_iframe(xpath)
    wait_for_xpath_to_display xpath

    @@wait.until {
      element = get_element xpath
      @@driver.switch_to.frame(element)
      true
    }
  end

  def switch_to_parent_frame
    @@wait.until {
      @@driver.switch_to.window(@driver.window_handles.first)
      true
    }
  end

  def text_displayed?(text)
    elements = nil
    @@wait.until {
      elements = @@driver.find_elements(:xpath, "//*[contains(text(),'#{text}')]")
      true
    }

    elements.each do |element|
      if element.displayed? == true
        return true
      end
    end
    return false
  end

  def wait_for_xpath_to_be_enabled(xpath)
    @@wait.until { xpath_enabled? xpath }
  end

  def wait_for_xpath_to_display(xpath)
    @@wait.until { xpath_displayed? xpath }
  end

  def wait_for_xpath_to_exist(xpath)
    @@wait.until { xpath_exists? xpath }
  end

  def xpath_displayed?(xpath)
    result = false
    @@wait.until {
      element = get_element xpath
      if element.nil?
        result = false
      else
        result = element.displayed?
      end
      true
    }
    result
  end

  def xpath_enabled?(xpath)
    wait_for_xpath_to_exist xpath

    result = false
    @@wait.until {
      element = get_element xpath
      result = element.enabled?
      true
    }
    result
  end

  def xpath_exists?(xpath)
    element = get_element xpath
    if element.nil?
      return false
    end
    true
  end

  def xpath_selected?(xpath)
    wait_for_xpath_to_exist xpath
    result=false
    @@wait.until {
      element = get_element xpath
      result = element.selected?
      true
    }
    result
  end

end
