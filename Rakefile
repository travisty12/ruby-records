desc 'Create db dump'
task :dump, [:db_name] do |t, args|
  system("pg_dump #{args.db_name} > records_db_backup.sql")
end

desc 'Create db and test db from the db dump'
task :build, [:db_name] do |t, args|
  system("createdb #{args.db_name}")
  system("psql #{args.db_name} < records_db_backup.sql")
  system("createdb -T #{args.db_name} #{args.db_name + '_test'}")
end