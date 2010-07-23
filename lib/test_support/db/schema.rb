require 'sniff/database'

Sniff::Database.define_schema do
  create_table "automobile_records", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date"
    t.float    "fuel_efficiency"
    t.float    "urbanity"
    t.float    "annual_distance_estimate"
    t.float    "weekly_distance_estimate"
    t.float    "daily_distance_estimate"
    t.float    "daily_duration"
    t.date     "acquisition"
    t.boolean  "hybridity"
    t.date     "retirement"
    t.string   "make_id"
    t.string   "model_id"
    t.string   "model_year_id"
    t.string   "variant_id"
    t.string   "size_class_id"
    t.string   "fuel_type_id"
  end
end
