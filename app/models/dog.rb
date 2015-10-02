class Comment < SQLObject
  finalize!
  validates :body, :author_id, presence: true
end
