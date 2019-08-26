module PhotosHelper
  def staff_select
    select = []
    Staff.all.each do |staff|
      select << [staff.name, staff.id]
    end
    select
  end
end
