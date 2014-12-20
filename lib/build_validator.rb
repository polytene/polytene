class BuildValidator < ActiveModel::Validator
  def validate(record)
    record.errors[:project_branch_id] << "Specified project_branch doesn't match specified project_id" unless project_branch_from_the_same_project(record)
  end

  private

  def project_branch_from_the_same_project(record)
    !(record.project_branch_id && record.project_branch && record.project_id != record.project_branch.project_id)
  end
end
