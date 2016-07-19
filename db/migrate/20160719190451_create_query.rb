require './models/query'

class CreateQuery < ActiveRecord::Migration
  def up
  	create_table :queries do |t|
  		t.string :text
  		t.timestamps
  	end
  	add_column :results, :query_id, :integer

  	Result.all.each do |result|
  		result.query_id = Query.find_or_create_by(text: result.query).id
  		result.save
  	end

  	remove_column :results, :query, :string
  end

    def down
  	add_column :results, :query, :string

  	Result.all.each do |result|
  		result.query = Query.find(result.query_id).text
  		result.save
  	end
  	
  	remove_column :results, :query_id
  	remove_table :queries
  end
end
