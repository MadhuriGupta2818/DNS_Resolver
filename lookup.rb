def get_command_line_argument
    if ARGV.empty?
      puts "Usage: ruby lookup.rb <domain>"
      exit
    end
    ARGV.first
  end
domain = get_command_line_argument 
dns_raw = File.readlines("zone")
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
  dns_records = parse_dns(dns_raw)
  lookup_chain = [domain]
  lookup_chain = resolve(dns_records, lookup_chain, domain)
  puts lookup_chain.join(" => ")
