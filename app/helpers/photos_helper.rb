module PhotosHelper
  def staff_select(zone_id = nil)
    if zone_id
      @staff = Staff.all.where(zone_id: zone_id)
    else
      @staff = Staff.all
    end
    select = []
    @staff.all.each do |staff|
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

  def select_eq(zone_id= nil)
    if zone_id
      staff = Staff.equipment.where(zone_id: zone_id)
    else
      staff = Staff.equipment
    end
    select = []
    staff.each do |eq|
      select << [eq.name, eq.id]
    end
    select
  end
end
