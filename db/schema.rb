Sequel.migration do
  change do
    create_table(:hits) do
      primary_key :id
      column :hits, "integer"
    end
    
    create_table(:schema_migrations) do
      column :filename, "varchar(255)", :null=>false
      
      primary_key [:filename]
    end
  end
end
Sequel.migration do
  change do
    self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20170514004640_create_hits.rb')"
  end
end
