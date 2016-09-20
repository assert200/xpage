class Xpage
  SELENIUM_CLIENT_DELAY_SECONDS = 0.01

  def get_element(xpath)
    element = nil

    sleep(SELENIUM_CLIENT_DELAY_SECONDS)
    begin
      element = $driver.find_element(:xpath, xpath)
    rescue
      element = nil
    end
    sleep(SELENIUM_CLIENT_DELAY_SECONDS)

    element
  end

  def click_xpath(xpath)
    wait_for_xpath_to_display xpath

    sleep(SELENIUM_CLIENT_DELAY_SECONDS)

    retryer.until(description: 'click_xpath') {
      element = get_element xpath
      element.click
    }
  end

  def clear_xpath(xpath)
    wait_for_xpath_to_display xpath

    retryer.until(description: 'clear_xpath') {
      element = get_element xpath
      element.clear
    }
  end

  def get_xpath_text(xpath)
    wait_for_xpath_to_exist xpath

    retryer.until(description: 'get_xpath_text') {
      element = get_element xpath
      element.text
    }
  end

  def move_to_xpath(xpath)
    wait_for_xpath_to_display xpath

    retryer.until(description: 'select_xpath') {
      element = get_element xpath
      $driver.mouse.move_to element
    }
  end

  def select_xpath(xpath, option)
    wait_for_xpath_to_display xpath

    retryer.until(description: 'select_xpath') {
      element = get_element xpath
      Selenium::WebDriver::Support::Select.new(element).select_by(:text, option)
    }
  end

  def send_keys_xpath(xpath, text)
    wait_for_xpath_to_display xpath

    retryer.until(description: 'send_keys_xpath') {
      element = get_element xpath
      element.send_keys text
    }
  end

  def set_xpath(xpath, text)
    clear_xpath xpath
    send_keys_xpath xpath, text
  end

  def switch_iframe(xpath)
    wait_for_xpath_to_display xpath

    retryer.until(description: 'switch_iframe') {
      element = get_element xpath
      $driver.switch_to.frame(element)
    }
  end

  def switch_to_parent_frame
    retryer.until(description: 'switch_to_parent_frame') {
      $driver.switch_to.window($driver.window_handles.first)
    }
  end

  def text_displayed?(text)
    elements = nil
    retryer.until(description: 'text_displayed?') {
      elements = $driver.find_elements(:xpath, "//*[contains(text(),'#{text}')]")
    }

    elements.each do |element|
      if element.displayed? == true
        return true
      end
    end
    return false
  end

  def wait_for_xpath_to_be_enabled(xpath)
    wait.until { xpath_enabled? xpath }
  end

  def wait_for_xpath_to_display(xpath)
    wait.until { xpath_displayed? xpath }
  end

  def wait_for_xpath_to_exist(xpath)
    wait.until { xpath_exists? xpath }
  end

  def xpath_displayed?(xpath)
    result = false
    retryer.until(description: 'xpath_displayed?') {
      element = get_element xpath
      if element.nil?
        result = false
      else
        result = element.displayed?
      end
    }
    result
  end

  def xpath_enabled?(xpath)
    wait_for_xpath_to_exist xpath

    result = false
    retryer.until(description: 'xpath_enabled?') {
      element = get_element xpath
      result = element.enabled?
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

    retryer.until(description: 'xpath_selected?') {
      element = get_element xpath
      element.selected?
    }
  end
end
