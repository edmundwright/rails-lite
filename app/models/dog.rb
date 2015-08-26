class Dog < SQLObject
  finalize!
  validates :name, :breed, presence: true
end
