class MaterialPolicy < ApplicationPolicy

  # This policy is currently not implemented because there is no crud for this model
  # These are added and removed by developers and only used to create an association
  # They are static values
  # Maybe there is some way this policy should be implemented?
  # but I believe implementing this would have no effect and both admin and techs are allowed to view this objects from this model and create the associations
  # Need to add in the verification after action and then test creating the association with materials
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

end
