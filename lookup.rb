def get_command_line_argument
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument

dns_raw = File.readlines("zone")

def parse_dns(raw)
  parsed =
    raw
      .reject { |line| (line.strip.empty?) || (line.start_with? "#") }
      .map { |line| line.strip.split(", ") }
      .each_with_object({}) do |record, records|
      records[record[1]] = {
        :type => record[0],
        :target => record[2],
      }
    end
  parsed
end

def resolve(dns_records, lookup_chain, domain)
  record = dns_records[domain]
  if (!record)
    lookup_chain << "Error: Record not found for " + domain
  elsif record[:type] == "CNAME"
    lookup_chain << record[:target]
    return resolve(dns_records, lookup_chain, record[:target])
  elsif record[:type] == "A"
    lookup_chain << record[:target]
    return lookup_chain
  else
    lookup_chain << "Invalid record type for " + domain
  end
end

# To complete the assignment, implement `parse_dns` and `resolve`.

dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
