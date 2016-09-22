desc "Prune accounts with spam patterns in their emails"
task :prune_spam => :environment do
  total = 0
  User.all.each do |u|
    Blacklist::EMAIL_PATTERNS.each do |pattern|
      if (u.website =~ pattern) || (u.email =~ pattern)
        if (u.sits.size == 0)
          u.destroy
          p "#{total}. #{u.username} deleted: #{u.email} | #{u.website}"
          total += 1
        end
      end
    end
  end
end
