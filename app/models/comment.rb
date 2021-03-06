class Comment < SQLObject
  finalize!

  validates :body, :author_id, presence: true
  
  belongs_to :author,
    class_name: "User",
    foreign_key: :author_id
end
