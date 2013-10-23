role :web, "ic2-herbarium-qa-vm.intersect.org.au"                          # Your HTTP server, Apache/etc
role :app, "ic2-herbarium-qa-vm.intersect.org.au"                         # This may be the same as your `Web` server
role :db,  "ic2-herbarium-qa-vm.intersect.org.au", :primary => true       # This is where Rails migrations will run

