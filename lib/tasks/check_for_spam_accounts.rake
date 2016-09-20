desc "Check for spam accounts"
task :spam_tally => :environment do
  total = 0
  User.where("created_at > ?", Date.parse('2016-01-30')).order("created_at ASC").each do |u|
    puts u.created_at
    if u.spam?
      total += 1
      puts "#{total} / #{u.username} - #{u.website} - #{u.email} - #{u.first_name} #{u.last_name} #{u.who} #{u.why} #{u.style}".red
      puts "#{u.city} : #{u.country} : #{u.practice}".red
      sleep 0.5
    else
      puts "#{u.username} - #{u.email}".green
    end
  end
  puts "Found #{total} spam accounts"
end
