class Query < ActiveRecord::Base
	has_many :results

	def self.destroy_result(result_id)
		# Make sure they have permission to destroy
	  result = Result.find result_id
		query = result.query
		result.destroy!
		# Make sure we also delete the query if it has no results now
	  if query.results.count == 0
	    query.destroy!
	  end
	end
	
end
