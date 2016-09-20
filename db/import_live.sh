heroku pg:backups capture -a opensit
curl -o latest.dump `heroku pg:backups public-url -a opensit`
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U dan -d opensit_development latest.dump
rm latest.dump
