module PhotosHelper
  def staff_select
    select = []
    Staff.all.each do |staff|
      select << [staff.name, staff.id]
    end
    select
  end

  def select_zones
    select = []
    Staff.zones.each do |zone|
      select << [zone.name, zone.id]
    end
    select
  end

  def select_eq
    select = []
    Staff.equipment.each do |eq|
      select << [eq.name, eq.id]
    end
    select
  end
end
