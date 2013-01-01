role :web, "gsw1-une-nedb-vm.intersect.org.au"                          # Your HTTP server, Apache/etc
role :app, "gsw1-une-nedb-vm.intersect.org.au"                         # This may be the same as your `Web` server
role :db,  "gsw1-une-nedb-vm.intersect.org.au", :primary => true       # This is where Rails migrations will run

