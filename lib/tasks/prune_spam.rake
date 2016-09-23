desc "Prune accounts with spam patterns in their emails"
task :prune_spam => :environment do
  total = 0

  # Email and website pattern matching
  User.all.each do |u|
    user_already_deleted = false
    Blacklist::EMAIL_PATTERNS.each do |pattern|
      next if user_already_deleted

      if (u.website =~ pattern) || (u.email =~ pattern)
        if (u.sits.size == 0)
          u.destroy
          puts "#{total}. #{u.username} deleted by pattern #{pattern}: #{u.email} | #{u.website}".red
          total += 1
          user_already_deleted = true
          next
        end
      end
    end
  end

  # Akismet spam detection
  # Date query used to protect early users from pre-spam era
  User.where("created_at > ?", Date.parse('2016-01-30')).order("created_at ASC").each do |u|
    vitals = "#{u.username} #{u.website} #{u.email} #{u.first_name} #{u.last_name} #{u.who} #{u.why} #{u.style} #{u.city} : #{u.country} : #{u.practice}"
    if u.spam?
      if (u.sits.size == 0)
        u.destroy
        total += 1
        puts "#{total}. AKISMET spam #{vitals}".red
      end
    else
      puts vitals.green
    end
  end
end
