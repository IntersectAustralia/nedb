class ChangePeopleDisplayNameToInitials < ActiveRecord::Migration
  def self.up
    add_column :people, :initials, :string
    Person.all.each do |p|
      s = p.display_name.split(',')
      p.last_name = s[0].to_s.strip
      p.initials = s[1].to_s.strip
      p.save!
    end
    remove_column :people, :display_name
  end

  def self.down
    add_column :people, :display_name, :string
    Person.all.each do |p|
      s = p.last_name
      if not p.initials.blank?
        s.concat ", #{p.initials}"
      end
      p.display_name = s
    end
    remove_column :people, :initials
  end
end
