class NSManagedObject
  TYPE_MAPPING = {
    :undefined     => NSUndefinedAttributeType,
    :string        => NSStringAttributeType,
    :date          => NSDateAttributeType,
    :decimal       => NSDecimalAttributeType,
    :float         => NSFloatAttributeType,
    :double        => NSDoubleAttributeType,
    :boolean       => NSBooleanAttributeType,
    :integer16     => NSInteger16AttributeType,
    :integer32     => NSInteger16AttributeType,
    :integer64     => NSInteger16AttributeType,
    :binary        => NSBinaryDataAttributeType,
    :transformable => NSTransformableAttributeType,
    :id            => NSObjectIDAttributeType
  }
  
  class << self
      
    def create(values = { })
      new_entity = MotionRecord::Manager.instance.new_object_for_name(self.to_s)
      values.each do |key, value|
        message = "set#{key.capitalize}:"
        if new_entity.respond_to?(message)
          new_entity.send("#{message}", value)
        end
      end
      new_entity
    end
  
  end

public

  class << self
    
    def find(object_id)
      return nil if object_id.nil?
    
      error_ptr = Pointer.new(:object)
      entity = MotionRecord::Manager.instance.context.existingObjectWithID(object_id, error:error_ptr)
      puts "#{error_ptr[0]}" if entity.nil?
      entity
    end

    def all
      error_ptr = Pointer.new(:object)
      all = MotionRecord::Manager.instance.execute_fetch_request(create_fetch_request, error:error_ptr)
      puts "#{error_ptr[0]}" if all.nil?
      all
    end
  
    def where(expression = nil, *args)
      error_ptr = Pointer.new(:object)
      request = create_fetch_request
      request.predicate = NSPredicate.predicateWithFormat(expression, args)
      entities = MotionRecord::Manager.instance.execute_fetch_request(request, error:error_ptr)
      puts "#{error_ptr[0]}" unless error_ptr[0].nil?
      entities    
    end
    
    def count(expression = nil, *args)
      error_ptr = Pointer.new(:object)
      request = create_fetch_request
      request.predicate = NSPredicate.predicateWithFormat(expression, args) unless expression.nil?
      count = MotionRecord::Manager.instance.context.countForFetchRequest(request, error:error_ptr)
      puts "#{error_ptr[0]}" if error_ptr[0].nil?
      count
    end
    
    def order(name, ascending = true)
      error_ptr = Pointer.new(:object)
      request = create_fetch_request
      request.sortDescriptors = [ NSSortDescriptor.sortDescriptorWithKey(name, ascending:ascending) ]
      entities = MotionRecord::Manager.instance.execute_fetch_request(request, error:error_ptr)
      puts "#{error_ptr[0]}" if entities.nil?
      entities
    end
  
  private
    def create_fetch_request
      request = NSFetchRequest.alloc.init
      request.entity = MotionRecord::Manager.instance.entity_for_name(self.to_s)
      request
    end

  end
    
  # Save
  
  def save
    MotionRecord::Manager.instance.save
    self
  end
  
  def save?
    MotionRecord::Manager.instance.save
  end
  
  # Delete
  
  def destroy
    MotionRecord::Manager.instance.context.deleteObject self
  end
  
  def new_record?
    committedValuesForKeys(nil).empty?
  end
  
  def valid?
    err = Pointer.new(:object)
    v = new_record? ? validateForInsert(err) : validateForUpdate(err)
    yield(v, err[0]) if block_given?
    v
  end
  
  def errors
    errors = {}
    valid? do |valid, error|
      next if error.nil?
      if error.code == NSValidationMultipleErrorsError
        errs = error.userInfo[NSDetailedErrorsKey]
        errs.each do |nserr|
          errors[nserr.userInfo["NSValidationErrorKey"]] = message_for_error_code(nserr.code)
        end
      else
        errors[error.userInfo['NSValidationErrorKey']] = message_for_error_code(error.code)
      end
    end
    errors
  end
  
private
  def message_for_error_code(c)
    message = case c
      when NSValidationMissingMandatoryPropertyError
        "can't be blank"
      when NSValidationNumberTooLargeError
        "too large"
      when NSValidationNumberTooSmallError
        "too small"
      when NSValidationDateTooLateError
        "too late"
      when NSValidationDateTooSoonError
        "too soon"
      when NSValidationInvalidDateError
        "invalid date"
      when NSValidationStringTooLongError
        "too long"
      when NSValidationStringTooShortError
        "too short"
      when NSValidationStringPatternMatchingError
        "incorrect pattern"
      when NSValidationRelationshipExceedsMaximumCountError
        "too many"
      when NSValidationRelationshipLacksMinimumCountError
        "too few"
      when NSValidationRelationshipDeniedDeleteError
        "can't delete"
      when NSManagedObjectValidationError
        "invalid"
      end
  end
    
end