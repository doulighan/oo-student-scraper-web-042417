require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    students = Nokogiri::HTML(html)
   
    student_array = []
    students.css("div.student-card").each do |student|
      student_array << {
        name: student.css("h4.student-name").text,
        location: student.css("p.student-location").text,
        profile_url: "./fixtures/student-site/#{student.css("a").attribute("href").value}"
      }
   end
   student_array
  end


  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    student = Nokogiri::HTML(html)

    info_hash = {}
    student.css("div.social-icon-container").each do |icons|
      icons.css("a").each do |icon|
        link = icon.values[0]
        if link.include?("twitter")
          info_hash[:twitter] = link
        elsif link.include?("linkedin")
          info_hash[:linkedin] = link
        elsif link.include?("github")
          info_hash[:github] = link
        else 
          info_hash[:blog] = link
        end
      end 
    end
    info_hash[:profile_quote] = student.css("div.profile-quote").text
    info_hash[:bio] = student.css("div.description-holder p").text
    info_hash
  end

end

Scraper.scrape_profile_page("./fixtures/student-site/students/ryan-johnson.html")
