class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.text :citation
      t.string :app_title
      t.string :specimen_prefix
      t.string :breadcrumb_title1
      t.string :breadcrumb_title2
      t.string :breadcrumb_link1
      t.string :breadcrumb_link2
      t.string :institution
      t.string :institution_address
      t.string :institution_code
    end
    Setting.instance.update_attributes(:app_title => "N.C.W. Beadle Herbarium",
                                        :specimen_prefix => "NE",
                                        :breadcrumb_title1 => "UNE Home",
                                        :breadcrumb_title2 => "Herbarium",
                                        :breadcrumb_link1 => "http://www.une.edu.au",
                                        :breadcrumb_link2 => "http://www.une.edu.au/herbarium",
                                        :institution => "University of New England",
                                        :institution_address => "Armidale NSW 2351 Australia",
                                        :institution_code => "UNE",
                                        :citation => "Please cite use of this database in papers, theses, reports, etc. as follows:\n\"NE-db (year). N.C.W. Beadle Herbarium (NE) database (NE-db). Version 1, Dec 2010 [and more or less continuously updated since] www.une.edu.au/herbarium/nedb, accessed [day month year].\"\nAnd/or acknowledge use of the data as follows:\n\"I/we acknowledge access and use of data from the N.C.W. Beadle Herbarium (NE) database (NE-db).\"")
  end

  def self.down
    drop_table :settings
  end
end
