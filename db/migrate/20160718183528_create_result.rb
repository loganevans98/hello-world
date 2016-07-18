class CreateResult < ActiveRecord::Migration
  def change
  	create_table :results do |t|
  		t.string :query
  		t.string :image_url
  		t.timestamps
  	end
  end
end
