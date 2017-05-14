Sequel.migration do
  change do

    create_table :hits do
      primary_key :id
      Integer :hits
    end

  end
end
