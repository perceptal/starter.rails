class Searcher
  def self.search(query, type, skip, limit, key)
    if query.empty?
      []
    else
      results = results(query, type, key.min, key.max)
    end
    
    if (limit > 0)
      results.limit(limit).offset(skip)
    else
      results
    end
  end

  def self.count(query, type, key)
    if query.empty?
      0
    else
      results(query, type, key.min, key.max).size
    end
  end

  private

  def self.results(criteria, type, low, high)
    Person
      .includes(:user)
      .where(query, :type => type, :query => criteria.upcase + "%", :low => low, :high => high)
  end

  def self.query
    "(UPPER(first_name) LIKE :query OR 
     UPPER(last_name) LIKE :query OR 
     UPPER(first_name||' '||last_name) LIKE :query OR
     UPPER(users.email) LIKE :query OR 
     UPPER(users.username) LIKE :query) AND
     (type = :type OR :type = '') AND 
     low_security_key >= :low AND high_security_key <= :high"
  end

  def self.detailed(patient, tags, text, skip, limit, key)
    if (patient + tags + text).empty?        
      []
    else
      results = detailed_results(patient, tags, text, key)
    end
      
    if (limit > 0)
      results.limit(limit).offset(skip)
    else
      results
    end
  end

  def self.detailed_results(patient, tags, text, key)
    Person
      .includes(:user)
      .where(query, :type => "", :query => patient.upcase + "%", :low => key.min, :high => key.max)
  end

  def self.detailed_count(patient, tags, text, key)
    if (patient + tags + text).empty?
      0
    else
      detailed_results(patient, tags, text, key).size
    end
  end
end