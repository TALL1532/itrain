hash = {} 
categories =  Dir["../Resources/categories/*"]
categories.each { |filename|
	file = File.new(filename, "r")
	while (line = file.gets)
        line = line.gsub("\n","").to_sym
    	puts "#{line}"
    	if hash[line]
    		hash[line] += 1
    	else
    		hash[line] = 1
    	end
	end
	file.close
}
hash.each_pair{ |key, value|
    if value > 1
        puts "found #{key.to_s} #{value} times" 
    end
}