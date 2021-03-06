class Work < ApplicationRecord
  has_many :votes
  validates :title, presence: true, uniqueness: true
  validates :category, presence: true

  def self.sort_by_votes
    return [] if Work.all.empty?
    return Work.all if Vote.all.empty? #warning: circulating work_id, user_id
    return Work.find_by_sql("SELECT COUNT(votes.work_id), works.id, title, creator, publication_year, category, description
                              FROM works LEFT JOIN votes 
                              ON works.id = votes.work_id 
                              GROUP BY works.id, title, creator, publication_year, category, description
                              ORDER BY COUNT(votes.work_id) desc")
  end

  def self.spotlight
    return nil if Work.all.empty?
    return nil if Vote.all.empty?
    return self.sort_by_votes.first
  end
end
