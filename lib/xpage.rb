require 'retryer'

class Xpage
  def self.set_driver(driver)
    @@driver = driver
  end

  @@wait = Retryer::Wait.new(:timeout => 20, :interval => 1, :verbose => false)
  @@retryer = Retryer::Retry.new(max_retries: 5, interval: 1, :verbose => true)

  def get_element(xpath)
    @@retryer.do(description: 'get_element') {
      begin
        @@driver.find_element(:xpath, xpath)
      rescue Selenium::WebDriver::Error::NoSuchElementError
        nil # element doesn't exist
      end
    }
  end

  def click_xpath(xpath)
    wait_for_xpath_to_display xpath

    @@retryer.do(description: 'click_xpath') {
      element = get_element xpath
      element.click
    }
  end
  
  def get_xpath_attribute(xpath, attribute)
    wait_for_xpath_to_exist xpath

    @@retryer.do(description: 'get_xpath_attribute') {
      element = get_element xpath
      element.attribute(attribute)
    }
  end

  def clear_xpath(xpath)
    wait_for_xpath_to_display xpath

    @@retryer.do(description: 'clear_xpath') {
      element = get_element xpath
      element.clear
    }
  end

  def get_xpath_text(xpath)
    wait_for_xpath_to_exist xpath

    @@retryer.do(description: 'get_xpath_text') {
      element = get_element xpath
      element.text
    }
  end

  def move_to_xpath(xpath)
    wait_for_xpath_to_display xpath

    @@retryer.do(description: 'move_to_xpath') {
      element = get_element xpath
      @@driver.mouse.move_to element
    }
  end

  def select_xpath(xpath, option)
    wait_for_xpath_to_display xpath

    @@retryer.do(description: 'select_xpath') {
      element = get_element xpath
      Selenium::WebDriver::Support::Select.new(element).select_by(:text, option)
    }
  end

  def send_keys_xpath(xpath, args)
    wait_for_xpath_to_display xpath

    @@retryer.do(description: 'send_keys_xpath') {
      element = get_element xpath
      element.send_keys args
    }
  end

  def send_keys_slowly_xpath(xpath, text, speed=0.8)
    wait_for_xpath_to_display xpath

    text.each_char { |c|
      send_keys_xpath(xpath, c)
      sleep(speed)
    }
  end

  def set_xpath(xpath, args)
    clear_xpath xpath
    send_keys_xpath xpath, args
  end

  def switch_iframe(xpath)
    wait_for_xpath_to_display xpath

    @@retryer.do(description: 'switch_iframe') {
      element = get_element xpath
      @@driver.switch_to.frame(element)
    }
  end

  def switch_to_first_frame
    @@retryer.do(description: 'switch_to_first_frame') {
      @@driver.switch_to.window(@@driver.window_handles.first)
    }
  end

  def switch_to_last_frame
    @@retryer.do(description: 'switch_to_last_frame') {
      @@driver.switch_to.window(@@driver.window_handles.last)
    }
  end

  def text_displayed?(text)
    elements = nil
    @@retryer.do(description: 'text_displayed?') {
      elements = @@driver.find_elements(:xpath, "//*[contains(.,'#{text}')]")
    }

    elements.each do |element|
      if element.displayed? == true
        return true
      end
    end
    return false
  end

  def wait_for_xpath_to_be_enabled(xpath)
    @@wait.until(description: 'wait_for_xpath_to_be_enabled') { xpath_enabled? xpath }
  end

  def wait_for_xpath_to_display(xpath)
    @@wait.until(description: 'wait_for_xpath_to_display') { xpath_displayed? xpath }
  end

  def wait_for_xpath_to_exist(xpath)
    @@wait.until(description: 'wait_for_xpath_to_exist') { xpath_exists? xpath }
  end

  def xpath_displayed?(xpath)
    @@retryer.do(description: 'xpath_displayed?') {
      element = get_element xpath
      if element.nil?
        false
      else
        element.displayed?
      end
    }
  end

  def xpath_enabled?(xpath)
    wait_for_xpath_to_exist xpath

    @@retryer.do(description: 'xpath_enabled?') {
      element = get_element xpath
      element.enabled?
    }
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

    @@retryer.do(description: 'xpath_selected?') {
      element = get_element xpath
      element.selected?
    }
  end
  
  def method_missing(method, *args, &block)
    method = method.to_s
    if method[-11..-1]=='_displayed?'
      extracted=method[0..-12]
      @eval = "xpath_displayed? @#{extracted}"
    elsif method[-10..-1]=='_selected?'
      extracted=method[0..-11]
      @eval = "xpath_selected? @#{extracted}"
    elsif method[0..3]=="get_" && method[-5..-1]=='_text'
      extracted=method[4..-6]
      @eval = "get_xpath_text(@#{extracted})"
    elsif method[0..5]=='click_'
      extracted=method[6..-1]
      @eval = "click_xpath @#{extracted}"
    elsif method[0..3]=="set_"
      extracted=method[4..-1]
      @eval = "set_xpath(@#{extracted},args)"
    elsif method[0..6]=="select_"
      extracted=method[7..-1]
      @eval = "select_xpath(@#{extracted},args[0])"
    else
      raise "Method not found for: #{method}"
    end

    eval @eval

  end
end
