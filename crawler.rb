require 'capybara'

Capybara.run_server = false
Capybara.current_driver = :selenium
Capybara.app_host = ""

module MyCapybara
  class Test
    include Capybara::DSL
    def query(params)
      visit("")

      @term = ""
      @sub_term = ""
      filter(params)
      fill_in "", with: @term
      click_button "search"
            
      begin
        if not @sub_term
          find("#ctl00").click
        else
          all("td", :text => @sub_term)[-1].find(:xpath,"..").all("td")[4].find("a").click
        end
      rescue
        return "Not found"
      end

      find("#ctl00").click
      begin
        @form = find("#ctl00").find("tbody").all("tr")
      rescue
        return "Not found"
      end
      return calculate_items
    end

    def filter(params)
      if params.include?("")
        index = params.index("")
        @term = params[0..index+1]
        @sub_term = params[index+2..-1]
      else
        @term = params
        @sub_term = nil
      end
    end

    def calculate_items
      total = 0
      @form.each_with_index do |row,index|
          next if index == 0
          tds = row.all("td")
          total += tds[2].text.to_i if tds[0].text.include?("")
      end
      return total
    end

  end
end

crawler = MyCapybara::Test.new
list = File.read(File.expand_path("../new.txt",__FILE__)).split(",")
list.each do |item|
  num = crawler.query(item)
  File.open("query.txt","a") {|file|
    file.write("#{item}: #{num}\n")
  }
end
