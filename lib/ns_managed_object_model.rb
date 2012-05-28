class NSManagedObjectModel

	def add_entities(entities_to_add)
    raise ArgumentError, "You must provide an entities or an empty array" if entities_to_add.nil?
		setEntities(entities + entities_to_add)
	end

	def add_entity(entity)
    raise ArgumentError, "You must provide an entity" if entity.nil?
    if entities.nil?
      setEntities([ entity ])
    else
      setEntities([ entity ] + entities)
    end
	end
  
	def remove_entity(entity)
    raise ArgumentError, "You must provide an entity" if entity.nil?
		setEntities(entities - [ entity ])
	end
  
  def entity_for_name(name)
    raise ArgumentError, "You must provide a name" if name.nil?
    entities.each do |e|
      return e if e.name == name
    end
    nil
  end

end