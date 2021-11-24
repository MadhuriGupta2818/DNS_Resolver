def get_command_line_argument
    # ARGV is an array that Ruby defines for us,
    # which contains all the arguments we passed to it
    # when invoking the script from the command line.
    # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
    if ARGV.empty?
      puts "Usage: ruby lookup.rb <domain>"
      exit
    end
    ARGV.first
  end
  
  # `domain` contains the domain name we have to look up.
  domain = get_command_line_argument
  
  # File.readlines reads a file and returns an
  # array of string, where each element is a line
  # https://www.rubydoc.info/stdlib/core/IO:readlines
  dns_raw = File.readlines("zone")
  
  # ..
  # ..
  # FILL YOUR CODE HERE
  def parse_dns(dns_raw)
        hash= {}
        dns_raw.each do |record|
            record = record.split(",")
            if record.length() > 1 && record[0] != "# RECORD TYPE"
                hash[record[1].strip()] = record[2].strip()
            end
        end
    return hash
    end

def resolve(dns_records, lookup_chain, domain)
      if lookup_chain[-1].is_a? String 
        lookup_chain.push(dns_records[domain])
        resolve(dns_records, lookup_chain,lookup_chain[-1])
      end
    
    res = lookup_chain[0..-2]
    if res.length<2
      puts "Error: record not found for " + lookup_chain[0]
      exit
    end
    return lookup_chain[0..-2]
    end
  # ..
  
  # To complete the assignment, implement `parse_dns` and `resolve`.
  # Remember to implement them above this line since in Ruby
  # you can invoke a function only after it is defined.
  dns_records = parse_dns(dns_raw)
  lookup_chain = [domain]
  lookup_chain = resolve(dns_records, lookup_chain, domain)
  puts lookup_chain.join(" => ")