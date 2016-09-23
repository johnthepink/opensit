desc "Check for spam accounts"
task :spam_tally => :environment do
  total = 0
  User.where("created_at > ?", Date.parse('2016-01-30')).order("created_at ASC").each do |u|
    puts u.created_at
    vitals = "#{u.username} #{u.website} #{u.email} #{u.first_name} #{u.last_name} #{u.who} #{u.why} #{u.style} #{u.city} : #{u.country} : #{u.practice}"
    if u.spam?
      total += 1
      puts "#{total} #{vitals}".red
    else
      puts vitals.green
    end
  end
  puts "Found #{total} spam accounts"
end
