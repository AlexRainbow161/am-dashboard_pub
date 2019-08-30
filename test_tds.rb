require 'tiny_tds'

def process_row(row)
  puts row
  downcaserow = {}
  row.each do |key, value|
    downcaserow.merge!("#{key.downcase}": value)
  end
  puts downcaserow
end

client = TinyTds::Client.new username: "SDUserRead", password: "SDUserRead", dataserver: "REKS:49768", database: "referen"
results = client.execute("select
       t.Code,
       t.Name,
       t.BaseIDD,
       t.Region,
       t.IDD,
       t.time_start,
       t.time_end,
       t.opening_date,
       t.zone
       ,t.State as s_stat
       ,t.Phone
       ,t.PhoneExt
       ,t.email
       ,t.Addr
from
       (
       select
             rtrim(SKL.code) Code,
             rtrim(SKL.Descr) Name,
             rtrim(SKL.sp12319) BaseIDD,
             rtrim(REG.Descr) as Region,
             SKL.SP5388 as IDD,
             METADATA.NAME as State
             ,rtrim(SKL.SP6931) as Phone
             ,rtrim(SKL.SP13276) as PhoneExt
             ,rtrim(skl.SP12320) as email
             ,rtrim(skl.SP6930) as Addr
         , ltrim(rtrim((
                    select top 1
                    left(c12152_vv.value, 5)
                    from
                    _1sconst as c12152_vv (nolock)
                    where
                    c12152_vv.id = 12500 and
                    c12152_vv.objid = SKL.ID and
                    (c12152_vv.date <= CONVERT(date, getdate()))
                    order by c12152_vv.date desc, c12152_vv.time desc, c12152_vv.docid desc, c12152_vv.row_id desc
                    ))) as time_start,

          ltrim(rtrim((
                    select top 1
                    left(c12152_vv.value, 5)
                    from
                    _1sconst as c12152_vv (nolock)
                    where
                    c12152_vv.id = 12501 and
                    c12152_vv.objid = SKL.ID and
                    (c12152_vv.date <= CONVERT(date, getdate()))
                    order by c12152_vv.date desc, c12152_vv.time desc, c12152_vv.docid desc, c12152_vv.row_id desc
                    ))) as time_end,

          SKL.SP13630 as opening_date,
          rtrim(time_zone.DESCR) as zone
             from
             sc31 as SKL (nolock)
             left join sc6951 as REG (nolock) on REG.id =  SKL.sp12645
             left join SC13697 as time_zone (nolock) on  SKL.SP13687 = time_zone.ID
             left join METADATA on SKL.SP9330 = METADATA.IDNAME

       ) as t
       where time_end is not null and time_end<>':'
             --and State != 'Закрыт'")
counter = 0
results.each do |row|
  process_row(row)
  puts "*****************"
  puts "\n"
  counter = counter + 1
end
puts "Total rows #{counter}"