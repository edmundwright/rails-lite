class Dog < SQLObject
  finalize!

  def save
    @errors << "Name must be present" if name.empty?
    @errors << "Breed must be present" if breed.empty?
    return false if name.empty? || breed.empty?

    super
  end
end
