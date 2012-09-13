module Jekyll

  class SiteNavigation < Jekyll::Generator
    safe true
    priority :lowest

    def generate(site)

        # First remove all invisible items (default: nil = show in nav)
        sorted = []
=begin
	puts "old file order"
       site.pages.each do |page|
         puts page.inspect
       end
=end

       # site.pages.each do |page|
        #  sorted << page
        #end

        # Then sort em according to weight
       #sorted1 = sorted.sort{ |a,b| a.data["order"] <=> b.data["order"] } 

        # Debug info.
        # puts "Sorted resulting navigation:  (use site.config['sorted_navigation']) "
	site.config["navigation_order"].each do |url|
            site.pages.each do |p|
	      if p.url == url
		sorted << p
      	      end
            end
	end
=begin
	puts "new file order"
        sorted.each do |p|
          puts p.inspect
        end
=end
        # Access this in Liquid using: site.navigation
        site.config["navigation"] = sorted
    end
  end
end

