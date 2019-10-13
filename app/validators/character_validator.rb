class CharacterValidator < ActiveModel::Validator

  def validate(char)

    # Sum of HP, ATT and DEF should be equal to or less than 500
    binding.pry

  end

end
