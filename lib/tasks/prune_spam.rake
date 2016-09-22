desc "Prune accounts with spam patterns in their emails"
task :prune_spam => :environment do
  total = 0
  User.all.each do |u|
    Blacklist::EMAIL_PATTERNS.each do |pattern|
      if u.email =~ pattern
        u.destroy
        p "#{total}. Account deleted: #{u.email} | #{u.username}"
        total += 1
      end
    end
  end
end
